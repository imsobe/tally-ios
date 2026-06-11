import SwiftUI

/// Full habit list — every habit as a tappable row into its detail screen.
/// Mirrors the web app's Habits page.
struct HabitsView: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 22) {
                header
                listCard
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
        }
        .background(Theme.bg)
        .navigationTitle("Habits")
        .toolbar(.hidden, for: .navigationBar)
    }

    private var header: some View {
        HStack(alignment: .top, spacing: 16) {
            VStack(alignment: .leading, spacing: 4) {
                Text("Habits")
                    .font(.system(size: 26, weight: .bold))
                    .foregroundStyle(Theme.ink)
                    .accessibilityIdentifier("habits-title")
                Text("\(Habit.fixtures.count) habits you're tracking.")
                    .font(.system(size: 15))
                    .foregroundStyle(Theme.inkSoft)
                    .accessibilityIdentifier("habits-subtitle")
            }
            Spacer()
            Button {
                // Demo target: creation isn't implemented (matches the web app).
            } label: {
                Text("+ New habit")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundStyle(.white)
                    .padding(.horizontal, 14)
                    .padding(.vertical, 9)
                    .background(Theme.accent)
                    .clipShape(RoundedRectangle(cornerRadius: Theme.radiusSm, style: .continuous))
            }
            .accessibilityLabel("New habit")
            .accessibilityIdentifier("button-new-habit")
        }
        .padding(.top, 8)
    }

    private var listCard: some View {
        VStack(spacing: 0) {
            ForEach(Habit.fixtures) { habit in
                HabitRow(habit: habit)
            }
        }
        .cardStyle(flush: true)
        // .contain makes the list its OWN accessibility container: a bare
        // .accessibilityIdentifier on a container VStack propagates DOWN and
        // overrides every child element's identifier (all five rows read
        // "habit-list" in the AX tree, breaking review-os's pin/replay identity —
        // found live by the docs/21 M8 fork gate).
        .accessibilityElement(children: .contain)
        .accessibilityIdentifier("habit-list")
    }
}
