import SwiftUI

/// Design tokens mirroring the web app's `src/index.css` `:root` variables.
enum Theme {
    static let bg = Color(hex: "#f6f7fb")
    static let surface = Color(hex: "#ffffff")
    static let ink = Color(hex: "#1e2433")
    static let inkSoft = Color(hex: "#5b6479")
    static let inkFaint = Color(hex: "#9aa2b4")
    static let line = Color(hex: "#e8eaf1")
    static let accent = Color(hex: "#6366f1")
    static let accentSoft = Color(hex: "#eef0fe")

    static let radius: CGFloat = 16
    static let radiusSm: CGFloat = 10
}

extension Color {
    /// `Color("#rrggbb")` equivalent for the hex tokens carried over from the web app.
    init(hex: String) {
        let cleaned = hex.hasPrefix("#") ? String(hex.dropFirst()) : hex
        var value: UInt64 = 0
        Scanner(string: cleaned).scanHexInt64(&value)
        let r = Double((value >> 16) & 0xFF) / 255
        let g = Double((value >> 8) & 0xFF) / 255
        let b = Double(value & 0xFF) / 255
        self.init(red: r, green: g, blue: b)
    }
}

/// The white rounded panel everything sits on — the web app's `.card`.
struct CardStyle: ViewModifier {
    var flush = false

    func body(content: Content) -> some View {
        content
            .padding(flush ? 8 : 20)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(Theme.surface)
            .clipShape(RoundedRectangle(cornerRadius: Theme.radius, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: Theme.radius, style: .continuous)
                    .stroke(Theme.line, lineWidth: 1)
            )
            .shadow(color: Color(hex: "#141828").opacity(0.06), radius: 12, x: 0, y: 8)
    }
}

extension View {
    func cardStyle(flush: Bool = false) -> some View {
        modifier(CardStyle(flush: flush))
    }
}

/// Section heading inside a card — the web app's `.card-title`.
struct CardTitle: View {
    let text: String

    init(_ text: String) { self.text = text }

    var body: some View {
        Text(text)
            .font(.system(size: 16, weight: .semibold))
            .foregroundStyle(Theme.ink)
    }
}
