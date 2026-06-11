import SwiftUI

/// Settings form — local state only (no persistence; this is a demo target).
/// Mirrors the web app's Settings page: profile fields + reminder controls.
struct SettingsView: View {
    @State private var name = "Imran"
    @State private var reminders = true
    @State private var weekStart: WeekStart = .monday
    @State private var reminderTime =
        Calendar.current.date(from: DateComponents(hour: 8, minute: 0)) ?? Date()

    enum WeekStart: String, CaseIterable, Identifiable {
        case monday = "Monday"
        case sunday = "Sunday"
        var id: String { rawValue }
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 22) {
                header
                profileCard
                remindersCard
                actions
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
        }
        .background(Theme.bg)
        .navigationTitle("Settings")
        .toolbar(.hidden, for: .navigationBar)
    }

    private var header: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text("Settings")
                .font(.system(size: 26, weight: .bold))
                .foregroundStyle(Theme.ink)
                .accessibilityIdentifier("settings-title")
            Text("Preferences for your tracker.")
                .font(.system(size: 15))
                .foregroundStyle(Theme.inkSoft)
                .accessibilityIdentifier("settings-subtitle")
        }
        .padding(.top, 8)
    }

    private var profileCard: some View {
        VStack(alignment: .leading, spacing: 14) {
            CardTitle("Profile")

            VStack(alignment: .leading, spacing: 7) {
                Text("Display name")
                    .font(.system(size: 13.5, weight: .semibold))
                    .foregroundStyle(Theme.ink)
                TextField("Display name", text: $name)
                    .font(.system(size: 14.5))
                    .padding(.horizontal, 12)
                    .padding(.vertical, 10)
                    .background(Theme.surface)
                    .clipShape(RoundedRectangle(cornerRadius: Theme.radiusSm, style: .continuous))
                    .overlay(
                        RoundedRectangle(cornerRadius: Theme.radiusSm, style: .continuous)
                            .stroke(Theme.line, lineWidth: 1)
                    )
                    .accessibilityLabel("Display name")
                    .accessibilityIdentifier("settings-field-display-name")
            }

            VStack(alignment: .leading, spacing: 7) {
                Text("Week starts on")
                    .font(.system(size: 13.5, weight: .semibold))
                    .foregroundStyle(Theme.ink)
                Picker("Week starts on", selection: $weekStart) {
                    ForEach(WeekStart.allCases) { day in
                        Text(day.rawValue).tag(day)
                    }
                }
                .pickerStyle(.segmented)
                .accessibilityLabel("Week starts on")
                .accessibilityIdentifier("settings-segmented-week-start")
            }
        }
        .cardStyle()
        .accessibilityIdentifier("card-profile")
    }

    private var remindersCard: some View {
        VStack(alignment: .leading, spacing: 18) {
            CardTitle("Reminders")

            HStack(alignment: .center, spacing: 16) {
                VStack(alignment: .leading, spacing: 3) {
                    Text("Daily reminder")
                        .font(.system(size: 13.5, weight: .semibold))
                        .foregroundStyle(Theme.ink)
                    Text("A nudge to check in on your habits.")
                        .font(.system(size: 13))
                        .foregroundStyle(Theme.inkFaint)
                }
                Spacer()
                Toggle("Daily reminder", isOn: $reminders)
                    .labelsHidden()
                    .tint(Theme.accent)
                    .accessibilityLabel("Daily reminder")
                    .accessibilityIdentifier("settings-toggle-reminders")
            }

            HStack(spacing: 16) {
                Text("Reminder time")
                    .font(.system(size: 13.5, weight: .semibold))
                    .foregroundStyle(Theme.ink)
                Spacer()
                DatePicker(
                    "Reminder time",
                    selection: $reminderTime,
                    displayedComponents: .hourAndMinute
                )
                .labelsHidden()
                .disabled(!reminders)
                .accessibilityLabel("Reminder time")
                .accessibilityIdentifier("settings-field-reminder-time")
            }
            .opacity(reminders ? 1 : 0.45)
        }
        .cardStyle()
        .accessibilityIdentifier("card-reminders")
    }

    private var actions: some View {
        HStack(spacing: 10) {
            Spacer()
            Button {
                // Demo target: no persistence to cancel.
            } label: {
                Text("Cancel")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundStyle(Theme.inkSoft)
                    .padding(.horizontal, 14)
                    .padding(.vertical, 9)
            }
            .accessibilityLabel("Cancel")
            .accessibilityIdentifier("button-cancel")

            Button {
                // Demo target: no persistence to save.
            } label: {
                Text("Save changes")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundStyle(.white)
                    .padding(.horizontal, 14)
                    .padding(.vertical, 9)
                    .background(Theme.accent)
                    .clipShape(RoundedRectangle(cornerRadius: Theme.radiusSm, style: .continuous))
            }
            .accessibilityLabel("Save changes")
            .accessibilityIdentifier("button-save")
        }
    }
}
