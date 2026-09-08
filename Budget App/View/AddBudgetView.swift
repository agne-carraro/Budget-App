import SwiftUI

struct AddBudgetView: View {
    @ObservedObject var budgetListViewModel: BudgetListViewModel
    @Environment(\.dismiss) private var dismiss

    let selectedMonth: SelectedMonth
    let categoryToEdit: LogType?

    @State private var type: LogType = .other
    @State private var monthlyLimit: Double = 0

    init(budgetListViewModel: BudgetListViewModel, selectedMonth: SelectedMonth, categoryToEdit: LogType? = nil) {
        self.budgetListViewModel = budgetListViewModel
        self.selectedMonth = selectedMonth
        self.categoryToEdit = categoryToEdit

        let existingBudget = categoryToEdit.flatMap {
            budgetListViewModel.budget(for: $0, month: selectedMonth)
        }
        _type = State(initialValue: categoryToEdit ?? .other)
        _monthlyLimit = State(initialValue: existingBudget?.monthlyLimit ?? 0)
    }

    private var availableTypes: [LogType] {
        let trackedTypes = Set(budgetListViewModel.trackedCategories(for: selectedMonth))
        return LogType.allCases.filter { !trackedTypes.contains($0) }
    }

    var body: some View {
        NavigationStack {
            Form {
                if categoryToEdit == nil {
                    Picker("Category", selection: $type) {
                        ForEach(availableTypes, id: \.self) { type in
                            Text(type.rawValue.capitalized).tag(type)
                        }
                    }
                } else {
                    HStack {
                        Text("Category")
                        Spacer()
                        Text(type.rawValue.capitalized)
                            .foregroundColor(.secondary)
                    }
                }

                TextField("Monthly limit", value: $monthlyLimit, format: .number)
                    .keyboardType(.decimalPad)
            }
            .navigationTitle(categoryToEdit == nil ? "Add Budget" : "Edit Budget")
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button(categoryToEdit == nil ? "Add" : "Save") {
                        budgetListViewModel.setBudget(type: type, monthlyLimit: monthlyLimit, month: selectedMonth)
                        dismiss()
                    }
                }
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
        }
    }
}

#Preview {
    AddBudgetView(budgetListViewModel: BudgetListViewModel(store: BudgetStoreService()), selectedMonth: .current)
}