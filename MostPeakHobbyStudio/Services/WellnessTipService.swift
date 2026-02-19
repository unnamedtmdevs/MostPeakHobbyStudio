import Foundation

struct WellnessTipService {
    private let storageKey = "mostpeak_tips_state"

    func load() -> [WellnessTip] {
        let defaults = allDefaultTips()
        guard
            let data = UserDefaults.standard.data(forKey: storageKey),
            let states = try? JSONDecoder().decode([TipState].self, from: data)
        else {
            return defaults
        }
        return defaults.map { tip in
            if let state = states.first(where: { $0.id == tip.id }) {
                var updated = tip
                updated.isRead = state.isRead
                updated.isFavorite = state.isFavorite
                return updated
            }
            return tip
        }
    }

    func save(_ tips: [WellnessTip]) {
        let states = tips.map { TipState(id: $0.id, isRead: $0.isRead, isFavorite: $0.isFavorite) }
        guard let data = try? JSONEncoder().encode(states) else { return }
        UserDefaults.standard.set(data, forKey: storageKey)
    }

    func reset() {
        UserDefaults.standard.removeObject(forKey: storageKey)
    }

    private struct TipState: Codable {
        let id: UUID
        var isRead: Bool
        var isFavorite: Bool
    }

    private func allDefaultTips() -> [WellnessTip] {
        [
            WellnessTip(
                id: UUID(uuidString: "00000000-0000-0000-0000-000000000001")!,
                title: "Practice Mindful Breathing",
                body: "Take 5 minutes each morning to focus on slow, deep breaths. Inhale for 4 counts, hold for 4, exhale for 6. This activates the parasympathetic nervous system, reducing stress hormones and increasing mental clarity throughout the day.",
                category: .mental
            ),
            WellnessTip(
                id: UUID(uuidString: "00000000-0000-0000-0000-000000000002")!,
                title: "The 20-20-20 Eye Rule",
                body: "Every 20 minutes of screen time, look at something 20 feet away for 20 seconds. This simple habit drastically reduces digital eye strain and headaches associated with prolonged device use.",
                category: .physical
            ),
            WellnessTip(
                id: UUID(uuidString: "00000000-0000-0000-0000-000000000003")!,
                title: "Hydrate Before Coffee",
                body: "Drink a full glass of water before your morning coffee. After 7-8 hours of sleep, your body is mildly dehydrated. Rehydrating first improves cognitive function, metabolism, and reduces caffeine jitters.",
                category: .nutrition
            ),
            WellnessTip(
                id: UUID(uuidString: "00000000-0000-0000-0000-000000000004")!,
                title: "Consistent Sleep Schedule",
                body: "Go to bed and wake up at the same time every day, even on weekends. A consistent sleep schedule regulates your circadian rhythm, improving sleep quality, mood, and daytime energy levels significantly.",
                category: .sleep
            ),
            WellnessTip(
                id: UUID(uuidString: "00000000-0000-0000-0000-000000000005")!,
                title: "Time Blocking Technique",
                body: "Divide your day into focused time blocks for specific tasks. Assign each activity a dedicated slot and protect that time. This eliminates decision fatigue, reduces multitasking, and can increase output by up to 80%.",
                category: .productivity
            ),
            WellnessTip(
                id: UUID(uuidString: "00000000-0000-0000-0000-000000000006")!,
                title: "Gratitude Journaling",
                body: "Write down 3 specific things you are grateful for each evening. Research shows this practice rewires neural pathways over time, increasing baseline happiness and resilience to negative events by up to 25%.",
                category: .mental
            ),
            WellnessTip(
                id: UUID(uuidString: "00000000-0000-0000-0000-000000000007")!,
                title: "Walk After Meals",
                body: "A 10-15 minute walk after eating improves blood glucose regulation, aids digestion, and reduces post-meal energy slumps. Even a short stroll can lower blood sugar spikes by up to 30%.",
                category: .physical
            ),
            WellnessTip(
                id: UUID(uuidString: "00000000-0000-0000-0000-000000000008")!,
                title: "Eat the Rainbow",
                body: "Aim to include fruits and vegetables of at least 4 different colors in your daily diet. Each color group provides unique phytonutrients and antioxidants that support different body systems and immune function.",
                category: .nutrition
            ),
            WellnessTip(
                id: UUID(uuidString: "00000000-0000-0000-0000-000000000009")!,
                title: "Create a Wind-Down Ritual",
                body: "Establish a 30-minute pre-sleep routine: dim lights, avoid screens, perhaps read or stretch. Consistent rituals signal your brain to produce melatonin, making it easier to fall asleep and improving overall sleep quality.",
                category: .sleep
            ),
            WellnessTip(
                id: UUID(uuidString: "00000000-0000-0000-0000-00000000000a")!,
                title: "Two-Minute Rule",
                body: "If a task takes less than two minutes, do it immediately rather than scheduling it. This principle from GTD (Getting Things Done) keeps your task list clean and prevents small tasks from accumulating into overwhelming backlogs.",
                category: .productivity
            ),
            WellnessTip(
                id: UUID(uuidString: "00000000-0000-0000-0000-00000000000b")!,
                title: "Digital Detox Hour",
                body: "Designate one hour daily, preferably before bed or after waking, as screen-free time. Use it for reading, journaling, stretching, or meaningful conversation. This reduces cognitive overload and restores mental energy.",
                category: .mental
            ),
            WellnessTip(
                id: UUID(uuidString: "00000000-0000-0000-0000-00000000000c")!,
                title: "Desk Posture Check",
                body: "Set an hourly reminder to check your posture. Ears over shoulders, shoulders over hips, feet flat on the floor. Poor posture leads to chronic neck and back pain that compounds over years of desk work.",
                category: .physical
            ),
            WellnessTip(
                id: UUID(uuidString: "00000000-0000-0000-0000-00000000000d")!,
                title: "Reduce Processed Sugar",
                body: "Replace one sugary snack daily with a whole-food alternative like fruit, nuts, or yogurt. Consistently reducing refined sugar intake stabilizes energy levels, improves skin health, and significantly lowers inflammation markers.",
                category: .nutrition
            ),
            WellnessTip(
                id: UUID(uuidString: "00000000-0000-0000-0000-00000000000e")!,
                title: "Keep Your Bedroom Cool",
                body: "The optimal sleep temperature is between 65-68°F (18-20°C). A cooler room mimics the natural drop in core body temperature that occurs during sleep onset, helping you fall asleep faster and stay asleep longer.",
                category: .sleep
            ),
            WellnessTip(
                id: UUID(uuidString: "00000000-0000-0000-0000-00000000000f")!,
                title: "Weekly Review Practice",
                body: "Spend 15-20 minutes each Sunday reviewing the past week and planning the next. Identify what worked, what didn't, and adjust accordingly. This meta-level awareness compounds productivity gains significantly over time.",
                category: .productivity
            )
        ]
    }
}
