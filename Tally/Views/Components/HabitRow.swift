import SwiftUI

/// One habit as a tappable row — used on the Habits list. Pushes the detail view via
/// NavigationLink(value:). Mirrors the web app's HabitRow: emoji chip, name + cadence
/// badge + streak, and a weekly progress bar.
struct HabitRow: View {
    let habit: Habit

    var body: some View {
        NavigationLink(value: habit) {
            HStack(spacing: 14) {
                Text(habit.emoji)
                    .font(.system(size: 21))
                    .frame(width: 44, height: 44)
                    .background(habit.color.opacity(0.13))
                    .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))

                VStack(alignment: .leading, spacing: 4) {
                    Text(habit.name)
                        .font(.system(size: 15, weight: .semibold))
                        .foregroundStyle(Theme.ink)
                    HStack(spacing: 10) {
                        CadenceBadge(cadence: habit.cadence)
                        Text("🔥 \(habit.streak) day streak")
                            .font(.system(size: 12.5))
                            .foregroundStyle(Theme.inkSoft)
                    }
                }

                Spacer(minLength: 8)

                VStack(alignment: .trailing, spacing: 4) {
                    ProgressBar(fraction: Double(habit.weeklyPercent) / 100, color: habit.color)
                        .frame(width: 64)
                    Text("\(habit.doneThisWeek)/\(habit.goalPerWeek)")
                        .font(.system(size: 12.5))
                        .monospacedDigit()
                        .foregroundStyle(Theme.inkSoft)
                }
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 12)
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        .accessibilityLabel("\(habit.name), \(habit.cadence.label), \(habit.streak) day streak, \(habit.doneThisWeek) of \(habit.goalPerWeek) this week")
        .accessibilityIdentifier("habit-row-\(habit.id)")
    }
}

/// Thin rounded weekly-progress bar — the web app's `.habit-progress-track/-fill`.
struct ProgressBar: View {
    /// 0–1.
    let fraction: Double
    var color: Color = Theme.accent

    var body: some View {
        GeometryReader { geo in
            ZStack(alignment: .leading) {
                Capsule().fill(Theme.line)
                Capsule()
                    .fill(color)
                    .frame(width: geo.size.width * min(1, max(0, fraction)))
            }
        }
        .frame(height: 7)
    }
}
