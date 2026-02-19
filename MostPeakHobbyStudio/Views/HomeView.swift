import SwiftUI

struct HomeView: View {
    @EnvironmentObject private var hobbyVM: HobbyTrackerViewModel
    @EnvironmentObject private var tipsVM: WellnessTipsViewModel

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: Theme.Spacing.lg) {
                    HeaderBannerView()
                    DailyTipBannerView(tip: tipsVM.dailyTip)
                    HobbyOverviewSectionView(hobbies: hobbyVM.hobbies)
                    WellnessStatsSectionView(tipsVM: tipsVM)
                }
                .padding(.horizontal, Theme.Spacing.md)
                .padding(.bottom, Theme.Spacing.xl)
            }
            .background(Theme.navy.ignoresSafeArea())
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("MostPeak")
                        .font(.system(size: Theme.FontSize.title3, weight: .bold))
                        .foregroundStyle(Theme.white)
                }
            }
        }
        .navigationViewStyle(.stack)
    }
}

private struct HeaderBannerView: View {
    private var greeting: String {
        let hour = Calendar.current.component(.hour, from: Date())
        switch hour {
        case 5..<12: return "Good morning! ☀️"
        case 12..<17: return "Good afternoon! 🌤️"
        case 17..<21: return "Good evening! 🌆"
        default: return "Good night! 🌙"
        }
    }

    var body: some View {
        CardView {
            VStack(alignment: .leading, spacing: Theme.Spacing.sm) {
                Text(greeting)
                    .font(.system(size: Theme.FontSize.title3, weight: .semibold))
                    .foregroundStyle(Theme.cardText)

                Text("Welcome back to your Hobby Studio.")
                    .font(.system(size: Theme.FontSize.body))
                    .foregroundStyle(Theme.cardText.opacity(0.7))
                    .fixedSize(horizontal: false, vertical: true)

                HStack {
                    Image(systemName: "mountain.2.fill")
                        .foregroundStyle(Theme.accent)
                    Text("Keep pushing toward your peak!")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundStyle(Theme.accent)
                }
            }
            .padding(Theme.Spacing.md)
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding(.top, Theme.Spacing.sm)
    }
}

private struct DailyTipBannerView: View {
    let tip: WellnessTip?

    var body: some View {
        if let tip = tip {
            VStack(alignment: .leading, spacing: Theme.Spacing.sm) {
                HStack {
                    Text("💡 Tip of the Day")
                        .font(.system(size: Theme.FontSize.body, weight: .bold))
                        .foregroundStyle(Theme.white)

                    Spacer()

                    Text(tip.category.emoji + " " + tip.category.rawValue)
                        .font(.system(size: 13, weight: .medium))
                        .foregroundStyle(Theme.accent)
                        .padding(.horizontal, Theme.Spacing.sm)
                        .padding(.vertical, 4)
                        .background(Theme.accent.opacity(0.15))
                        .clipShape(Capsule())
                }

                Text(tip.title)
                    .font(.system(size: Theme.FontSize.title3, weight: .semibold))
                    .foregroundStyle(Theme.white)
                    .fixedSize(horizontal: false, vertical: true)

                Text(tip.body)
                    .font(.system(size: 14))
                    .foregroundStyle(Theme.subtleText)
                    .lineLimit(3)
                    .fixedSize(horizontal: false, vertical: true)
            }
            .padding(Theme.Spacing.md)
            .background(
                RoundedRectangle(cornerRadius: Theme.Radius.lg)
                    .fill(Theme.white.opacity(0.08))
                    .overlay(
                        RoundedRectangle(cornerRadius: Theme.Radius.lg)
                            .stroke(Theme.accent.opacity(0.3), lineWidth: 1)
                    )
            )
        }
    }
}

private struct HobbyOverviewSectionView: View {
    let hobbies: [Hobby]

    var overallProgress: Double {
        guard !hobbies.isEmpty else { return 0 }
        return hobbies.map(\.progress).reduce(0, +) / Double(hobbies.count)
    }

    var body: some View {
        VStack(alignment: .leading, spacing: Theme.Spacing.md) {
            SectionHeaderView(title: "My Hobbies", systemImage: "star.fill")

            if hobbies.isEmpty {
                EmptyStateCardView(
                    emoji: "🎨",
                    message: "No hobbies yet. Add your first hobby in the Tracker tab!"
                )
            } else {
                VStack(spacing: Theme.Spacing.sm) {
                    CardView {
                        VStack(alignment: .leading, spacing: Theme.Spacing.sm) {
                            Text("Overall Progress")
                                .font(.system(size: 14, weight: .medium))
                                .foregroundStyle(Theme.cardText.opacity(0.6))

                            HStack(spacing: Theme.Spacing.md) {
                                ProgressBar(value: overallProgress, color: Theme.accent)

                                Text("\(Int(overallProgress * 100))%")
                                    .font(.system(size: Theme.FontSize.body, weight: .bold))
                                    .foregroundStyle(Theme.accent)
                                    .frame(width: 44, alignment: .trailing)
                            }

                            Text("\(hobbies.count) active \(hobbies.count == 1 ? "hobby" : "hobbies")")
                                .font(.system(size: 13))
                                .foregroundStyle(Theme.cardText.opacity(0.5))
                        }
                        .padding(Theme.Spacing.md)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    }

                    ForEach(hobbies.prefix(3)) { hobby in
                        CardView {
                            HStack(spacing: Theme.Spacing.md) {
                                Text(hobby.emoji)
                                    .font(.title2)
                                    .frame(width: 40, height: 40)
                                    .background(Theme.navy.opacity(0.08))
                                    .clipShape(Circle())

                                VStack(alignment: .leading, spacing: 4) {
                                    Text(hobby.name)
                                        .font(.system(size: Theme.FontSize.body, weight: .semibold))
                                        .foregroundStyle(Theme.cardText)
                                        .lineLimit(1)

                                    ProgressBar(value: hobby.progress, color: Theme.accent)
                                }

                                Text("\(Int(hobby.progress * 100))%")
                                    .font(.system(size: 14, weight: .bold))
                                    .foregroundStyle(Theme.accent)
                                    .frame(width: 40, alignment: .trailing)
                            }
                            .padding(Theme.Spacing.md)
                        }
                    }

                    if hobbies.count > 3 {
                        Text("+ \(hobbies.count - 3) more in Hobby Tracker")
                            .font(.system(size: 13))
                            .foregroundStyle(Theme.subtleText)
                            .frame(maxWidth: .infinity)
                    }
                }
            }
        }
    }
}

private struct WellnessStatsSectionView: View {
    @ObservedObject var tipsVM: WellnessTipsViewModel

    var body: some View {
        VStack(alignment: .leading, spacing: Theme.Spacing.md) {
            SectionHeaderView(title: "Wellness Stats", systemImage: "heart.fill")

            HStack(spacing: Theme.Spacing.md) {
                StatTileView(
                    value: "\(tipsVM.tips.filter(\.isRead).count)",
                    label: "Tips Read",
                    icon: "checkmark.circle.fill",
                    color: .green
                )
                StatTileView(
                    value: "\(tipsVM.favoriteTips.count)",
                    label: "Favorites",
                    icon: "heart.fill",
                    color: Theme.accent
                )
                StatTileView(
                    value: "\(tipsVM.tips.count)",
                    label: "Total Tips",
                    icon: "lightbulb.fill",
                    color: .yellow
                )
            }
        }
    }
}

// MARK: - Shared Sub-components

struct SectionHeaderView: View {
    let title: String
    let systemImage: String

    var body: some View {
        HStack(spacing: Theme.Spacing.sm) {
            Image(systemName: systemImage)
                .foregroundStyle(Theme.accent)
            Text(title)
                .font(.system(size: Theme.FontSize.title3, weight: .bold))
                .foregroundStyle(Theme.white)
        }
    }
}

struct ProgressBar: View {
    let value: Double
    let color: Color

    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                RoundedRectangle(cornerRadius: 4)
                    .fill(Color.gray.opacity(0.2))
                    .frame(height: 8)

                RoundedRectangle(cornerRadius: 4)
                    .fill(color)
                    .frame(width: geometry.size.width * CGFloat(min(max(value, 0), 1)), height: 8)
                    .animation(.easeInOut(duration: 0.4), value: value)
            }
        }
        .frame(height: 8)
    }
}

struct StatTileView: View {
    let value: String
    let label: String
    let icon: String
    let color: Color

    var body: some View {
        CardView {
            VStack(spacing: Theme.Spacing.sm) {
                Image(systemName: icon)
                    .font(.title2)
                    .foregroundStyle(color)

                Text(value)
                    .font(.system(size: Theme.FontSize.title2, weight: .bold))
                    .foregroundStyle(Theme.cardText)

                Text(label)
                    .font(.system(size: 12))
                    .foregroundStyle(Theme.cardText.opacity(0.6))
                    .multilineTextAlignment(.center)
                    .lineLimit(2)
            }
            .padding(Theme.Spacing.md)
            .frame(maxWidth: .infinity)
        }
    }
}

struct EmptyStateCardView: View {
    let emoji: String
    let message: String

    var body: some View {
        CardView {
            VStack(spacing: Theme.Spacing.sm) {
                Text(emoji)
                    .font(.system(size: 40))
                Text(message)
                    .font(.system(size: Theme.FontSize.body))
                    .foregroundStyle(Theme.cardText.opacity(0.6))
                    .multilineTextAlignment(.center)
                    .fixedSize(horizontal: false, vertical: true)
            }
            .padding(Theme.Spacing.lg)
            .frame(maxWidth: .infinity)
        }
    }
}

#Preview {
    HomeView()
        .environmentObject(HobbyTrackerViewModel())
        .environmentObject(WellnessTipsViewModel())
}
