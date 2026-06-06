import SwiftUI

struct MainTabView: View {
    var body: some View {
        TabView {
            ChatScreen()
                .tabItem {
                    Label("Chat", systemImage: "bubble.left")
                }
            
            LibraryScreen()
                .tabItem {
                    Label("Documents", systemImage: "folder")
                }
        }
        .tint(AppTheme.accent)
    }
}
