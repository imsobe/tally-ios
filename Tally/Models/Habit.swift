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
    /// The full habit list: 5 hand-authored fixtures (stable ids review-os pins
    /// against) + a generated batch so the list is a genuinely LONG scroll — used
    /// to feel the live-tile motion knobs (event-driven poll burst) on a real drag.
    static let fixtures: [Habit] = coreFixtures + generatedFixtures

    private static let coreFixtures: [Habit] = [
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

    /// ~50 extra habits, built from a name/emoji/color table so the Habits list
    /// scrolls for real. ids are kebab-case (review-os pin identity); deterministic
    /// streak/progress/history so the UI looks varied but the build is stable.
    private static let generatedFixtures: [Habit] = {
        let specs: [(String, String, String, String, Cadence)] = [
            ("stretch", "Stretch", "🤸", "#22d3ee", .daily),
            ("vitamins", "Take vitamins", "💊", "#fbbf24", .daily),
            ("floss", "Floss", "🦷", "#60a5fa", .daily),
            ("walk", "10k steps", "👟", "#4ade80", .daily),
            ("no-sugar", "No added sugar", "🚫", "#f87171", .daily),
            ("language", "Language practice", "🗣️", "#c084fc", .daily),
            ("guitar", "Practice guitar", "🎸", "#fb7185", .weekdays),
            ("sleep", "Sleep by 11", "😴", "#818cf8", .daily),
            ("tidy", "Tidy desk", "🧹", "#2dd4bf", .weekdays),
            ("call-family", "Call family", "📞", "#fda4af", .weekly),
            ("budget", "Log expenses", "💸", "#86efac", .daily),
            ("gratitude", "Gratitude note", "🙏", "#fcd34d", .daily),
            ("pushups", "Push-ups", "💪", "#f97316", .daily),
            ("water-plants", "Water plants", "🪴", "#65a30d", .weekly),
            ("inbox-zero", "Inbox zero", "📥", "#0ea5e9", .weekdays),
            ("podcast", "Learn from a podcast", "🎧", "#a855f7", .daily),
            ("cold-shower", "Cold shower", "🚿", "#38bdf8", .daily),
            ("sketch", "Sketch", "✏️", "#facc15", .daily),
            ("meal-prep", "Meal prep", "🥗", "#22c55e", .weekly),
            ("review-goals", "Review goals", "🎯", "#ef4444", .weekly),
            ("read-news", "Read the news", "📰", "#94a3b8", .daily),
            ("deep-work", "Deep work block", "🧠", "#6366f1", .weekdays),
            ("yoga", "Yoga", "🧎", "#14b8a6", .daily),
            ("save", "Move to savings", "🏦", "#84cc16", .weekly),
            ("declutter", "Declutter one thing", "📦", "#d6a25b", .daily),
            ("compliment", "Give a compliment", "💬", "#fb923c", .daily),
            ("posture", "Posture check", "🪑", "#0d9488", .daily),
            ("water-2", "Second bottle", "🚰", "#06b6d4", .daily),
            ("breathe", "Box breathing", "🌬️", "#7dd3fc", .daily),
            ("learn-word", "New word", "🔤", "#c026d3", .daily),
            ("plan-day", "Plan tomorrow", "🗓️", "#f59e0b", .daily),
            ("no-phone-am", "No phone first hour", "📵", "#dc2626", .daily),
            ("protein", "Hit protein goal", "🍗", "#ea580c", .daily),
            ("stairs", "Take the stairs", "🪜", "#16a34a", .weekdays),
            ("read-fiction", "Read fiction", "📚", "#9333ea", .daily),
            ("clean-kitchen", "Clean kitchen", "🍽️", "#0891b2", .daily),
            ("affirm", "Daily affirmation", "✨", "#fbbf24", .daily),
            ("walk-dog", "Walk the dog", "🐕", "#a16207", .daily),
            ("study", "Study session", "🎓", "#4f46e5", .weekdays),
            ("water-face", "Skincare", "🧴", "#f472b6", .daily),
            ("declutter-inbox", "Unsubscribe one", "✉️", "#64748b", .weekly),
            ("plank", "Plank", "🧱", "#b45309", .daily),
            ("water-cooler", "Chat with a coworker", "☕️", "#92400e", .weekdays),
            ("review-spend", "Review spending", "📊", "#15803d", .weekly),
            ("nap", "Power nap", "🛌", "#7c3aed", .weekdays),
            ("sun", "Get sunlight", "☀️", "#f59e0b", .daily),
            ("write-page", "Write a page", "📝", "#be123c", .daily),
            ("learn-shortcut", "Learn a shortcut", "⌨️", "#1d4ed8", .weekdays),
            ("hydrate-pm", "Evening water", "💦", "#0284c7", .daily),
            ("reflect", "Evening reflection", "🌙", "#6d28d9", .daily),
        ]
        return specs.enumerated().map { (i, s) in
            let (id, name, emoji, color, cadence) = s
            let goal = cadence == .weekly ? 3 : (cadence == .weekdays ? 5 : 7)
            let done = (i * 3 + 2) % (goal + 1)            // deterministic 0…goal
            let streak = (i * 7 + 3) % 28                  // deterministic 0…27
            let hist = (0..<7).map { ($0 + i) % 3 != 0 }   // varied 7-day pattern
            return Habit(
                id: id, name: name, emoji: emoji, cadence: cadence,
                streak: streak, goalPerWeek: goal, doneThisWeek: done,
                colorHex: color, note: "Part of the daily routine.", history: hist
            )
        }
    }()

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
