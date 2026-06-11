import SwiftUI

/// Landing screen: a greeting, three headline stats, and today's habit checklist.
/// Mirrors the web app's Dashboard page.
struct DashboardView: View {
    @EnvironmentObject private var router: Router

    private var today: [Habit] {
        Habit.fixtures.filter { $0.cadence != .weekly }
    }

    private var doneCount: Int {
        today.filter(\.doneToday).count
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 22) {
                header
                statRow
                todayCard
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
        }
        .background(Theme.bg)
        .navigationTitle("Dashboard")
        .toolbar(.hidden, for: .navigationBar)
    }

    private var header: some View {
        HStack(alignment: .top, spacing: 16) {
            VStack(alignment: .leading, spacing: 4) {
                Text("Good morning, Imran")
                    .font(.system(size: 26, weight: .bold))
                    .foregroundStyle(Theme.ink)
                    .accessibilityIdentifier("dashboard-greeting")
                Text("You have \(today.count) habits to tend today.")
                    .font(.system(size: 15))
                    .foregroundStyle(Theme.inkSoft)
                    .accessibilityIdentifier("dashboard-subtitle")
            }
            Spacer()
            Button {
                router.showHabits()
            } label: {
                Text("View all")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundStyle(Theme.ink)
                    .padding(.horizontal, 14)
                    .padding(.vertical, 9)
                    .background(Theme.surface)
                    .clipShape(RoundedRectangle(cornerRadius: Theme.radiusSm, style: .continuous))
                    .overlay(
                        RoundedRectangle(cornerRadius: Theme.radiusSm, style: .continuous)
                            .stroke(Theme.line, lineWidth: 1)
                    )
            }
            .accessibilityLabel("View all habits")
            .accessibilityIdentifier("button-view-all-habits")
        }
        .padding(.top, 8)
    }

    private var statRow: some View {
        VStack(spacing: 12) {
            HStack(spacing: 12) {
                StatTile(
                    label: "Best streak",
                    value: "\(Habit.bestStreak()) days",
                    hint: "Meditate",
                    accent: Color(hex: "#34d399"),
                    identifier: "stat-tile-best-streak"
                )
                StatTile(
                    label: "This week",
                    value: "\(Habit.overallCompletion())%",
                    hint: "of weekly goals",
                    accent: Theme.accent,
                    identifier: "stat-tile-completion"
                )
            }
            StatTile(
                label: "Active habits",
                value: "\(Habit.fixtures.count)",
                hint: "across all cadences",
                accent: Color(hex: "#fb923c"),
                identifier: "stat-tile-active-habits"
            )
        }
    }

    private var todayCard: some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack {
                CardTitle("Today")
                Spacer()
                Text("\(doneCount) done")
                    .font(.system(size: 13))
                    .foregroundStyle(Theme.inkFaint)
                    .accessibilityIdentifier("today-done-count")
            }

            VStack(spacing: 0) {
                ForEach(Array(today.enumerated()), id: \.element.id) { index, habit in
                    checkItem(habit)
                    if index < today.count - 1 {
                        Divider().overlay(Theme.line)
                    }
                }
            }
        }
        .cardStyle()
        .accessibilityIdentifier("card-today")
    }

    private func checkItem(_ habit: Habit) -> some View {
        Button {
            router.showHabitDetail(habit)
        } label: {
            HStack(spacing: 13) {
                ZStack {
                    RoundedRectangle(cornerRadius: 7, style: .continuous)
                        .fill(habit.doneToday ? Theme.accent : Color.clear)
                    RoundedRectangle(cornerRadius: 7, style: .continuous)
                        .stroke(habit.doneToday ? Theme.accent : Theme.line, lineWidth: 1.5)
                    if habit.doneToday {
                        Image(systemName: "checkmark")
                            .font(.system(size: 11, weight: .bold))
                            .foregroundStyle(.white)
                    }
                }
                .frame(width: 22, height: 22)

                Text(habit.emoji)
                    .font(.system(size: 18))

                Text(habit.name)
                    .font(.system(size: 15, weight: .medium))
                    .foregroundStyle(Theme.ink)

                Spacer()

                Text("🔥 \(habit.streak)")
                    .font(.system(size: 13))
                    .foregroundStyle(Theme.inkSoft)
            }
            .padding(.vertical, 11)
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        .accessibilityLabel("\(habit.name), \(habit.doneToday ? "done" : "not done") today, \(habit.streak) day streak")
        .accessibilityIdentifier("check-item-\(habit.id)")
    }
}
