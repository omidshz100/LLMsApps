import SwiftUI

struct AppIcon: View {
    let name: String
    let size: CGFloat
    let color: Color
    let weight: Font.Weight
    
    var systemName: String {
        switch name {
        case "message": return "bubble.left"
        case "messageFill": return "bubble.left.fill"
        case "folder": return "folder"
        case "folderFill": return "folder.fill"
        case "sliders": return "slider.horizontal.3"
        case "send": return "arrow.up.circle.fill" // close enough
        case "arrowUp": return "arrow.up.circle.fill"
        case "stop": return "stop.circle.fill"
        case "plus": return "plus"
        case "chevronRight": return "chevron.right"
        case "chevronLeft": return "chevron.left"
        case "chevronDown": return "chevron.down"
        case "gear": return "gearshape"
        case "trash": return "trash"
        case "docText": return "doc.text"
        case "info": return "info.circle"
        case "ellipsis": return "ellipsis"
        case "sparkle": return "sparkles"
        case "cube": return "cube"
        case "stack": return "square.stack.3d.up"
        case "reload": return "arrow.clockwise"
        case "xmark": return "xmark"
        case "check": return "checkmark"
        case "lock": return "lock"
        case "waveform": return "waveform"
        case "search": return "magnifyingglass"
        default: return "questionmark"
        }
    }
    
    var body: some View {
        Image(systemName: systemName)
            .font(.system(size: size, weight: weight))
            .foregroundColor(color)
    }
}

// MARK: - Buttons
struct FilledButton: View {
    let icon: String?
    let title: String
    let loading: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 8) {
                if loading {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                } else if let icon = icon {
                    AppIcon(name: icon, size: 18, color: .white, weight: .semibold)
                }
                Text(title)
                    .font(.system(size: 17, weight: .semibold))
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 14)
            .background(AppTheme.accent)
            .foregroundColor(.white)
            .cornerRadius(12)
        }
        .disabled(loading)
    }
}

struct NavButton: View {
    let name: String
    let label: String
    let weight: Font.Weight
    let action: () -> Void
    
    init(name: String, label: String, weight: Font.Weight = .regular, action: @escaping () -> Void) {
        self.name = name
        self.label = label
        self.weight = weight
        self.action = action
    }
    
    var body: some View {
        Button(action: action) {
            AppIcon(name: name, size: 24, color: AppTheme.accent, weight: weight)
        }
        .accessibilityLabel(label)
    }
}

// MARK: - Status
struct StatusLine: View {
    let state: String // "loading", "ready", "generating"
    let modelName: String
    
    var color: Color {
        switch state {
        case "loading": return AppTheme.textSecondary
        case "ready": return AppTheme.textSecondary
        case "generating": return AppTheme.accent
        default: return AppTheme.textSecondary
        }
    }
    
    var dotColor: Color {
        switch state {
        case "loading": return AppTheme.textTertiary
        case "ready": return AppTheme.success
        case "generating": return AppTheme.accent
        default: return AppTheme.success
        }
    }
    
    var text: String {
        switch state {
        case "loading": return "Model loading…"
        case "ready": return "Ready"
        case "generating": return "Generating…"
        default: return "Ready"
        }
    }
    
    var isPulsing: Bool {
        state == "loading" || state == "generating"
    }
    
    @State private var phase: CGFloat = 1.0
    
    var body: some View {
        HStack(spacing: 5) {
            Circle()
                .fill(dotColor)
                .frame(width: 6, height: 6)
                .scaleEffect(isPulsing ? phase : 1.0)
                .opacity(isPulsing ? phase : 1.0)
                .animation(isPulsing ? Animation.easeInOut(duration: 1.3).repeatForever(autoreverses: true) : .default, value: phase)
                .onAppear {
                    if isPulsing { phase = 0.5 }
                }
                .onChange(of: isPulsing) { pulsing in
                    phase = pulsing ? 0.5 : 1.0
                }
            
            
            let shortName = modelName.split(separator: "-").prefix(3).joined(separator: " ")
            Text("\(shortName) · \(text)")
                .typeCaption1()
                .fontWeight(.medium)
                .foregroundColor(color)
        }
    }
}

struct StatusPill: View {
    let state: String // "unloaded", "loading", "ready", "error"
    
    var body: some View {
        HStack(spacing: 5) {
            Circle()
                .fill(state == "ready" ? AppTheme.success : (state == "error" ? AppTheme.destructive : AppTheme.textTertiary))
                .frame(width: 6, height: 6)
            Text(state.capitalized)
                .typeCaption1()
                .foregroundColor(AppTheme.textSecondary)
        }
        .padding(.horizontal, 8)
        .padding(.vertical, 4)
        .background(AppTheme.fill)
        .cornerRadius(100)
    }
}
