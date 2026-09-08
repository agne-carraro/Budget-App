import Foundation

protocol OverallBudgetStoring {
    func load() -> [OverallBudget]
    func save(overallBudgets: [OverallBudget])
}

class OverallBudgetStoreService: OverallBudgetStoring {
    private let saveKey = "overallBudgets"

    func load() -> [OverallBudget] {
        guard let data = UserDefaults.standard.data(forKey: saveKey),
              let budgets = try? JSONDecoder().decode([OverallBudget].self, from: data) else {
            return []
        }
        return budgets
    }

    func save(overallBudgets: [OverallBudget]) {
        if let data = try? JSONEncoder().encode(overallBudgets) {
            UserDefaults.standard.set(data, forKey: saveKey)
        }
    }
}