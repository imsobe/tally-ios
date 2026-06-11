import SwiftUI

/// Compact metric tile for the dashboard's top row (streak, completion, count).
/// Mirrors the web app's StatTile: a colored accent bar + label / value / hint.
struct StatTile: View {
    let label: String
    let value: String
    var hint: String?
    var accent: Color = Theme.accent
    /// Stable pin identity, e.g. "stat-tile-completion".
    let identifier: String

    var body: some View {
        HStack(spacing: 0) {
            Rectangle()
                .fill(accent)
                .frame(width: 4)

            VStack(alignment: .leading, spacing: 2) {
                Text(label)
                    .font(.system(size: 13, weight: .medium))
                    .foregroundStyle(Theme.inkSoft)
                Text(value)
                    .font(.system(size: 24, weight: .bold))
                    .foregroundStyle(Theme.ink)
                    .padding(.top, 4)
                if let hint {
                    Text(hint)
                        .font(.system(size: 12.5))
                        .foregroundStyle(Theme.inkFaint)
                }
            }
            .padding(.horizontal, 14)
            .padding(.vertical, 14)

            Spacer(minLength: 0)
        }
        .background(Theme.surface)
        .clipShape(RoundedRectangle(cornerRadius: Theme.radius, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: Theme.radius, style: .continuous)
                .stroke(Theme.line, lineWidth: 1)
        )
        .shadow(color: Color(hex: "#141828").opacity(0.06), radius: 12, x: 0, y: 8)
        .accessibilityElement(children: .combine)
        .accessibilityLabel("\(label): \(value)\(hint.map { ", \($0)" } ?? "")")
        .accessibilityIdentifier(identifier)
    }
}
