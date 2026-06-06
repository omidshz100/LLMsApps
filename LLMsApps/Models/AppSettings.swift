import Foundation

struct AppSettings: Codable {
    var modelName: String = "Llama-3.2-3B-Instruct-Q4_K_M"
    var useGPU: Bool = true
    var batchSize: Double = 64
    var maxTokenCount: Double = 1024
    
    var temperature: Double = 0.7
    var topP: Double = 0.9
    var topK: Int = 40
    
    var enableRepetitionPenalty: Bool = false
    var repetitionPenalty: Double = 1.1
    var frequencyPenalty: Double = 0.0
    var presencePenalty: Double = 0.0
    
    var useSystemPrompt: Bool = true
    var systemPrompt: String = "You are a helpful, harmless, and honest AI assistant."
    
    static let `default` = AppSettings()
}
