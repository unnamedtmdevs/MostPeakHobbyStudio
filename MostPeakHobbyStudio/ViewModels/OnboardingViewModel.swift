import Combine
import SwiftUI

final class OnboardingViewModel: ObservableObject {
    @Published var currentPage: Int = 0

    let pages: [OnboardingPage] = [
        OnboardingPage(
            emoji: "🏔️",
            title: "Welcome to MostPeak",
            subtitle: "Hobby Studio",
            description: "Your personal companion for growth, hobbies, and daily wellness. Start your journey to the peak of your potential today."
        ),
        OnboardingPage(
            emoji: "🎯",
            title: "Track Your Hobbies",
            subtitle: "Stay consistent",
            description: "Add your favorite hobbies, set meaningful goals, and track your progress with milestones. Watch yourself grow day by day."
        ),
        OnboardingPage(
            emoji: "💡",
            title: "Daily Wellness Tips",
            subtitle: "Backed by science",
            description: "Receive curated tips on mental wellness, physical health, nutrition, sleep, and productivity — all designed to elevate your lifestyle."
        ),
        OnboardingPage(
            emoji: "🚀",
            title: "Set & Achieve Goals",
            subtitle: "Your path to success",
            description: "Define personal milestones for every hobby. Celebrate your wins, learn from challenges, and keep pushing toward your peak."
        )
    ]

    var totalPages: Int { pages.count }
    var isLastPage: Bool { currentPage == totalPages - 1 }
    var currentPageData: OnboardingPage { pages[currentPage] }

    func nextPage() {
        guard currentPage < totalPages - 1 else { return }
        withAnimation(.easeInOut(duration: 0.3)) {
            currentPage += 1
        }
    }

    func previousPage() {
        guard currentPage > 0 else { return }
        withAnimation(.easeInOut(duration: 0.3)) {
            currentPage -= 1
        }
    }
}

struct OnboardingPage {
    let emoji: String
    let title: String
    let subtitle: String
    let description: String
}
