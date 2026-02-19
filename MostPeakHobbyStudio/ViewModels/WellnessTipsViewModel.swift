import Combine
import SwiftUI

final class WellnessTipsViewModel: ObservableObject {
    @Published var tips: [WellnessTip] = []
    @Published var selectedCategory: WellnessTip.Category? = nil

    private let service = WellnessTipService()

    init() {
        load()
    }

    func load() {
        tips = service.load()
    }

    var filteredTips: [WellnessTip] {
        if let category = selectedCategory {
            return tips.filter { $0.category == category }
        }
        return tips
    }

    var favoriteTips: [WellnessTip] {
        tips.filter(\.isFavorite)
    }

    var dailyTip: WellnessTip? {
        let calendar = Calendar.current
        let dayOfYear = calendar.ordinality(of: .day, in: .year, for: Date()) ?? 1
        let index = (dayOfYear - 1) % tips.count
        return tips.isEmpty ? nil : tips[index]
    }

    var unreadCount: Int {
        tips.filter { !$0.isRead }.count
    }

    func toggleRead(_ tip: WellnessTip) {
        guard let idx = tips.firstIndex(where: { $0.id == tip.id }) else { return }
        tips[idx].isRead.toggle()
        persist()
    }

    func markRead(_ tip: WellnessTip) {
        guard let idx = tips.firstIndex(where: { $0.id == tip.id }) else { return }
        tips[idx].isRead = true
        persist()
    }

    func toggleFavorite(_ tip: WellnessTip) {
        guard let idx = tips.firstIndex(where: { $0.id == tip.id }) else { return }
        tips[idx].isFavorite.toggle()
        persist()
    }

    func reset() {
        service.reset()
        load()
    }

    private func persist() {
        service.save(tips)
    }
}
