import SwiftUI

struct SettingsView: View {
    @EnvironmentObject private var hobbyVM: HobbyTrackerViewModel
    @EnvironmentObject private var tipsVM: WellnessTipsViewModel
    @EnvironmentObject private var settingsVM: SettingsViewModel
    @AppStorage("hasCompletedOnboarding") private var hasCompletedOnboarding = true

    var body: some View {
        NavigationView {
            ZStack {
                Theme.navy.ignoresSafeArea()

                ScrollView {
                    VStack(spacing: Theme.Spacing.lg) {
                        AppHeaderSection()

                        NotificationSection(settingsVM: settingsVM)

                        DataSection(
                            showResetConfirmation: $settingsVM.showResetConfirmation,
                            showDeleteConfirmation: $settingsVM.showDeleteAccountConfirmation
                        )

                        AboutSection()
                    }
                    .padding(.horizontal, Theme.Spacing.md)
                    .padding(.vertical, Theme.Spacing.md)
                    .padding(.bottom, Theme.Spacing.xl)
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("Settings")
                        .font(.system(size: Theme.FontSize.title3, weight: .bold))
                        .foregroundStyle(Theme.white)
                }
            }
            .confirmationDialog(
                "Reset All Data",
                isPresented: $settingsVM.showResetConfirmation,
                titleVisibility: .visible
            ) {
                Button("Reset", role: .destructive) {
                    settingsVM.resetAllData(hobbyVM: hobbyVM, tipsVM: tipsVM)
                }
                Button("Cancel", role: .cancel) {}
            } message: {
                Text("This will permanently delete all your hobbies and reset your tips progress. This action cannot be undone.")
            }
            .confirmationDialog(
                "Delete Account",
                isPresented: $settingsVM.showDeleteAccountConfirmation,
                titleVisibility: .visible
            ) {
                Button("Delete & Restart", role: .destructive) {
                    settingsVM.resetAllData(hobbyVM: hobbyVM, tipsVM: tipsVM)
                    hasCompletedOnboarding = false
                }
                Button("Cancel", role: .cancel) {}
            } message: {
                Text("This will reset the app to its initial state and return you to onboarding. Your data will be cleared.")
            }
        }
        .navigationViewStyle(.stack)
    }
}

// MARK: - App Header Section

private struct AppHeaderSection: View {
    var body: some View {
        VStack(spacing: Theme.Spacing.sm) {
            Text("🏔️")
                .font(.system(size: 56))
                .frame(width: 80, height: 80)
                .background(Theme.white.opacity(0.1))
                .clipShape(RoundedRectangle(cornerRadius: Theme.Radius.lg))

            Text("MostPeak")
                .font(.system(size: Theme.FontSize.title2, weight: .bold))
                .foregroundStyle(Theme.white)

            Text("Hobby Studio")
                .font(.system(size: Theme.FontSize.body))
                .foregroundStyle(Theme.accent)

            Text("Version 1.0")
                .font(.system(size: 13))
                .foregroundStyle(Theme.subtleText)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, Theme.Spacing.md)
    }
}

// MARK: - Notification Section

private struct NotificationSection: View {
    @ObservedObject var settingsVM: SettingsViewModel

    var body: some View {
        SettingsSectionView(title: "Preferences") {
            SettingsToggleRow(
                icon: "bell.fill",
                iconColor: Theme.accent,
                title: "Daily Reminders",
                subtitle: "Get nudged to check in on your hobbies",
                isOn: $settingsVM.notificationsEnabled
            )
        }
    }
}

// MARK: - Data Section

private struct DataSection: View {
    @Binding var showResetConfirmation: Bool
    @Binding var showDeleteConfirmation: Bool

    var body: some View {
        SettingsSectionView(title: "Data & Privacy") {
            SettingsActionRow(
                icon: "arrow.counterclockwise",
                iconColor: .orange,
                title: "Reset All Data",
                subtitle: "Delete hobbies and reset tips",
                isDestructive: false
            ) {
                showResetConfirmation = true
            }

            Divider().padding(.leading, 52)

            SettingsActionRow(
                icon: "trash.fill",
                iconColor: .red,
                title: "Delete Account",
                subtitle: "Return to onboarding and clear all data",
                isDestructive: true
            ) {
                showDeleteConfirmation = true
            }
        }
    }
}

// MARK: - About Section

private struct AboutSection: View {
    var body: some View {
        SettingsSectionView(title: "About") {
            SettingsInfoRow(
                icon: "info.circle.fill",
                iconColor: .blue,
                title: "Version",
                value: "1.0.0"
            )

            Divider().padding(.leading, 52)

            SettingsInfoRow(
                icon: "shield.fill",
                iconColor: .green,
                title: "Privacy Policy",
                value: "View"
            )

            Divider().padding(.leading, 52)

            SettingsInfoRow(
                icon: "doc.text.fill",
                iconColor: Theme.accent,
                title: "Terms of Service",
                value: "View"
            )
        }
    }
}

// MARK: - Shared Settings Components

struct SettingsSectionView<Content: View>: View {
    let title: String
    let content: Content

    init(title: String, @ViewBuilder content: () -> Content) {
        self.title = title
        self.content = content()
    }

    var body: some View {
        VStack(alignment: .leading, spacing: Theme.Spacing.sm) {
            Text(title.uppercased())
                .font(.system(size: 12, weight: .semibold))
                .foregroundStyle(Theme.subtleText)
                .padding(.leading, 4)

            CardView {
                VStack(spacing: 0) {
                    content
                }
            }
        }
    }
}

struct SettingsToggleRow: View {
    let icon: String
    let iconColor: Color
    let title: String
    let subtitle: String
    @Binding var isOn: Bool

    var body: some View {
        HStack(spacing: Theme.Spacing.md) {
            Image(systemName: icon)
                .font(.system(size: 16))
                .foregroundStyle(Theme.white)
                .frame(width: 32, height: 32)
                .background(iconColor)
                .clipShape(RoundedRectangle(cornerRadius: Theme.Radius.sm))

            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.system(size: Theme.FontSize.body, weight: .medium))
                    .foregroundStyle(Theme.cardText)
                Text(subtitle)
                    .font(.system(size: 12))
                    .foregroundStyle(Theme.cardText.opacity(0.6))
                    .lineLimit(2)
            }

            Spacer()

            Toggle("", isOn: $isOn)
                .tint(Theme.accent)
                .labelsHidden()
        }
        .padding(Theme.Spacing.md)
    }
}

struct SettingsActionRow: View {
    let icon: String
    let iconColor: Color
    let title: String
    let subtitle: String
    let isDestructive: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: Theme.Spacing.md) {
                Image(systemName: icon)
                    .font(.system(size: 16))
                    .foregroundStyle(Theme.white)
                    .frame(width: 32, height: 32)
                    .background(iconColor)
                    .clipShape(RoundedRectangle(cornerRadius: Theme.Radius.sm))

                VStack(alignment: .leading, spacing: 2) {
                    Text(title)
                        .font(.system(size: Theme.FontSize.body, weight: .medium))
                        .foregroundStyle(isDestructive ? .red : Theme.cardText)
                    Text(subtitle)
                        .font(.system(size: 12))
                        .foregroundStyle(Theme.cardText.opacity(0.6))
                        .lineLimit(2)
                }

                Spacer()

                Image(systemName: "chevron.right")
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundStyle(Theme.cardText.opacity(0.3))
            }
            .padding(Theme.Spacing.md)
        }
        .buttonStyle(.plain)
    }
}

struct SettingsInfoRow: View {
    let icon: String
    let iconColor: Color
    let title: String
    let value: String

    var body: some View {
        HStack(spacing: Theme.Spacing.md) {
            Image(systemName: icon)
                .font(.system(size: 16))
                .foregroundStyle(Theme.white)
                .frame(width: 32, height: 32)
                .background(iconColor)
                .clipShape(RoundedRectangle(cornerRadius: Theme.Radius.sm))

            Text(title)
                .font(.system(size: Theme.FontSize.body, weight: .medium))
                .foregroundStyle(Theme.cardText)

            Spacer()

            Text(value)
                .font(.system(size: Theme.FontSize.body))
                .foregroundStyle(Theme.cardText.opacity(0.5))
        }
        .padding(Theme.Spacing.md)
    }
}

#Preview {
    SettingsView()
        .environmentObject(HobbyTrackerViewModel())
        .environmentObject(WellnessTipsViewModel())
        .environmentObject(SettingsViewModel())
}
