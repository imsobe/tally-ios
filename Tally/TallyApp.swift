import SwiftUI

@main
struct TallyApp: App {
    @StateObject private var router = Router()

    var body: some Scene {
        WindowGroup {
            RootView()
                .environmentObject(router)
                .onOpenURL { url in
                    router.open(url: url)
                }
        }
    }
}

/// App shell: the tab bar (Dashboard / Habits / Settings) — the iOS equivalent of the
/// web app's persistent sidebar nav. The Habits tab owns a NavigationStack whose path
/// lives on the Router so deep links can push HabitDetailView.
struct RootView: View {
    @EnvironmentObject private var router: Router

    var body: some View {
        TabView(selection: $router.tab) {
            NavigationStack {
                DashboardView()
            }
            .tag(AppTab.dashboard)
            .tabItem {
                Label("Dashboard", systemImage: "square.grid.2x2")
                    .accessibilityIdentifier("tab-dashboard")
            }

            NavigationStack(path: $router.habitsPath) {
                HabitsView()
                    .navigationDestination(for: Habit.self) { habit in
                        HabitDetailView(habit: habit)
                    }
            }
            .tag(AppTab.habits)
            .tabItem {
                Label("Habits", systemImage: "checklist")
                    .accessibilityIdentifier("tab-habits")
            }

            NavigationStack {
                SettingsView()
            }
            .tag(AppTab.settings)
            .tabItem {
                Label("Settings", systemImage: "gearshape")
                    .accessibilityIdentifier("tab-settings")
            }
        }
        .tint(Theme.accent)
    }
}
