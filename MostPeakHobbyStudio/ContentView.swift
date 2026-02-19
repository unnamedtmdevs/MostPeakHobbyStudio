import SwiftUI

struct ContentView: View {
    @AppStorage("hasCompletedOnboarding") private var hasCompletedOnboarding = false

    @StateObject private var hobbyVM = HobbyTrackerViewModel()
    @StateObject private var tipsVM = WellnessTipsViewModel()
    @StateObject private var settingsVM = SettingsViewModel()

    var body: some View {
        Group {
            if hasCompletedOnboarding {
                MainTabView()
                    .environmentObject(hobbyVM)
                    .environmentObject(tipsVM)
                    .environmentObject(settingsVM)
            } else {
                OnboardingView()
            }
        }
        .animation(.easeInOut(duration: 0.4), value: hasCompletedOnboarding)
    }
}

struct MainTabView: View {
    var body: some View {
        TabView {
            HomeView()
                .tabItem {
                    Label("Home", systemImage: "house.fill")
                }

            HobbyTrackerView()
                .tabItem {
                    Label("Hobbies", systemImage: "star.fill")
                }

            WellnessTipsView()
                .tabItem {
                    Label("Tips", systemImage: "heart.fill")
                }

            SettingsView()
                .tabItem {
                    Label("Settings", systemImage: "gearshape.fill")
                }
        }
        .tint(Theme.accent)
    }
}

#Preview("iPhone SE") {
    ContentView()
        .previewDevice(PreviewDevice(rawValue: "iPhone SE (3rd generation)"))
}

#Preview("iPhone 15 Pro Max") {
    ContentView()
        .previewDevice(PreviewDevice(rawValue: "iPhone 15 Pro Max"))
}

#Preview("iPad Air 11-inch") {
    ContentView()
        .previewDevice(PreviewDevice(rawValue: "iPad Air 11-inch (M2)"))
}
