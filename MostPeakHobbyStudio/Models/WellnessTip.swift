import Foundation

struct WellnessTip: Identifiable, Codable, Sendable {
    var id: UUID
    var title: String
    var body: String
    var category: Category
    var isRead: Bool
    var isFavorite: Bool

    init(
        id: UUID = UUID(),
        title: String,
        body: String,
        category: Category,
        isRead: Bool = false,
        isFavorite: Bool = false
    ) {
        self.id = id
        self.title = title
        self.body = body
        self.category = category
        self.isRead = isRead
        self.isFavorite = isFavorite
    }

    enum Category: String, Codable, CaseIterable, Sendable {
        case mental = "Mental"
        case physical = "Physical"
        case nutrition = "Nutrition"
        case sleep = "Sleep"
        case productivity = "Productivity"

        var emoji: String {
            switch self {
            case .mental: return "🧠"
            case .physical: return "💪"
            case .nutrition: return "🥗"
            case .sleep: return "😴"
            case .productivity: return "⚡"
            }
        }

        var systemImage: String {
            switch self {
            case .mental: return "brain.head.profile"
            case .physical: return "figure.run"
            case .nutrition: return "leaf.fill"
            case .sleep: return "moon.stars.fill"
            case .productivity: return "bolt.fill"
            }
        }
    }
}
