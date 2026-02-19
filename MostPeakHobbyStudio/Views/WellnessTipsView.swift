import SwiftUI

struct WellnessTipsView: View {
    @EnvironmentObject private var viewModel: WellnessTipsViewModel
    @State private var selectedTip: WellnessTip? = nil

    var body: some View {
        NavigationView {
            ZStack {
                Theme.navy.ignoresSafeArea()

                VStack(spacing: 0) {
                    CategoryFilterBar(selected: $viewModel.selectedCategory)
                        .padding(.horizontal, Theme.Spacing.md)
                        .padding(.top, Theme.Spacing.sm)
                        .padding(.bottom, Theme.Spacing.sm)

                    ScrollView {
                        VStack(spacing: Theme.Spacing.sm) {
                            ForEach(viewModel.filteredTips) { tip in
                                TipCardView(tip: tip) {
                                    selectedTip = tip
                                    viewModel.markRead(tip)
                                } onFavorite: {
                                    viewModel.toggleFavorite(tip)
                                }
                            }
                        }
                        .padding(.horizontal, Theme.Spacing.md)
                        .padding(.bottom, Theme.Spacing.xl)
                    }
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    VStack(spacing: 2) {
                        Text("Wellness Tips")
                            .font(.system(size: Theme.FontSize.body, weight: .bold))
                            .foregroundStyle(Theme.white)
                        if viewModel.unreadCount > 0 {
                            Text("\(viewModel.unreadCount) unread")
                                .font(.system(size: 11))
                                .foregroundStyle(Theme.accent)
                        }
                    }
                }
            }
            .sheet(item: $selectedTip) { tip in
                TipDetailSheet(tip: tip, onFavorite: {
                    viewModel.toggleFavorite(tip)
                })
                .environmentObject(viewModel)
            }
        }
        .navigationViewStyle(.stack)
    }
}

// MARK: - Category Filter Bar

private struct CategoryFilterBar: View {
    @Binding var selected: WellnessTip.Category?

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: Theme.Spacing.sm) {
                FilterChip(title: "All", emoji: "✨", isSelected: selected == nil) {
                    selected = nil
                }

                ForEach(WellnessTip.Category.allCases, id: \.self) { category in
                    FilterChip(
                        title: category.rawValue,
                        emoji: category.emoji,
                        isSelected: selected == category
                    ) {
                        selected = selected == category ? nil : category
                    }
                }
            }
            .padding(.horizontal, 2)
        }
    }
}

private struct FilterChip: View {
    let title: String
    let emoji: String
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 4) {
                Text(emoji)
                    .font(.system(size: 14))
                Text(title)
                    .font(.system(size: 13, weight: isSelected ? .semibold : .regular))
            }
            .foregroundStyle(isSelected ? Theme.white : Theme.subtleText)
            .padding(.horizontal, Theme.Spacing.md)
            .padding(.vertical, Theme.Spacing.sm)
            .background(isSelected ? Theme.accent : Theme.white.opacity(0.1))
            .clipShape(Capsule())
        }
    }
}

// MARK: - Tip Card

private struct TipCardView: View {
    let tip: WellnessTip
    let onTap: () -> Void
    let onFavorite: () -> Void

    var body: some View {
        Button(action: onTap) {
            CardView {
                VStack(alignment: .leading, spacing: Theme.Spacing.sm) {
                    HStack(alignment: .top) {
                        VStack(alignment: .leading, spacing: Theme.Spacing.xs) {
                            HStack(spacing: Theme.Spacing.xs) {
                                Text(tip.category.emoji)
                                    .font(.caption)
                                Text(tip.category.rawValue)
                                    .font(.system(size: 12, weight: .medium))
                                    .foregroundStyle(Theme.accent)

                                if !tip.isRead {
                                    Circle()
                                        .fill(Theme.accent)
                                        .frame(width: 6, height: 6)
                                }
                            }

                            Text(tip.title)
                                .font(.system(size: Theme.FontSize.body, weight: .bold))
                                .foregroundStyle(Theme.cardText)
                                .multilineTextAlignment(.leading)
                                .fixedSize(horizontal: false, vertical: true)
                        }

                        Spacer()

                        Button(action: onFavorite) {
                            Image(systemName: tip.isFavorite ? "heart.fill" : "heart")
                                .font(.title3)
                                .foregroundStyle(tip.isFavorite ? Theme.accent : Theme.cardText.opacity(0.3))
                        }
                        .buttonStyle(.plain)
                    }

                    Text(tip.body)
                        .font(.system(size: 14))
                        .foregroundStyle(Theme.cardText.opacity(0.65))
                        .lineLimit(3)
                        .fixedSize(horizontal: false, vertical: true)

                    HStack {
                        if tip.isRead {
                            Label("Read", systemImage: "checkmark.circle.fill")
                                .font(.system(size: 12, weight: .medium))
                                .foregroundStyle(.green)
                        }
                        Spacer()
                        Text("Tap to read more")
                            .font(.system(size: 12))
                            .foregroundStyle(Theme.cardText.opacity(0.4))
                    }
                }
                .padding(Theme.Spacing.md)
            }
        }
        .buttonStyle(.plain)
    }
}

// MARK: - Tip Detail Sheet

private struct TipDetailSheet: View {
    @EnvironmentObject private var viewModel: WellnessTipsViewModel
    let tip: WellnessTip
    let onFavorite: () -> Void
    @Environment(\.dismiss) private var dismiss

    private var currentTip: WellnessTip {
        viewModel.tips.first(where: { $0.id == tip.id }) ?? tip
    }

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: Theme.Spacing.lg) {
                    VStack(alignment: .leading, spacing: Theme.Spacing.sm) {
                        HStack(spacing: Theme.Spacing.sm) {
                            Text(currentTip.category.emoji)
                                .font(.title)
                                .frame(width: 52, height: 52)
                                .background(Theme.navy.opacity(0.08))
                                .clipShape(Circle())

                            VStack(alignment: .leading, spacing: 2) {
                                Text(currentTip.category.rawValue)
                                    .font(.system(size: 14, weight: .semibold))
                                    .foregroundStyle(Theme.accent)
                                Text("Wellness Tip")
                                    .font(.system(size: 12))
                                    .foregroundStyle(.secondary)
                            }
                        }

                        Text(currentTip.title)
                            .font(.system(size: Theme.FontSize.title2, weight: .bold))
                            .fixedSize(horizontal: false, vertical: true)
                    }

                    Divider()

                    Text(currentTip.body)
                        .font(.system(size: Theme.FontSize.body))
                        .foregroundStyle(.primary)
                        .fixedSize(horizontal: false, vertical: true)
                        .lineSpacing(4)

                    Spacer()

                    Button {
                        onFavorite()
                    } label: {
                        HStack {
                            Image(systemName: currentTip.isFavorite ? "heart.fill" : "heart")
                            Text(currentTip.isFavorite ? "Remove from Favorites" : "Add to Favorites")
                        }
                        .font(.system(size: Theme.FontSize.body, weight: .semibold))
                        .foregroundStyle(currentTip.isFavorite ? Theme.white : Theme.accent)
                        .frame(maxWidth: .infinity)
                        .frame(height: 52)
                        .background(currentTip.isFavorite ? Theme.accent : Theme.accent.opacity(0.1))
                        .clipShape(RoundedRectangle(cornerRadius: Theme.Radius.md))
                    }
                }
                .padding(Theme.Spacing.lg)
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") { dismiss() }
                        .font(.system(size: Theme.FontSize.body, weight: .semibold))
                        .foregroundStyle(Theme.accent)
                }
            }
        }
        .navigationViewStyle(.stack)
    }
}

#Preview {
    WellnessTipsView()
        .environmentObject(WellnessTipsViewModel())
}
