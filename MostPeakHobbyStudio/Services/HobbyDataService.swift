import Foundation

struct HobbyDataService {
    private let storageKey = "mostpeak_hobbies"

    func load() -> [Hobby] {
        guard
            let data = UserDefaults.standard.data(forKey: storageKey),
            let hobbies = try? JSONDecoder().decode([Hobby].self, from: data)
        else {
            return []
        }
        return hobbies
    }

    func save(_ hobbies: [Hobby]) {
        guard let data = try? JSONEncoder().encode(hobbies) else { return }
        UserDefaults.standard.set(data, forKey: storageKey)
    }

    func reset() {
        UserDefaults.standard.removeObject(forKey: storageKey)
    }
}
