import SwiftUI

struct SettingsScreen: View {
    @StateObject private var viewModel = SettingsViewModel()
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Model"), footer: Text("Runs fully on-device. No network access required.")) {
                    HStack(spacing: 12) {
                        ZStack {
                            RoundedRectangle(cornerRadius: 10)
                                .fill(AppTheme.accentSoft)
                                .frame(width: 38, height: 38)
                            AppIcon(name: "cube", size: 21, color: AppTheme.accent, weight: .regular)
                        }
                        
                        VStack(alignment: .leading, spacing: 2) {
                            Text("Gemma 3 4B")
                                .typeBody()
                                .foregroundColor(AppTheme.textPrimary)
                            Text(viewModel.settings.modelName)
                                .font(AppTheme.mono)
                                .typeCaption2()
                                .foregroundColor(AppTheme.textSecondary)
                                .lineLimit(1)
                        }
                        Spacer()
                        StatusPill(state: viewModel.modelState)
                    }
                    .padding(.vertical, 4)
                    
                    Toggle("Use GPU", isOn: $viewModel.settings.useGPU)
                }
                
                Section(header: Text("Model Configuration")) {
                    VStack(alignment: .leading) {
                        HStack {
                            Text("Batch Size")
                            Spacer()
                            Text("\(Int(viewModel.settings.batchSize))")
                                .foregroundColor(AppTheme.textSecondary)
                        }
                        Slider(value: $viewModel.settings.batchSize, in: 16...256, step: 16)
                    }
                    
                    VStack(alignment: .leading) {
                        HStack {
                            Text("Max Tokens (Context)")
                            Spacer()
                            Text("\(Int(viewModel.settings.maxTokenCount))")
                                .foregroundColor(AppTheme.textSecondary)
                        }
                        Slider(value: $viewModel.settings.maxTokenCount, in: 128...2048, step: 128)
                    }
                }
                
                Section(header: Text("Generation")) {
                    VStack(alignment: .leading) {
                        HStack {
                            Text("Temperature")
                            Spacer()
                            Text(String(format: "%.1f", viewModel.settings.temperature))
                                .foregroundColor(AppTheme.textSecondary)
                        }
                        Slider(value: $viewModel.settings.temperature, in: 0...2, step: 0.1)
                    }
                    
                    VStack(alignment: .leading) {
                        HStack {
                            Text("Top-P")
                            Spacer()
                            Text(String(format: "%.2f", viewModel.settings.topP))
                                .foregroundColor(AppTheme.textSecondary)
                        }
                        Slider(value: $viewModel.settings.topP, in: 0...1, step: 0.05)
                    }
                }
                
                Section(header: Text("Repetition Penalty")) {
                    Toggle("Enable Repetition Penalty", isOn: $viewModel.settings.enableRepetitionPenalty)
                    
                    if viewModel.settings.enableRepetitionPenalty {
                        VStack(alignment: .leading) {
                            HStack {
                                Text("Repetition Penalty")
                                Spacer()
                                Text(String(format: "%.2f", viewModel.settings.repetitionPenalty))
                                    .foregroundColor(AppTheme.textSecondary)
                            }
                            Slider(value: $viewModel.settings.repetitionPenalty, in: 1...2, step: 0.05)
                        }
                    }
                }
                
                Section(header: Text("System Prompt"), footer: Text("Prepended to every conversation when enabled.")) {
                    Toggle("Use System Prompt", isOn: $viewModel.settings.useSystemPrompt)
                    if viewModel.settings.useSystemPrompt {
                        TextEditor(text: $viewModel.settings.systemPrompt)
                            .frame(minHeight: 100)
                    }
                }
                
                Section {
                    Button(action: {
                        viewModel.reloadModel()
                    }) {
                        HStack {
                            Spacer()
                            if viewModel.isReloading {
                                ProgressView()
                                    .padding(.trailing, 8)
                                Text("Reloading Model…")
                            } else {
                                AppIcon(name: "reload", size: 18, color: .white, weight: .semibold)
                                    .padding(.trailing, 4)
                                Text("Reload Model")
                            }
                            Spacer()
                        }
                        .foregroundColor(.white)
                    }
                    .listRowBackground(AppTheme.accent)
                    .disabled(viewModel.isReloading)
                    
                    Button(role: .destructive, action: {
                        viewModel.resetToDefaults()
                    }) {
                        HStack {
                            Spacer()
                            Text("Reset to Defaults")
                            Spacer()
                        }
                    }
                }
                
                Text("LLMsApp · gemma-3-4b-it-Q4_K_S · on-device")
                    .typeCaption1()
                    .foregroundColor(AppTheme.textTertiary)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .listRowBackground(Color.clear)
            }
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        presentationMode.wrappedValue.dismiss()
                    }
                }
            }
        }
    }
}
