import SwiftUI

struct BudgetListView: View {
	@ObservedObject var budgetListViewModel: BudgetListViewModel
	@ObservedObject var logListViewModel: LogListViewModel
	@State private var isShowingAddBudget = false
	@State private var budgetToEdit: Budget?

	var body: some View {
		NavigationStack {
			List {
				ForEach(budgetListViewModel.budgets) { budget in
					BudgetView(
						budget: budget,
						spent: budgetListViewModel.spent(for: budget, logs: logListViewModel.logs),
						effectiveLimit: budgetListViewModel.effectiveLimit(for: budget, logs: logListViewModel.logs),
						progress: budgetListViewModel.progress(for: budget, logs: logListViewModel.logs)
					)
					.contentShape(Rectangle())
					.onTapGesture {
						budgetToEdit = budget
					}
				}
				.onDelete(perform: budgetListViewModel.deleteBudget)
			}
			.navigationTitle("Budgets")
			.toolbar {
				ToolbarItem(placement: .navigationBarTrailing) {
					Button {
						isShowingAddBudget = true
					} label: {
						Image(systemName: "plus")
					}
					.disabled(!budgetListViewModel.hasAvailableCategories)
				}
			}
			.sheet(isPresented: $isShowingAddBudget) {
				AddBudgetView(budgetListViewModel: budgetListViewModel)
			}
			.sheet(item: $budgetToEdit) { budget in
				AddBudgetView(budgetListViewModel: budgetListViewModel, budgetToEdit: budget)
			}
		}

	}
}

#Preview {
	BudgetListView(budgetListViewModel: BudgetListViewModel(store: BudgetStoreService()), logListViewModel: LogListViewModel(store: LogStoreService()))
}
