import SwiftUI
import Combine

@MainActor
class ChatViewModel: ObservableObject {
    @Published var messages: [Message] = []
    @Published var input: String = ""
    @Published var status: String = "notLoaded"
    @Published var isGenerating: Bool = false
    
    @Published var modelName: String = ""
    
    private let llmService = LocalLlamaService.shared
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        self.modelName = getSettings().modelName
        
        llmService.$status
            .receive(on: RunLoop.main)
            .assign(to: \.status, on: self)
            .store(in: &cancellables)
            
        Task {
            do {
                try await llmService.loadModel(settings: getSettings())
            } catch {
                print("Auto-load failed: \(error)")
            }
        }
    }
    
    private func getSettings() -> AppSettings {
        if let data = UserDefaults.standard.data(forKey: "LLMsApp_Settings"),
           let saved = try? JSONDecoder().decode(AppSettings.self, from: data) {
            return saved
        }
        return .default
    }
    
    func sendMessage() {
        guard !input.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else { return }
        
        let settings = getSettings()
        
        let userMessage = Message(role: .user, text: input)
        messages.append(userMessage)
        
        let prompt = input
        input = ""
        isGenerating = true
        
        let assistantMessage = Message(role: .assistant, text: "", streaming: true)
        messages.append(assistantMessage)
        let messageIndex = messages.count - 1
        
        Task {
            do {
                let stream = try await llmService.generate(prompt: prompt, documentContext: nil, settings: settings)
                for try await chunk in stream {
                    messages[messageIndex].text += chunk
                }
                messages[messageIndex].streaming = false
            } catch {
                messages[messageIndex].text = "Error: \(error.localizedDescription)"
                messages[messageIndex].streaming = false
            }
            isGenerating = false
        }
    }
    
    func stopGeneration() {
        llmService.stop()
        isGenerating = false
        if let lastIndex = messages.indices.last, messages[lastIndex].role == .assistant {
            messages[lastIndex].streaming = false
        }
    }
}
