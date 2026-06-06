import SwiftUI

struct DocRow: View {
    let document: Document
    let onClick: () -> Void
    
    var body: some View {
        Button(action: onClick) {
            HStack(spacing: 12) {
                ZStack {
                    RoundedRectangle(cornerRadius: 8)
                        .fill(AppTheme.accentSoft)
                        .frame(width: 40, height: 40)
                    AppIcon(name: "docText", size: 20, color: AppTheme.accent, weight: .regular)
                }
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(document.name)
                        .typeBody()
                        .foregroundColor(AppTheme.textPrimary)
                        .lineLimit(1)
                    
                    Text("\(document.chunks) chunks · \(document.type.uppercased())")
                        .typeCaption1()
                        .foregroundColor(AppTheme.textSecondary)
                }
                Spacer()
                AppIcon(name: "chevronRight", size: 16, color: AppTheme.textTertiary, weight: .semibold)
            }
            .padding(.vertical, 8)
            .padding(.horizontal, 16)
        }
    }
}

struct EmptyLibraryView: View {
    let action: () -> Void
    
    var body: some View {
        VStack(spacing: 16) {
            Spacer()
            AppIcon(name: "folder", size: 48, color: AppTheme.textTertiary, weight: .regular)
            
            Text("No Documents Yet")
                .typeTitle3()
                .foregroundColor(AppTheme.textPrimary)
            
            Text("Import a PDF or text file. It’s chunked and embedded on-device so you can ask questions about it.")
                .typeBody()
                .foregroundColor(AppTheme.textSecondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 32)
            
            Button(action: action) {
                HStack {
                    AppIcon(name: "plus", size: 18, color: .white, weight: .semibold)
                    Text("Import Document")
                        .typeHeadline()
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 12)
                .background(AppTheme.accent)
                .foregroundColor(.white)
                .cornerRadius(12)
            }
            .padding(.top, 8)
            
            Spacer()
        }
    }
}

struct LibraryScreen: View {
    @StateObject private var viewModel = LibraryViewModel()
    
    var body: some View {
        NavigationStack {
            ZStack {
                AppTheme.bg.edgesIgnoringSafeArea(.all)
                
                if viewModel.documents.isEmpty && !viewModel.isImporting {
                    EmptyLibraryView(action: { viewModel.importDocument() })
                } else {
                    List {
                        if viewModel.isImporting {
                            HStack(spacing: 12) {
                                ProgressView()
                                Text("Chunking & embedding new file…")
                                    .typeSubhead()
                                    .foregroundColor(AppTheme.textSecondary)
                            }
                            .listRowBackground(AppTheme.card)
                        }
                        
                        Section(header: Text("Imported"), footer: Text("Swipe a row left to delete. Tap to chat with that document.")) {
                            ForEach(viewModel.documents) { doc in
                                NavigationLink(destination: DocChatScreen(document: doc)) {
                                    DocRow(document: doc, onClick: {})
                                }
                                .swipeActions(edge: .trailing) {
                                    Button(role: .destructive) {
                                        viewModel.deleteDocument(id: doc.id)
                                    } label: {
                                        Label("Delete", systemImage: "trash")
                                    }
                                }
                            }
                        }
                        
                        Section {
                            HStack {
                                Spacer()
                                AppIcon(name: "lock", size: 12, color: AppTheme.textTertiary, weight: .regular)
                                Text("Embeddings stored locally · never uploaded")
                                    .typeCaption1()
                                    .foregroundColor(AppTheme.textTertiary)
                                Spacer()
                            }
                            .listRowBackground(Color.clear)
                        }
                    }
                    .listStyle(InsetGroupedListStyle())
                }
            }
            .navigationTitle("Documents")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    NavButton(name: "plus", label: "Import document", weight: .semibold) {
                        viewModel.importDocument()
                    }
                }
            }
        }
    }
}
