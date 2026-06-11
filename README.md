# Tally (iOS)

A tiny habit tracker — a minimal, real multi-screen **SwiftUI** app. The iOS mirror of
[imsobe/tally](https://github.com/imsobe/tally) (the web demo app).

Built as the **mobile demo target for [review-os](https://github.com/imsobe/review-os)**:
review-os boots it in iOS simulators, screenshots it, pins comments to its accessibility
tree, and lets an agent edit the Swift source. This repo doubles as the agent's edit
target — point review-os's `REVIEW_TARGET_REPO` at this checkout for mobile passes.

Same four screens as the web app (Dashboard, Habits, Habit detail, Settings), same
static habit fixtures (`Tally/Models/Habit.swift`), same visual language (design tokens
in `Tally/Views/Components/Theme.swift`). Zero dependencies — pure SwiftUI, no
networking, no persistence.

## Generate + build

The `.xcodeproj` is **not committed** — `project.yml` is the canonical project
definition ([XcodeGen](https://github.com/yonaskolb/XcodeGen), `brew install xcodegen`):

```bash
xcodegen generate    # writes Tally.xcodeproj (and Tally/Info.plist)
```

Build for the simulator (requires full Xcode, not just Command Line Tools):

```bash
xcodebuild -project Tally.xcodeproj -scheme Tally \
  -destination 'generic/platform=iOS Simulator' \
  -derivedDataPath .build build
```

## Deep-link contract

The URL scheme `tally` is registered in the Info plist (via `project.yml`). Links are
handled in `.onOpenURL` (router: `Tally/Router.swift`) and work both at cold launch and
while the app is running. **review-os depends on these routes exactly:**

| URL                  | Destination                                        |
| -------------------- | -------------------------------------------------- |
| `tally://dashboard`  | Dashboard tab                                      |
| `tally://habits`     | Habits tab, root list                              |
| `tally://habit/<id>` | Habits tab with HabitDetailView for `<id>` pushed  |
| `tally://settings`   | Settings tab                                       |

Habit ids: `water`, `read`, `run`, `meditate`, `journal`. An unknown `<id>` falls back
to the Habits root. Exercise from a booted simulator with:

```bash
xcrun simctl openurl booted "tally://habit/meditate"
```

## Accessibility-ID conventions (pin identity)

Every interactive element and every key info element carries a stable
`.accessibilityIdentifier` — kebab-case, data-derived where applicable. review-os pins
comments to these. Conventions:

- **Tabs** — `tab-dashboard`, `tab-habits`, `tab-settings`
- **Rows / per-habit elements** — `habit-row-<id>`, `check-item-<id>`, `week-dot-<index>`
- **Stat tiles** — `stat-tile-best-streak`, `stat-tile-completion`, `stat-tile-active-habits`
- **Buttons** — `button-view-all-habits`, `button-new-habit`, `button-mark-done`,
  `button-back-habits`, `button-cancel`, `button-save`
- **Detail fields** — `habit-detail-title`, `habit-detail-streak`, `habit-detail-ring`,
  `habit-detail-week-count`, `habit-detail-note`
- **Settings controls** — `settings-field-display-name`, `settings-segmented-week-start`,
  `settings-toggle-reminders`, `settings-field-reminder-time`
- **Cards / sections** — `card-today`, `card-this-week`, `card-last-7-days`, `card-note`,
  `card-profile`, `card-reminders`, `habit-list`
- **Page text** — `dashboard-greeting`, `dashboard-subtitle`, `habits-title`,
  `habits-subtitle`, `settings-title`, `settings-subtitle`, `today-done-count`,
  `badge-cadence-<cadence>`

Keep identifiers stable across edits — they are the pin-identity contract.

## Structure

```
project.yml                  # canonical project definition (XcodeGen)
Tally/
  TallyApp.swift             # @main + RootView (TabView shell), .onOpenURL routing
  Router.swift               # tab selection + Habits NavigationPath; parses tally:// URLs
  Models/Habit.swift         # Habit model + static fixtures (mirror of src/data/habits.ts)
  Views/
    DashboardView.swift
    HabitsView.swift
    HabitDetailView.swift
    SettingsView.swift
    Components/              # Theme (tokens + card style), StatTile, ProgressRing,
                             # HabitRow (+ ProgressBar), CadenceBadge
```
