import SwiftUI

enum Theme {
    static let navy = Color("NavyBlue")
    static let accent = Color("AccentOrange")
    static let white = Color.white

    static let cardBackground = Color.white
    static let cardText = Color("NavyBlue")
    static let onNavyText = Color.white
    static let subtleText = Color.white.opacity(0.7)

    enum Spacing {
        static let xs: CGFloat = 4
        static let sm: CGFloat = 8
        static let md: CGFloat = 16
        static let lg: CGFloat = 24
        static let xl: CGFloat = 32
        static let xxl: CGFloat = 48
    }

    enum Radius {
        static let sm: CGFloat = 8
        static let md: CGFloat = 12
        static let lg: CGFloat = 16
        static let xl: CGFloat = 24
    }

    enum FontSize {
        static let caption: CGFloat = 12
        static let body: CGFloat = 16
        static let title3: CGFloat = 20
        static let title2: CGFloat = 24
        static let title: CGFloat = 28
        static let largeTitle: CGFloat = 34
    }
}

// MARK: - Reusable Components

struct PrimaryButton: View {
    let title: String
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.system(size: Theme.FontSize.body, weight: .semibold))
                .foregroundStyle(Theme.white)
                .frame(maxWidth: .infinity)
                .frame(height: 52)
                .background(Theme.accent)
                .clipShape(RoundedRectangle(cornerRadius: Theme.Radius.md))
        }
    }
}

struct SecondaryButton: View {
    let title: String
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.system(size: Theme.FontSize.body, weight: .medium))
                .foregroundStyle(Theme.white)
                .frame(maxWidth: .infinity)
                .frame(height: 52)
                .background(Theme.white.opacity(0.15))
                .clipShape(RoundedRectangle(cornerRadius: Theme.Radius.md))
                .overlay(
                    RoundedRectangle(cornerRadius: Theme.Radius.md)
                        .stroke(Theme.white.opacity(0.4), lineWidth: 1)
                )
        }
    }
}

struct CardView<Content: View>: View {
    let content: Content

    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }

    var body: some View {
        content
            .background(Theme.cardBackground)
            .clipShape(RoundedRectangle(cornerRadius: Theme.Radius.lg))
            .shadow(color: Color.black.opacity(0.08), radius: 8, x: 0, y: 2)
    }
}
