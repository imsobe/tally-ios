import SwiftUI

/// In-memory habit fixtures, mirroring `src/data/habits.ts` in the web app (imsobe/tally).
/// No backend — this is a demo target app for review-os, so the data is static and lives
/// here. `history` is the last 7 days (oldest → newest); `true` = completed that day.
enum Cadence: String, CaseIterable {
    case daily
    case weekdays
    case weekly

    var label: String {
        switch self {
        case .daily: return "Daily"
        case .weekdays: return "Weekdays"
        case .weekly: return "Weekly"
        }
    }
}

struct Habit: Identifiable, Hashable {
    let id: String
    let name: String
    let emoji: String
    let cadence: Cadence
    let streak: Int
    let goalPerWeek: Int
    let doneThisWeek: Int
    let colorHex: String
    let note: String
    let history: [Bool]

    var color: Color { Color(hex: colorHex) }

    /// Weekly goal progress as a 0–100 percentage.
    var weeklyPercent: Int {
        goalPerWeek == 0 ? 0 : Int((Double(doneThisWeek) / Double(goalPerWeek) * 100).rounded())
    }

    /// Whether the habit was completed today (the newest history entry).
    var doneToday: Bool { history.last == true }
}

extension Habit {
    static let fixtures: [Habit] = [
        Habit(
            id: "water",
            name: "Drink water",
            emoji: "💧",
            cadence: .daily,
            streak: 12,
            goalPerWeek: 7,
            doneThisWeek: 5,
            colorHex: "#38bdf8",
            note: "Eight glasses. A full bottle on the desk by 9am makes this automatic.",
            history: [true, true, false, true, true, true, false]
        ),
        Habit(
            id: "read",
            name: "Read 20 pages",
            emoji: "📖",
            cadence: .daily,
            streak: 4,
            goalPerWeek: 7,
            doneThisWeek: 4,
            colorHex: "#a78bfa",
            note: "Currently on a slow non-fiction book — 20 pages keeps momentum without dread.",
            history: [false, true, true, true, false, true, true]
        ),
        Habit(
            id: "run",
            name: "Morning run",
            emoji: "🏃",
            cadence: .weekdays,
            streak: 8,
            goalPerWeek: 5,
            doneThisWeek: 3,
            colorHex: "#fb923c",
            note: "Short loop around the park. Shoes by the door the night before.",
            history: [true, false, true, false, true, false, false]
        ),
        Habit(
            id: "meditate",
            name: "Meditate",
            emoji: "🧘",
            cadence: .daily,
            streak: 21,
            goalPerWeek: 7,
            doneThisWeek: 6,
            colorHex: "#34d399",
            note: "Ten minutes, guided. The streak is the motivator here — do not break the chain.",
            history: [true, true, true, true, true, true, false]
        ),
        Habit(
            id: "journal",
            name: "Journal",
            emoji: "✍️",
            cadence: .weekly,
            streak: 2,
            goalPerWeek: 3,
            doneThisWeek: 1,
            colorHex: "#f472b6",
            note: "Three longer entries a week. Sunday review is the anchor one.",
            history: [false, false, true, false, false, false, false]
        ),
    ]

    /// Find one habit by id (deep-link / route param).
    static func find(_ id: String?) -> Habit? {
        guard let id else { return nil }
        return fixtures.first { $0.id == id }
    }

    /// Overall weekly completion across every habit's goal, as a 0–100 percentage.
    static func overallCompletion() -> Int {
        let done = fixtures.reduce(0) { $0 + $1.doneThisWeek }
        let goal = fixtures.reduce(0) { $0 + $1.goalPerWeek }
        return goal == 0 ? 0 : Int((Double(done) / Double(goal) * 100).rounded())
    }

    /// The longest active streak across all habits.
    static func bestStreak() -> Int {
        fixtures.reduce(0) { max($0, $1.streak) }
    }
}
