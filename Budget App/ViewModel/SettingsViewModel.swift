import Foundation
import Combine

class SettingsViewModel: ObservableObject {
	@Published private(set) var appearanceMode: AppearanceMode
	@Published private(set) var startingBalance: Double

	private let store: SettingsStoring

	init(store: SettingsStoring) {
		self.store = store
		self.appearanceMode = store.loadAppearanceMode()
		self.startingBalance = store.loadStartingBalance()
	}

	func updateAppearanceMode(_ mode: AppearanceMode) {
		appearanceMode = mode
		store.saveAppearanceMode(mode)
	}

	func updateStartingBalance(_ value: Double) {
		startingBalance = value
		store.saveStartingBalance(value)
	}

	func exportLogs(_ logs: [Log]) -> URL? {
		exportToCSV(logs: logs)
	}
}
