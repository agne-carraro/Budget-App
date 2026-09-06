import Foundation

protocol SettingsStoring {
	func loadStartingBalance() -> Double
	func saveStartingBalance(_ value: Double)

	func loadAppearanceMode() -> AppearanceMode
	func saveAppearanceMode(_ mode: AppearanceMode)
}

class SettingsStoreService: SettingsStoring {
	private let balanceKey = "startingBalance"
	private let appearanceKey = "appearanceMode"

	func loadStartingBalance() -> Double {
		UserDefaults.standard.double(forKey: balanceKey)
	}

	func saveStartingBalance(_ value: Double) {
		UserDefaults.standard.set(value, forKey: balanceKey)
	}

	func loadAppearanceMode() -> AppearanceMode {
		let raw = UserDefaults.standard.string(forKey: appearanceKey) ?? AppearanceMode.system.rawValue
		return AppearanceMode(rawValue: raw) ?? .system
	}

	func saveAppearanceMode(_ mode: AppearanceMode) {
		UserDefaults.standard.set(mode.rawValue, forKey: appearanceKey)
	}
}
