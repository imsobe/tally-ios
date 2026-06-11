import SwiftUI

/// Circular progress indicator with a centered percent label. Used on habit detail to
/// show weekly goal progress — mirrors the web app's SVG ProgressRing.
struct ProgressRing: View {
    /// 0–100.
    let percent: Int
    var size: CGFloat = 96
    var stroke: CGFloat = 9
    var color: Color = Theme.accent

    private var clamped: Int { min(100, max(0, percent)) }

    var body: some View {
        ZStack {
            Circle()
                .stroke(Color(hex: "#eceef3"), lineWidth: stroke)
            Circle()
                .trim(from: 0, to: CGFloat(clamped) / 100)
                .stroke(color, style: StrokeStyle(lineWidth: stroke, lineCap: .round))
                .rotationEffect(.degrees(-90))
            Text("\(clamped)%")
                .font(.system(size: 19, weight: .bold))
                .foregroundStyle(Theme.ink)
        }
        .padding(stroke / 2)
        .frame(width: size, height: size)
        .accessibilityElement(children: .ignore)
        .accessibilityLabel("Weekly progress: \(clamped) percent")
    }
}
