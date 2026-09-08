import SwiftUI

struct BudgetListView: View {
	@ObservedObject var budgetListViewModel: BudgetListViewModel
	@ObservedObject var logListViewModel: LogListViewModel
	@State private var isShowingAddBudget = false
	@State private var categoryToEdit: LogType?
	@Binding var selectedMonth: SelectedMonth

	var body: some View {
		NavigationStack {
			ZStack {
				Color(.systemGroupedBackground)
					.ignoresSafeArea()

				VStack(spacing: 0) {
					MonthSelectorView(selectedMonth: $selectedMonth)
						.padding(.vertical)

					List {
						ForEach(budgetListViewModel.trackedCategories(for: selectedMonth), id: \.self) { type in
							if let budget = budgetListViewModel.budget(for: type, month: selectedMonth) {
								BudgetView(
									budget: budget,
									spent: budgetListViewModel.spent(for: budget, logs: logListViewModel.logs, month: selectedMonth),
									effectiveLimit: budgetListViewModel.effectiveLimit(for: budget, logs: logListViewModel.logs, month: selectedMonth),
									progress: budgetListViewModel.progress(for: budget, logs: logListViewModel.logs, month: selectedMonth)
								)
								.contentShape(Rectangle())
								.onTapGesture {
									categoryToEdit = type
								}
							}
						}
						.onDelete { offsets in
							let categories = budgetListViewModel.trackedCategories(for: selectedMonth)
							for index in offsets {
								budgetListViewModel.deleteBudget(type: categories[index], month: selectedMonth)
							}
						}
					}
					.scrollContentBackground(.hidden)
				}
			}
			.navigationTitle("Budgets")
			.toolbar {
				ToolbarItem(placement: .navigationBarTrailing) {
					Button {
						isShowingAddBudget = true
					} label: {
						Image(systemName: "plus")
					}
				}
			}
			.sheet(isPresented: $isShowingAddBudget) {
				AddBudgetView(budgetListViewModel: budgetListViewModel, selectedMonth: selectedMonth)
			}
			.sheet(item: Binding(
				get: { categoryToEdit.map { IdentifiableType(type: $0) } },
				set: { categoryToEdit = $0?.type }
			)) { wrapped in
				AddBudgetView(budgetListViewModel: budgetListViewModel, selectedMonth: selectedMonth, categoryToEdit: wrapped.type)
			}
		}
	}
}

#Preview {
	BudgetListView(
		budgetListViewModel: BudgetListViewModel(store: BudgetStoreService()),
		logListViewModel: LogListViewModel(store: LogStoreService()),
		selectedMonth: .constant(.current)
	)
}
