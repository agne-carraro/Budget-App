import SwiftUI

struct BudgetListView: View {
	@ObservedObject var budgetListViewModel: BudgetListViewModel
	@ObservedObject var logListViewModel: LogListViewModel
	@State private var isShowingAddBudget = false
	@State private var targetToEdit: BudgetTarget?
	@Binding var selectedMonth: SelectedMonth

	var body: some View {
		NavigationStack {
			VStack(spacing: 0) {
				MonthSelectorView(selectedMonth: $selectedMonth)
					.padding()

				List {
					ForEach(budgetListViewModel.trackedTargets(for: selectedMonth), id: \.self) {
						target in
						BudgetView(
							target: target,
							spent: budgetListViewModel.spent(
								for: target, logs: logListViewModel.logs, month: selectedMonth),
							limit: budgetListViewModel.limit(
								for: target, logs: logListViewModel.logs, month: selectedMonth),
							progress: budgetListViewModel.progress(
								for: target, logs: logListViewModel.logs, month: selectedMonth)
						)
						.contentShape(Rectangle())
						.onTapGesture {
							targetToEdit = target
						}
					}
					.onDelete { offsets in
						let targets = budgetListViewModel.trackedTargets(for: selectedMonth)
						for index in offsets {
							switch targets[index] {
							case .total:
								budgetListViewModel.deleteOverallBudget(month: selectedMonth)
							case .category(let type):
								budgetListViewModel.deleteBudget(type: type, month: selectedMonth)
							}
						}
					}
				}
				.listStyle(.insetGrouped)
				.scrollContentBackground(.hidden)
			}
			.background(Color(.systemGroupedBackground))
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
				AddBudgetView(
					budgetListViewModel: budgetListViewModel, selectedMonth: selectedMonth)
			}
			.sheet(
				item: Binding(
					get: { targetToEdit.map { IdentifiableTarget(target: $0) } },
					set: { targetToEdit = $0?.target }
				)
			) { wrapped in
				AddBudgetView(
					budgetListViewModel: budgetListViewModel, selectedMonth: selectedMonth,
					targetToEdit: wrapped.target)
			}
		}
	}
}

#Preview {
	BudgetListView(
		budgetListViewModel: BudgetListViewModel(
			store: BudgetStoreService(), overallStore: OverallBudgetStoreService()),
		logListViewModel: LogListViewModel(store: LogStoreService()),
		selectedMonth: .constant(.current)
	)
}
