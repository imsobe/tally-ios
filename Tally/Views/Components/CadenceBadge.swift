import SwiftUI

/// Small pill showing a habit's cadence. Color-keyed by cadence kind — mirrors the
/// web app's Badge (`badge-daily` / `badge-weekdays` / `badge-weekly`).
struct CadenceBadge: View {
    let cadence: Cadence

    private var background: Color {
        switch cadence {
        case .daily: return Color(hex: "#e0f2fe")
        case .weekdays: return Color(hex: "#fef3c7")
        case .weekly: return Color(hex: "#fce7f3")
        }
    }

    private var foreground: Color {
        switch cadence {
        case .daily: return Color(hex: "#0369a1")
        case .weekdays: return Color(hex: "#b45309")
        case .weekly: return Color(hex: "#be185d")
        }
    }

    var body: some View {
        Text(cadence.label)
            .font(.system(size: 11.5, weight: .semibold))
            .foregroundStyle(foreground)
            .padding(.horizontal, 9)
            .padding(.vertical, 2.5)
            .background(background)
            .clipShape(Capsule())
            .accessibilityLabel("Cadence: \(cadence.label)")
            .accessibilityIdentifier("badge-cadence-\(cadence.rawValue)")
    }
}
