import Combine
import Foundation

class BudgetListViewModel: ObservableObject {
    @Published private(set) var budgets: [Budget] = []
    @Published private(set) var overallBudgets: [OverallBudget] = []

    private let store: BudgetStoring
    private let overallStore: OverallBudgetStoring

    init(store: BudgetStoring, overallStore: OverallBudgetStoring) {
        self.store = store
        self.overallStore = overallStore
        self.budgets = store.load()
        self.overallBudgets = overallStore.load()
    }

    func spent(for target: BudgetTarget, logs: [Log], month: SelectedMonth) -> Double {
        switch target {
        case .total:
            return overallSpent(logs: logs, month: month)
        case .category(let type):
            guard let budget = budget(for: type, month: month) else { return 0 }
            return spent(for: budget, logs: logs, month: month)
        }
    }

    func limit(for target: BudgetTarget, logs: [Log], month: SelectedMonth) -> Double {
        switch target {
        case .total:
            return overallEffectiveLimit(for: month, logs: logs)
        case .category(let type):
            guard let budget = budget(for: type, month: month) else { return 0 }
            return effectiveLimit(for: budget, logs: logs, month: month)
        }
    }

    func progress(for target: BudgetTarget, logs: [Log], month: SelectedMonth) -> Double {
        switch target {
        case .total:
            return overallProgress(logs: logs, month: month)
        case .category(let type):
            guard let budget = budget(for: type, month: month) else { return 0 }
            return progress(for: budget, logs: logs, month: month)
        }
    }

    func budget(for type: LogType, month: SelectedMonth) -> Budget? {
        let exactMatch = budgets.first {
            $0.type == type && $0.year == month.year && $0.month == month.month
        }
        if let exactMatch { return exactMatch }

        let earlierBudgets =
            budgets
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
            let newBudget = Budget(
                type: type, monthlyLimit: monthlyLimit, year: month.year, month: month.month)
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
        return
            logs
            .filter { log in
                log.type == budget.type && calendar.component(.month, from: log.date) == month.month
                    && calendar.component(.year, from: log.date) == month.year
            }
            .reduce(0) { total, log in
                total + (log.isIncome ? -log.amount : log.amount)
            }
    }

    private func netIncome(for budget: Budget, logs: [Log], month: SelectedMonth) -> Double {
        let calendar = Calendar.current
        return
            logs
            .filter { log in
                log.type == budget.type && log.isIncome
                    && calendar.component(.month, from: log.date) == month.month
                    && calendar.component(.year, from: log.date) == month.year
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

    func overallBudget(for month: SelectedMonth) -> OverallBudget? {
        let exactMatch = overallBudgets.first { $0.year == month.year && $0.month == month.month }
        if let exactMatch { return exactMatch }

        let earlier =
            overallBudgets
            .filter { ($0.year, $0.month) < (month.year, month.month) }
            .sorted { ($0.year, $0.month) > ($1.year, $1.month) }

        return earlier.first
    }

    func overallEffectiveLimit(for month: SelectedMonth, logs: [Log]) -> Double {
        guard let budget = overallBudget(for: month) else { return 0 }
        let netIncome =
            logs
            .filter { log in
                let calendar = Calendar.current
                return log.isIncome && calendar.component(.month, from: log.date) == month.month
                    && calendar.component(.year, from: log.date) == month.year
            }
            .reduce(0) { $0 + $1.amount }
        return budget.monthlyLimit + netIncome
    }

    func setOverallBudget(monthlyLimit: Double, month: SelectedMonth) {
        if let index = overallBudgets.firstIndex(where: {
            $0.year == month.year && $0.month == month.month
        }) {
            overallBudgets[index].monthlyLimit = monthlyLimit
        } else {
            let newBudget = OverallBudget(
                monthlyLimit: monthlyLimit, year: month.year, month: month.month)
            overallBudgets.append(newBudget)
        }
        overallStore.save(overallBudgets: overallBudgets)
    }

    func deleteOverallBudget(month: SelectedMonth) {
        overallBudgets.removeAll { $0.year == month.year && $0.month == month.month }
        overallStore.save(overallBudgets: overallBudgets)
    }

    func overallSpent(logs: [Log], month: SelectedMonth) -> Double {
        let calendar = Calendar.current
        return
            logs
            .filter { log in
                calendar.component(.month, from: log.date) == month.month
                    && calendar.component(.year, from: log.date) == month.year
            }
            .reduce(0) { total, log in
                total + (log.isIncome ? -log.amount : log.amount)
            }
    }

    func overallProgress(logs: [Log], month: SelectedMonth) -> Double {
        guard let budget = overallBudget(for: month), budget.monthlyLimit > 0 else { return 0 }
        let raw = overallSpent(logs: logs, month: month) / budget.monthlyLimit
        return min(max(raw, 0), 1.0)
    }

    func trackedTargets(for month: SelectedMonth) -> [BudgetTarget] {
        var targets: [BudgetTarget] = []
        if overallBudget(for: month) != nil {
            targets.append(.total)
        }
        targets.append(contentsOf: trackedCategories(for: month).map { .category($0) })
        return targets
    }

    func availableTargets(for month: SelectedMonth) -> [BudgetTarget] {
        var targets: [BudgetTarget] = []
        if overallBudget(for: month) == nil {
            targets.append(.total)
        }
        let usedTypes = Set(trackedCategories(for: month))
        targets.append(
            contentsOf: LogType.allCases.filter { !usedTypes.contains($0) }.map { .category($0) })
        return targets
    }
}
