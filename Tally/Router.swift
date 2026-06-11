import SwiftUI

/// The app's three tabs. Raw values double as the deep-link hosts.
enum AppTab: String, Hashable {
    case dashboard
    case habits
    case settings
}

/// Navigation state for the whole app: tab selection + the Habits tab's push stack.
/// Also the deep-link router — `tally://` URLs land here from `.onOpenURL` and work
/// both at launch and while the app is running.
///
/// Route contract (review-os depends on these exactly):
///   tally://dashboard      → Dashboard tab
///   tally://habits         → Habits tab, root
///   tally://habit/<id>     → Habits tab with HabitDetailView for <id> pushed
///   tally://settings       → Settings tab
final class Router: ObservableObject {
    @Published var tab: AppTab = .dashboard
    @Published var habitsPath = NavigationPath()

    /// Switch to the Habits tab at its root list.
    func showHabits() {
        tab = .habits
        habitsPath = NavigationPath()
    }

    /// Switch to the Habits tab with one habit's detail pushed.
    func showHabitDetail(_ habit: Habit) {
        tab = .habits
        var path = NavigationPath()
        path.append(habit)
        habitsPath = path
    }

    /// Parse and apply a `tally://` deep link. Unknown hosts / missing ids are ignored.
    func open(url: URL) {
        guard url.scheme?.lowercased() == "tally" else { return }
        let host = url.host?.lowercased() ?? ""
        let pathSegments = url.path.split(separator: "/").map(String.init)

        switch host {
        case "dashboard":
            tab = .dashboard
        case "habits":
            showHabits()
        case "habit":
            if let habit = Habit.find(pathSegments.first) {
                showHabitDetail(habit)
            } else {
                // Unknown id: still land on the habits list rather than dropping the link.
                showHabits()
            }
        case "settings":
            tab = .settings
        default:
            break
        }
    }
}
