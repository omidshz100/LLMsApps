import SwiftUI

struct DocChatScreen: View {
    @StateObject private var viewModel: DocChatViewModel
    @Environment(\.presentationMode) var presentationMode
    
    init(document: Document) {
        _viewModel = StateObject(wrappedValue: DocChatViewModel(document: document))
    }
    
    var body: some View {
        VStack(spacing: 0) {
            // Grounding banner
            HStack(spacing: 12) {
                ZStack {
                    RoundedRectangle(cornerRadius: 8)
                        .fill(AppTheme.accentSoft)
                        .frame(width: 34, height: 34)
                    AppIcon(name: "docText", size: 16, color: AppTheme.accent, weight: .regular)
                }
                
                VStack(alignment: .leading, spacing: 2) {
                    Text(viewModel.document.name)
                        .typeFootnote()
                        .fontWeight(.semibold)
                        .foregroundColor(AppTheme.textPrimary)
                        .lineLimit(1)
                    Text("Answers grounded in this document")
                        .typeCaption1()
                        .foregroundColor(AppTheme.textSecondary)
                }
                
                Spacer()
                
                HStack(spacing: 4) {
                    AppIcon(name: "sparkle", size: 12, color: AppTheme.accent, weight: .regular)
                    Text("RAG")
                        .typeCaption1()
                        .fontWeight(.semibold)
                }
                .padding(.horizontal, 9)
                .padding(.vertical, 4)
                .background(AppTheme.accentSoft)
                .foregroundColor(AppTheme.accent)
                .cornerRadius(100)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 10)
            .background(AppTheme.bg)
            .overlay(
                Rectangle()
                    .frame(height: 0.5)
                    .foregroundColor(AppTheme.separator)
                    .padding(.top, 54),
                alignment: .bottom
            )
            
            // Chat area
            ScrollViewReader { proxy in
                ScrollView {
                    VStack(spacing: 12) {
                        ForEach(viewModel.messages) { message in
                            Bubble(message: message)
                                .id(message.id)
                        }
                        
                        if viewModel.isGenerating && (viewModel.messages.last?.role == .user || viewModel.messages.isEmpty) {
                            ThinkingBubble(label: "Searching document…")
                                .id("thinking")
                        }
                    }
                    .padding(.horizontal, 16)
                    .padding(.bottom, 16)
                    .padding(.top, 16)
                }
                .onChange(of: viewModel.messages.count) { _ in
                    withAnimation {
                        if viewModel.isGenerating {
                            proxy.scrollTo("thinking", anchor: .bottom)
                        } else if let last = viewModel.messages.last {
                            proxy.scrollTo(last.id, anchor: .bottom)
                        }
                    }
                }
            }
            .background(AppTheme.bg)
            
            Composer(
                text: $viewModel.input,
                generating: viewModel.isGenerating,
                placeholder: "Message \(viewModel.modelName.split(separator: "-").first ?? "AI")…",
                onSend: { viewModel.sendMessage() },
                onStop: { viewModel.stopGeneration() }
            )
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .principal) {
                VStack {
                    Text(viewModel.document.name)
                        .font(.headline)
                        .lineLimit(1)
                    Text("\(viewModel.document.chunks) chunks · \(viewModel.document.type.uppercased())")
                        .typeCaption1()
                        .foregroundColor(AppTheme.textSecondary)
                }
            }
            ToolbarItem(placement: .navigationBarTrailing) {
                NavButton(name: "info", label: "Document info") {}
            }
        }
    }
}
