import Combine
import SwiftUI

final class SettingsViewModel: ObservableObject {
    @Published var notificationsEnabled: Bool {
        didSet { UserDefaults.standard.set(notificationsEnabled, forKey: "mostpeak_notifications") }
    }

    @Published var showResetConfirmation: Bool = false
    @Published var showDeleteAccountConfirmation: Bool = false

    init() {
        self.notificationsEnabled = UserDefaults.standard.bool(forKey: "mostpeak_notifications")
    }

    func resetAllData(
        hobbyVM: HobbyTrackerViewModel,
        tipsVM: WellnessTipsViewModel
    ) {
        hobbyVM.reset()
        tipsVM.reset()
    }
}
