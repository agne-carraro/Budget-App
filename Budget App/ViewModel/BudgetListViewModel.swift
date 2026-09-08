import Combine
import Foundation

class BudgetListViewModel: ObservableObject {
    @Published private(set) var budgets: [Budget] = []

    private let store: BudgetStoring

    init(store: BudgetStoring) {
        self.store = store
        self.budgets = store.load()
    }

    func budget(for type: LogType, month: SelectedMonth) -> Budget? {
        let exactMatch = budgets.first {
            $0.type == type && $0.year == month.year && $0.month == month.month
        }
        if let exactMatch { return exactMatch }

        let earlierBudgets = budgets
            .filter { $0.type == type }
            .filter { ($0.year, $0.month) < (month.year, month.month) }
            .sorted { ($0.year, $0.month) > ($1.year, $1.month) }

        return earlierBudgets.first
    }

    func setBudget(type: LogType, monthlyLimit: Double, month: SelectedMonth) {
        if let index = budgets.firstIndex(where: {
            $0.type == type && $0.year == month.year && $0.month == month.month
        }) {
            budgets[index].monthlyLimit = monthlyLimit
        } else {
            let newBudget = Budget(type: type, monthlyLimit: monthlyLimit, year: month.year, month: month.month)
            budgets.append(newBudget)
        }
        store.save(budgets: budgets)
    }

    func deleteBudget(type: LogType, month: SelectedMonth) {
        budgets.removeAll { $0.type == type && $0.year == month.year && $0.month == month.month }
        store.save(budgets: budgets)
    }

    func trackedCategories(for month: SelectedMonth) -> [LogType] {
        LogType.allCases.filter { budget(for: $0, month: month) != nil }
    }

    func spent(for budget: Budget, logs: [Log], month: SelectedMonth) -> Double {
        let calendar = Calendar.current
        return logs
            .filter { log in
                log.type == budget.type &&
                calendar.component(.month, from: log.date) == month.month &&
                calendar.component(.year, from: log.date) == month.year
            }
            .reduce(0) { total, log in
                total + (log.isIncome ? -log.amount : log.amount)
            }
    }

    private func netIncome(for budget: Budget, logs: [Log], month: SelectedMonth) -> Double {
        let calendar = Calendar.current
        return logs
            .filter { log in
                log.type == budget.type && log.isIncome &&
                calendar.component(.month, from: log.date) == month.month &&
                calendar.component(.year, from: log.date) == month.year
            }
            .reduce(0) { $0 + $1.amount }
    }

    func effectiveLimit(for budget: Budget, logs: [Log], month: SelectedMonth) -> Double {
        budget.monthlyLimit + netIncome(for: budget, logs: logs, month: month)
    }

    func progress(for budget: Budget, logs: [Log], month: SelectedMonth) -> Double {
        let limit = effectiveLimit(for: budget, logs: logs, month: month)
        guard limit > 0 else { return 0 }
        let raw = spent(for: budget, logs: logs, month: month) / limit
        return min(max(raw, 0), 1.0)
    }
}