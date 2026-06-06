import SwiftUI
import Combine

@MainActor
class DocChatViewModel: ObservableObject {
    @Published var messages: [Message] = []
    @Published var input: String = ""
    @Published var status: String = "ready"
    @Published var isGenerating: Bool = false
    @Published var modelName: String = ""
    
    let document: Document
    private let llmService = LocalLlamaService.shared
    private var cancellables = Set<AnyCancellable>()
    
    init(document: Document) {
        self.document = document
        
        let settings: AppSettings
        if let data = UserDefaults.standard.data(forKey: "LLMsApp_Settings"),
           let saved = try? JSONDecoder().decode(AppSettings.self, from: data) {
            settings = saved
        } else {
            settings = .default
        }
        self.modelName = settings.modelName
        
        llmService.$status
            .receive(on: RunLoop.main)
            .assign(to: \.status, on: self)
            .store(in: &cancellables)
            
        Task {
            do {
                try await llmService.loadModel(settings: AppSettings.default)
            } catch {
                print("Auto-load failed: \(error)")
            }
        }
    }
    
    func sendMessage() {
        guard !input.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else { return }
        
        let userMessage = Message(role: .user, text: input)
        messages.append(userMessage)
        
        let prompt = input
        input = ""
        isGenerating = true
        
        // Mock finding sources
        let assistantMessage = Message(role: .assistant, text: "", streaming: true, sources: ["Chunk #12", "Chunk #45"])
        messages.append(assistantMessage)
        let messageIndex = messages.count - 1
        
        Task {
            do {
                let stream = try await llmService.generate(prompt: prompt, documentContext: document, settings: AppSettings.default)
                for await chunk in stream {
                    messages[messageIndex].text += chunk
                }
                messages[messageIndex].streaming = false
            } catch {
                messages[messageIndex].text = "Error generating grounded response."
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
