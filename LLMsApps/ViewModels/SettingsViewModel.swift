import SwiftUI
import Combine
@MainActor
class SettingsViewModel: ObservableObject {
    @Published var settings: AppSettings {
        didSet {
            save()
        }
    }
    @Published var isReloading: Bool = false
    @Published var modelState: String = "ready"
    
    private let defaultsKey = "LLMsApp_Settings"
    
    private let llmService = LocalLlamaService.shared
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        if let data = UserDefaults.standard.data(forKey: defaultsKey),
           let saved = try? JSONDecoder().decode(AppSettings.self, from: data) {
            self.settings = saved
        } else {
            self.settings = .default
        }
        
        llmService.$status
            .receive(on: RunLoop.main)
            .assign(to: \.modelState, on: self)
            .store(in: &cancellables)
    }
    
    private func save() {
        if let data = try? JSONEncoder().encode(settings) {
            UserDefaults.standard.set(data, forKey: defaultsKey)
        }
    }
    
    func reloadModel() {
        isReloading = true
        llmService.unloadModel()
        
        Task {
            do {
                try await llmService.loadModel(settings: settings)
            } catch {
                print("Failed to load model: \(error.localizedDescription)")
            }
            Task { @MainActor in
                isReloading = false
            }
        }
    }
    
    func resetToDefaults() {
        settings = .default
        reloadModel()
    }
}
