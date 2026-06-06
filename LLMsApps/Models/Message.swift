import Foundation

struct Message: Identifiable, Codable {
    let id: String
    let role: Role
    var text: String
    var streaming: Bool
    var sources: [String]? // Mocked source document references
    
    enum Role: String, Codable {
        case user
        case assistant
        case system
    }
    
    init(id: String = UUID().uuidString, role: Role, text: String, streaming: Bool = false, sources: [String]? = nil) {
        self.id = id
        self.role = role
        self.text = text
        self.streaming = streaming
        self.sources = sources
    }
}
