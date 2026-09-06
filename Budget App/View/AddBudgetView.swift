import SwiftUI

struct AddBudgetView: View {
	@ObservedObject var budgetListViewModel: BudgetListViewModel
	@Environment(\.dismiss) private var dismiss
	
	let budgetToEdit: Budget?

	@State private var type: LogType = .other
	@State private var monthlyLimit: Double = 0
	
	init(budgetListViewModel: BudgetListViewModel, budgetToEdit: Budget? = nil) {
		self.budgetListViewModel = budgetListViewModel
		self.budgetToEdit = budgetToEdit
		_type = State(initialValue: budgetToEdit?.type ?? .other)
		_monthlyLimit = State(initialValue: budgetToEdit?.monthlyLimit ?? 0)
	}
	
	private var availableTypes: [LogType] {
		let usedTypes = Set(budgetListViewModel.budgets.map { $0.type })
		return LogType.allCases.filter { !usedTypes.contains($0) }
	}

	var body: some View {
		NavigationStack {
			Form {
				if budgetToEdit == nil {
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
			.navigationTitle(budgetToEdit == nil ? "Add Budget" : "Edit Budget")
			.toolbar {
				ToolbarItem(placement: .confirmationAction) {
					Button(budgetToEdit == nil ? "Add" : "Save") {
						if let budgetToEdit {
							budgetListViewModel.updateBudget(id: budgetToEdit.id, type: type, monthlyLimit: monthlyLimit)
						} else {
							budgetListViewModel.addBudget(type: type, monthlyLimit: monthlyLimit)
						}
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
	AddBudgetView(budgetListViewModel: BudgetListViewModel(store: BudgetStoreService()))
}
