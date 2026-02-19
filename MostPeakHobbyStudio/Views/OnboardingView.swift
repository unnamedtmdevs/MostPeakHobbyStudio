import SwiftUI

struct OnboardingView: View {
    @AppStorage("hasCompletedOnboarding") private var hasCompletedOnboarding = false
    @StateObject private var viewModel = OnboardingViewModel()

    var body: some View {
        ZStack {
            Theme.navy.ignoresSafeArea()

            VStack(spacing: 0) {
                TabView(selection: $viewModel.currentPage) {
                    ForEach(Array(viewModel.pages.enumerated()), id: \.offset) { index, page in
                        OnboardingPageView(page: page)
                            .tag(index)
                    }
                }
                .tabViewStyle(.page(indexDisplayMode: .never))
                .animation(.easeInOut(duration: 0.3), value: viewModel.currentPage)

                VStack(spacing: Theme.Spacing.lg) {
                    PageIndicatorView(
                        total: viewModel.totalPages,
                        current: viewModel.currentPage
                    )

                    if viewModel.isLastPage {
                        PrimaryButton(title: "Get Started") {
                            withAnimation(.easeInOut(duration: 0.3)) {
                                hasCompletedOnboarding = true
                            }
                        }
                        .padding(.horizontal, Theme.Spacing.lg)
                    } else {
                        HStack(spacing: Theme.Spacing.md) {
                            if viewModel.currentPage > 0 {
                                SecondaryButton(title: "Back") {
                                    viewModel.previousPage()
                                }
                            }

                            PrimaryButton(title: "Next") {
                                viewModel.nextPage()
                            }
                        }
                        .padding(.horizontal, Theme.Spacing.lg)
                    }

                    Button("Skip") {
                        withAnimation(.easeInOut(duration: 0.3)) {
                            hasCompletedOnboarding = true
                        }
                    }
                    .font(.system(size: Theme.FontSize.body, weight: .medium))
                    .foregroundStyle(Theme.subtleText)
                }
                .padding(.bottom, Theme.Spacing.xl)
            }
        }
    }
}

private struct OnboardingPageView: View {
    let page: OnboardingPage

    var body: some View {
        VStack(spacing: Theme.Spacing.lg) {
            Spacer()

            Text(page.emoji)
                .font(.system(size: 80))

            VStack(spacing: Theme.Spacing.sm) {
                Text(page.title)
                    .font(.system(size: Theme.FontSize.largeTitle, weight: .bold))
                    .foregroundStyle(Theme.white)
                    .multilineTextAlignment(.center)

                Text(page.subtitle)
                    .font(.system(size: Theme.FontSize.title3, weight: .semibold))
                    .foregroundStyle(Theme.accent)
                    .multilineTextAlignment(.center)
            }

            Text(page.description)
                .font(.system(size: Theme.FontSize.body))
                .foregroundStyle(Theme.subtleText)
                .multilineTextAlignment(.center)
                .lineLimit(nil)
                .fixedSize(horizontal: false, vertical: true)
                .padding(.horizontal, Theme.Spacing.xl)

            Spacer()
        }
        .padding(.horizontal, Theme.Spacing.lg)
    }
}

private struct PageIndicatorView: View {
    let total: Int
    let current: Int

    var body: some View {
        HStack(spacing: Theme.Spacing.sm) {
            ForEach(0..<total, id: \.self) { index in
                Capsule()
                    .fill(index == current ? Theme.accent : Theme.white.opacity(0.3))
                    .frame(width: index == current ? 24 : 8, height: 8)
                    .animation(.easeInOut(duration: 0.3), value: current)
            }
        }
    }
}

#Preview("iPhone SE") {
    OnboardingView()
        .previewDevice(PreviewDevice(rawValue: "iPhone SE (3rd generation)"))
}

#Preview("iPhone 15 Pro Max") {
    OnboardingView()
        .previewDevice(PreviewDevice(rawValue: "iPhone 15 Pro Max"))
}

#Preview("iPad Air 11-inch") {
    OnboardingView()
        .previewDevice(PreviewDevice(rawValue: "iPad Air 11-inch (M2)"))
}
