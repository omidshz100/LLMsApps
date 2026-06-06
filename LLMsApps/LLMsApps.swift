import SwiftUI

@main
struct LLMsApp: App {
    var body: some Scene {
        WindowGroup {
            MainTabView()
                .preferredColorScheme(.light) // Force light mode
        }
    }
}
