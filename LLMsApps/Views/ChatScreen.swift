import SwiftUI

struct Bubble: View {
    let message: Message
    
    var body: some View {
        HStack {
            if message.role == .user {
                Spacer()
                Text(message.text)
                    .typeBody()
                    .padding(.horizontal, 16)
                    .padding(.vertical, 10)
                    .background(AppTheme.accent)
                    .foregroundColor(AppTheme.accentText)
                    .cornerRadius(20)
                    .padding(.leading, 40)
            } else {
                VStack(alignment: .leading, spacing: 6) {
                    Text(message.text)
                        .typeBody()
                        .foregroundColor(AppTheme.textPrimary)
                    
                    if let sources = message.sources, !sources.isEmpty {
                        HStack {
                            AppIcon(name: "sparkle", size: 12, color: AppTheme.accent, weight: .regular)
                            Text("Sources: \(sources.joined(separator: ", "))")
                        }
                        .typeCaption1()
                        .foregroundColor(AppTheme.accent)
                        .padding(.top, 4)
                    }
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 10)
                .background(AppTheme.bubbleAI)
                .cornerRadius(20)
                .padding(.trailing, 40)
                Spacer()
            }
        }
    }
}

struct ThinkingBubble: View {
    let label: String
    
    var body: some View {
        HStack {
            HStack(spacing: 8) {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle(tint: AppTheme.accent))
                    .scaleEffect(0.8)
                Text(label)
                    .typeSubhead()
                    .foregroundColor(AppTheme.textSecondary)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 10)
            .background(AppTheme.bubbleAI)
            .cornerRadius(20)
            Spacer()
        }
    }
}

struct Composer: View {
    @Binding var text: String
    let generating: Bool
    let placeholder: String
    let onSend: () -> Void
    let onStop: () -> Void
    
    var body: some View {
        VStack(spacing: 0) {
            Divider()
                .background(AppTheme.separator)
            
            HStack(alignment: .bottom, spacing: 10) {
                TextField(placeholder, text: $text, axis: .vertical)
                    .lineLimit(1...5)
                    .typeBody()
                    .padding(.horizontal, 16)
                    .padding(.vertical, 10)
                    .background(AppTheme.card)
                    .cornerRadius(20)
                    .overlay(
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(AppTheme.separator, lineWidth: 0.5)
                    )
                
                if generating {
                    Button(action: onStop) {
                        AppIcon(name: "stop", size: 36, color: AppTheme.accent, weight: .regular)
                    }
                } else {
                    Button(action: onSend) {
                        AppIcon(name: "arrowUp", size: 36, color: AppTheme.accent, weight: .regular)
                    }
                    .disabled(text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                    .opacity(text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ? 0.5 : 1.0)
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 8)
            .background(AppTheme.bg)
        }
    }
}

struct ChatScreen: View {
    @StateObject private var viewModel = ChatViewModel()
    @State private var showingSettings = false
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                ScrollViewReader { proxy in
                    ScrollView {
                        VStack(spacing: 12) {
                            Text("Today")
                                .typeCaption1()
                                .foregroundColor(AppTheme.textSecondary)
                                .padding(.top, 16)
                            
                            ForEach(viewModel.messages) { message in
                                Bubble(message: message)
                                    .id(message.id)
                            }
                            
                            if viewModel.isGenerating && (viewModel.messages.last?.role == .user || viewModel.messages.isEmpty) {
                                ThinkingBubble(label: "Thinking…")
                                    .id("thinking")
                            }
                        }
                        .padding(.horizontal, 16)
                        .padding(.bottom, 16)
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
            .navigationTitle("LLMsApp")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    VStack {
                        Text("LLMsApp")
                            .font(.headline)
                        StatusLine(state: viewModel.status, modelName: viewModel.modelName)
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    NavButton(name: "gear", label: "Settings") {
                        showingSettings = true
                    }
                }
            }
            .sheet(isPresented: $showingSettings) {
                SettingsScreen()
            }
        }
    }
}
