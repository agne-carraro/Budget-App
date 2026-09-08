import SwiftUI

struct AddBudgetView: View {
    @ObservedObject var budgetListViewModel: BudgetListViewModel
    @Environment(\.dismiss) private var dismiss

    let selectedMonth: SelectedMonth
    let targetToEdit: BudgetTarget?

    @State private var target: BudgetTarget = .total
    @State private var monthlyLimit: Double = 0

    init(budgetListViewModel: BudgetListViewModel, selectedMonth: SelectedMonth, targetToEdit: BudgetTarget? = nil) {
        self.budgetListViewModel = budgetListViewModel
        self.selectedMonth = selectedMonth
        self.targetToEdit = targetToEdit

        let existingLimit: Double
        switch targetToEdit {
        case .total:
            existingLimit = budgetListViewModel.overallBudget(for: selectedMonth)?.monthlyLimit ?? 0
        case .category(let type):
            existingLimit = budgetListViewModel.budget(for: type, month: selectedMonth)?.monthlyLimit ?? 0
        case nil:
            existingLimit = 0
        }

        _target = State(initialValue: targetToEdit ?? .total)
        _monthlyLimit = State(initialValue: existingLimit)
    }

    private var targetLabel: String {
        switch target {
        case .total: return "Total"
        case .category(let type): return type.rawValue.capitalized
        }
    }

    var body: some View {
        NavigationStack {
            Form {
                if targetToEdit == nil {
                    Picker("Category", selection: $target) {
                        ForEach(budgetListViewModel.availableTargets(for: selectedMonth), id: \.self) { target in
                            Text(label(for: target)).tag(target)
                        }
                    }
                } else {
                    HStack {
                        Text("Category")
                        Spacer()
                        Text(targetLabel)
                            .foregroundColor(.secondary)
                    }
                }

                TextField("Monthly limit", value: $monthlyLimit, format: .number)
                    .keyboardType(.decimalPad)
            }
            .navigationTitle(targetToEdit == nil ? "Add Budget" : "Edit Budget")
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button(targetToEdit == nil ? "Add" : "Save") {
                        switch target {
                        case .total:
                            budgetListViewModel.setOverallBudget(monthlyLimit: monthlyLimit, month: selectedMonth)
                        case .category(let type):
                            budgetListViewModel.setBudget(type: type, monthlyLimit: monthlyLimit, month: selectedMonth)
                        }
                        dismiss()
                    }
                }
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
            }
        }
    }

    private func label(for target: BudgetTarget) -> String {
        switch target {
        case .total: return "Total"
        case .category(let type): return type.rawValue.capitalized
        }
    }
}

#Preview {
	AddBudgetView(budgetListViewModel: BudgetListViewModel(store: BudgetStoreService(), overallStore: OverallBudgetStoreService()), selectedMonth: .current, targetToEdit: .total)
}
