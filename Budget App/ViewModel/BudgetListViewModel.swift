import Foundation
import Combine

class BudgetListViewModel: ObservableObject {
	@Published private(set) var budgets: [Budget] = []

	private let store: BudgetStoring

	init(store: BudgetStoring) {
		self.store = store
		self.budgets = store.load()
	}
	
	var hasAvailableCategories: Bool {
		let usedTypes = Set(budgets.map { $0.type })
		return LogType.allCases.contains { !usedTypes.contains($0) }
	}

	func addBudget(type: LogType, monthlyLimit: Double) {
		if let existingIndex = budgets.firstIndex(where: { $0.type == type }) {
			budgets[existingIndex].monthlyLimit = monthlyLimit
		} else {
			let newBudget = Budget(type: type, monthlyLimit: monthlyLimit)
			budgets.append(newBudget)
		}
		store.save(budgets: budgets)
	}

	func deleteBudget(at offsets: IndexSet) {
		for index in offsets.sorted(by: >) {
			budgets.remove(at: index)
		}
		store.save(budgets: budgets)
	}
	
	func updateBudget(id: UUID, type: LogType, monthlyLimit: Double) {
		guard let index = budgets.firstIndex(where: { $0.id == id }) else { return }
		budgets[index].type = type
		budgets[index].monthlyLimit = monthlyLimit
		store.save(budgets: budgets)
	}
	
	func spent(for budget: Budget, logs: [Log]) -> Double {
		let calendar = Calendar.current
		let now = Date()

		return logs
			.filter { log in
				log.type == budget.type &&
				calendar.isDate(log.date, equalTo: now, toGranularity: .month) &&
				calendar.isDate(log.date, equalTo: now, toGranularity: .year)
			}
			.reduce(0) { total, log in
				total + (log.isIncome ? -log.amount : log.amount)
			}
	}
	
	func progress(for budget: Budget, logs: [Log]) -> Double {
		guard budget.monthlyLimit > 0 else { return 0 }
		return min(spent(for: budget, logs: logs) / budget.monthlyLimit, 1.0)
	}
}
