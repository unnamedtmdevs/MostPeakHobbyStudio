import Foundation

struct Hobby: Identifiable, Codable, Sendable {
    var id: UUID
    var name: String
    var description: String
    var emoji: String
    var progress: Double
    var goalDescription: String
    var milestones: [Milestone]
    var dateCreated: Date

    init(
        id: UUID = UUID(),
        name: String,
        description: String = "",
        emoji: String = "⭐",
        progress: Double = 0.0,
        goalDescription: String = "",
        milestones: [Milestone] = [],
        dateCreated: Date = Date()
    ) {
        self.id = id
        self.name = name
        self.description = description
        self.emoji = emoji
        self.progress = max(0, min(1, progress))
        self.goalDescription = goalDescription
        self.milestones = milestones
        self.dateCreated = dateCreated
    }

    var completedMilestones: Int {
        milestones.filter(\.isCompleted).count
    }

    struct Milestone: Identifiable, Codable, Sendable {
        var id: UUID
        var title: String
        var isCompleted: Bool
        var dateCompleted: Date?

        init(
            id: UUID = UUID(),
            title: String,
            isCompleted: Bool = false,
            dateCompleted: Date? = nil
        ) {
            self.id = id
            self.title = title
            self.isCompleted = isCompleted
            self.dateCompleted = dateCompleted
        }
    }
}
