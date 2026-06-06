import SwiftUI
import Combine
@MainActor
class LibraryViewModel: ObservableObject {
    @Published var documents: [Document] = []
    @Published var isImporting: Bool = false
    
    func importDocument() {
        isImporting = true
        
        Task {
            // Simulate chunking and embedding time
            try? await Task.sleep(nanoseconds: 2_000_000_000)
            
            let types = ["pdf", "txt", "md"]
            let names = ["Apple_ML_Research.pdf", "Notes_Meeting.txt", "Architecture.md"]
            let randomIdx = Int.random(in: 0..<3)
            
            let newDoc = Document(
                name: names[randomIdx],
                chunks: Int.random(in: 10...500),
                type: types[randomIdx]
            )
            
            documents.insert(newDoc, at: 0)
            isImporting = false
        }
    }
    
    func deleteDocument(id: String) {
        documents.removeAll { $0.id == id }
    }
}
