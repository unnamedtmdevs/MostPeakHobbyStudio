import Combine
import SwiftUI

final class HobbyTrackerViewModel: ObservableObject {
    @Published var hobbies: [Hobby] = []
    @Published var showAddHobby: Bool = false
    @Published var selectedHobby: Hobby? = nil

    private let service = HobbyDataService()

    init() {
        load()
    }

    func load() {
        hobbies = service.load()
    }

    func add(_ hobby: Hobby) {
        hobbies.append(hobby)
        persist()
    }

    func update(_ hobby: Hobby) {
        guard let idx = hobbies.firstIndex(where: { $0.id == hobby.id }) else { return }
        hobbies[idx] = hobby
        persist()
    }

    func delete(at offsets: IndexSet) {
        hobbies.remove(atOffsets: offsets)
        persist()
    }

    func delete(_ hobby: Hobby) {
        hobbies.removeAll { $0.id == hobby.id }
        persist()
    }

    func updateProgress(for hobby: Hobby, progress: Double) {
        guard let idx = hobbies.firstIndex(where: { $0.id == hobby.id }) else { return }
        hobbies[idx].progress = max(0, min(1, progress))
        persist()
    }

    func toggleMilestone(_ milestone: Hobby.Milestone, in hobby: Hobby) {
        guard let hobbyIdx = hobbies.firstIndex(where: { $0.id == hobby.id }),
              let milestoneIdx = hobbies[hobbyIdx].milestones.firstIndex(where: { $0.id == milestone.id })
        else { return }

        hobbies[hobbyIdx].milestones[milestoneIdx].isCompleted.toggle()
        if hobbies[hobbyIdx].milestones[milestoneIdx].isCompleted {
            hobbies[hobbyIdx].milestones[milestoneIdx].dateCompleted = Date()
        } else {
            hobbies[hobbyIdx].milestones[milestoneIdx].dateCompleted = nil
        }
        persist()
    }

    func reset() {
        hobbies = []
        service.reset()
    }

    var overallProgress: Double {
        guard !hobbies.isEmpty else { return 0 }
        return hobbies.map(\.progress).reduce(0, +) / Double(hobbies.count)
    }

    private func persist() {
        service.save(hobbies)
    }
}
