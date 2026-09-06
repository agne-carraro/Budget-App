import Foundation

protocol BudgetStoring {
	func load() -> [Budget]
	func save(budgets: [Budget])
}


class BudgetStoreService: BudgetStoring {
	private let saveKey = "budgets"

	func load() -> [Budget] {
		guard let data = UserDefaults.standard.data(forKey: saveKey),
			  let budgets = try? JSONDecoder().decode([Budget].self, from: data) else {
			return []
		}
		return budgets
	}

	func save(budgets: [Budget]) {
		if let data = try? JSONEncoder().encode(budgets) {
			UserDefaults.standard.set(data, forKey: saveKey)
		}
	}
}

