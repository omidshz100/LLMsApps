import Foundation

struct Document: Identifiable, Codable {
    let id: String
    let name: String
    let chunks: Int
    let type: String
    let timestamp: Date
    
    init(id: String = UUID().uuidString, name: String, chunks: Int, type: String, timestamp: Date = Date()) {
        self.id = id
        self.name = name
        self.chunks = chunks
        self.type = type
        self.timestamp = timestamp
    }
}
