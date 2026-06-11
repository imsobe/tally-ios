import SwiftUI

/// Single habit: header, weekly goal ring, last-7-days grid, and the note.
/// Mirrors the web app's HabitDetail page (pushed inside the Habits tab).
struct HabitDetailView: View {
    let habit: Habit

    @Environment(\.dismiss) private var dismiss

    private static let days = ["M", "T", "W", "T", "F", "S", "S"]

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 22) {
                backLink
                header
                weekCard
                historyCard
                noteCard
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
        }
        .background(Theme.bg)
        .navigationTitle(habit.name)
        .toolbar(.hidden, for: .navigationBar)
    }

    /// Custom "← Habits" back affordance, mirroring the web page's back link
    /// (the system navigation bar is hidden for visual parity).
    private var backLink: some View {
        Button {
            dismiss()
        } label: {
            Text("← Habits")
                .font(.system(size: 14, weight: .medium))
                .foregroundStyle(Theme.inkSoft)
        }
        .accessibilityLabel("Back to habits")
        .accessibilityIdentifier("button-back-habits")
        .padding(.top, 8)
    }

    private var header: some View {
        HStack(alignment: .center, spacing: 16) {
            Text(habit.emoji)
                .font(.system(size: 30))
                .frame(width: 60, height: 60)
                .background(habit.color.opacity(0.13))
                .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                .accessibilityHidden(true)

            VStack(alignment: .leading, spacing: 6) {
                Text(habit.name)
                    .font(.system(size: 26, weight: .bold))
                    .foregroundStyle(Theme.ink)
                    .accessibilityIdentifier("habit-detail-title")
                HStack(spacing: 10) {
                    CadenceBadge(cadence: habit.cadence)
                    Text("🔥 \(habit.streak) day streak")
                        .font(.system(size: 12.5))
                        .foregroundStyle(Theme.inkSoft)
                        .accessibilityLabel("\(habit.streak) day streak")
                        .accessibilityIdentifier("habit-detail-streak")
                }
            }

            Spacer(minLength: 8)

            Button {
                // Demo target: marking done isn't persisted (matches the web app).
            } label: {
                Text("Mark done")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundStyle(.white)
                    .padding(.horizontal, 14)
                    .padding(.vertical, 9)
                    .background(Theme.accent)
                    .clipShape(RoundedRectangle(cornerRadius: Theme.radiusSm, style: .continuous))
            }
            .accessibilityLabel("Mark \(habit.name) done")
            .accessibilityIdentifier("button-mark-done")
        }
    }

    private var weekCard: some View {
        VStack(alignment: .leading, spacing: 14) {
            CardTitle("This week")
            HStack(spacing: 20) {
                ProgressRing(percent: habit.weeklyPercent, color: habit.color)
                    .accessibilityIdentifier("habit-detail-ring")
                VStack(alignment: .leading, spacing: 2) {
                    Text("\(habit.doneThisWeek)/\(habit.goalPerWeek)")
                        .font(.system(size: 24, weight: .bold))
                        .foregroundStyle(Theme.ink)
                        .accessibilityIdentifier("habit-detail-week-count")
                    Text("days toward goal")
                        .font(.system(size: 13))
                        .foregroundStyle(Theme.inkSoft)
                }
                .accessibilityElement(children: .combine)
                .accessibilityLabel("\(habit.doneThisWeek) of \(habit.goalPerWeek) days toward goal")
            }
        }
        .cardStyle()
        .accessibilityIdentifier("card-this-week")
    }

    private var historyCard: some View {
        VStack(alignment: .leading, spacing: 14) {
            CardTitle("Last 7 days")
            HStack(spacing: 6) {
                ForEach(Array(habit.history.enumerated()), id: \.offset) { index, done in
                    VStack(spacing: 8) {
                        RoundedRectangle(cornerRadius: 10, style: .continuous)
                            .fill(done ? habit.color : Theme.bg)
                            .overlay(
                                RoundedRectangle(cornerRadius: 10, style: .continuous)
                                    .stroke(done ? Color.clear : Theme.line, lineWidth: 1.5)
                            )
                            .frame(width: 34, height: 34)
                        Text(Self.days[index])
                            .font(.system(size: 12))
                            .foregroundStyle(Theme.inkFaint)
                    }
                    .frame(maxWidth: .infinity)
                    .accessibilityElement(children: .ignore)
                    .accessibilityLabel("\(Self.days[index]): \(done ? "completed" : "missed")")
                    .accessibilityIdentifier("week-dot-\(index)")
                }
            }
        }
        .cardStyle()
        .accessibilityIdentifier("card-last-7-days")
    }

    private var noteCard: some View {
        VStack(alignment: .leading, spacing: 14) {
            CardTitle("Note")
            Text(habit.note)
                .font(.system(size: 14.5))
                .lineSpacing(5)
                .foregroundStyle(Theme.inkSoft)
                .accessibilityIdentifier("habit-detail-note")
        }
        .cardStyle()
        .accessibilityIdentifier("card-note")
    }
}
