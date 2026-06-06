import SwiftUI

/// Defines the global design tokens corresponding to the `tokens.jsx` React definitions.
enum AppTheme {
    static let font = Font.system(.body, design: .default)
    static let mono = Font.system(.body, design: .monospaced)

    static let accent = Color(hex: "#3B82F6")
    
    // Using Native Dynamic System Colors for automatic Light/Dark mode
    static let bg = Color(UIColor.systemBackground)
    static let card = Color(UIColor.secondarySystemBackground)
    static let card2 = Color(UIColor.tertiarySystemBackground)
    static let bubbleAI = Color(UIColor.secondarySystemBackground)
    static let fill = Color(UIColor.tertiarySystemFill)
    static let separator = Color(UIColor.separator)
    static let hairline = Color(UIColor.opaqueSeparator)
    
    static let textPrimary = Color.primary
    static let textSecondary = Color.secondary
    static let textTertiary = Color(UIColor.tertiaryLabel)
    
    static let accentText = Color.white
    static let accentSoft = accent.opacity(0.15)
    
    static let destructive = Color.red
    static let success = Color.green
    static let warning = Color.yellow
    
    static let placeholderA = Color(UIColor.placeholderText)
    static let placeholderB = Color(UIColor.quaternaryLabel)
}

// Custom Font Ramp
extension View {
    func typeLargeTitle() -> some View {
        self.font(.system(size: 34, weight: .bold, design: .default))
    }
    func typeTitle1() -> some View {
        self.font(.system(size: 28, weight: .bold, design: .default))
    }
    func typeTitle2() -> some View {
        self.font(.system(size: 22, weight: .bold, design: .default))
    }
    func typeTitle3() -> some View {
        self.font(.system(size: 20, weight: .semibold, design: .default))
    }
    func typeHeadline() -> some View {
        self.font(.system(size: 17, weight: .semibold, design: .default))
    }
    func typeBody() -> some View {
        self.font(.system(size: 17, weight: .regular, design: .default))
    }
    func typeCallout() -> some View {
        self.font(.system(size: 16, weight: .regular, design: .default))
    }
    func typeSubhead() -> some View {
        self.font(.system(size: 15, weight: .regular, design: .default))
    }
    func typeFootnote() -> some View {
        self.font(.system(size: 13, weight: .regular, design: .default))
    }
    func typeCaption1() -> some View {
        self.font(.system(size: 12, weight: .regular, design: .default))
    }
    func typeCaption2() -> some View {
        self.font(.system(size: 11, weight: .regular, design: .default))
    }
}

// Hex color support
extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (1, 1, 1, 0)
        }

        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue:  Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}
