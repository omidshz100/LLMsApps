import Foundation
import Combine
import SwiftUI
import EasyLlama

protocol LLMServiceProtocol {
    var status: String { get }
    func generate(prompt: String, documentContext: Document?, settings: AppSettings) async throws -> AsyncStream<String>
    func stop()
}

class LocalLlamaService: LLMServiceProtocol, ObservableObject {
    static let shared = LocalLlamaService()
    
    @Published var status: String = "notLoaded"
    private var cancellables = Set<AnyCancellable>()
    
    private let easyLlama = EasyLlama.shared
    
    init() {
        easyLlama.$status
            .receive(on: RunLoop.main)
            .assign(to: \.status, on: self)
            .store(in: &cancellables)
    }
    
    func loadModel(settings: AppSettings) async throws {
        try await easyLlama.loadModel(
            name: settings.modelName,
            batchSize: UInt32(settings.batchSize),
            maxTokenCount: UInt32(settings.maxTokenCount),
            useGPU: settings.useGPU
        )
    }
    
    func generate(prompt: String, documentContext: Document?, settings: AppSettings) async throws -> AsyncStream<String> {
        let systemPrompt = settings.useSystemPrompt ? settings.systemPrompt : "You are a helpful assistant."
        var finalPrompt = prompt
        
        if let doc = documentContext {
            finalPrompt = "Given the document '\(doc.name)', answer this: \(prompt)"
        }
        
        return try await easyLlama.generate(
            prompt: finalPrompt,
            systemPrompt: systemPrompt,
            temperature: Float(settings.temperature),
            topP: Float(settings.topP),
            topK: Int32(settings.topK)
        )
    }
    
    func stop() { 
        easyLlama.stop()
    }
    
    func unloadModel() {
        easyLlama.unloadModel()
    }
}
