import SwiftUI

struct LogListView: View {
	@ObservedObject var logListViewModel: LogListViewModel
	@State private var isShowingAddLog = false
	@State private var logToEdit: Log?
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
						ForEach(logListViewModel.logs(for: selectedMonth)) { log in
							LogView(log: log)
								.contentShape(Rectangle())
								.onTapGesture {
									logToEdit = log
								}
						}
						.onDelete { offsets in
							let filteredLogs = logListViewModel.logs(for: selectedMonth)
							for index in offsets {
								logListViewModel.deleteLog(id: filteredLogs[index].id)
							}
						}
					}
					.scrollContentBackground(.hidden)
				}
			}
			.navigationTitle("Logs")
			.toolbar {
				ToolbarItem(placement: .navigationBarTrailing) {
					Button {
						isShowingAddLog = true
					} label: {
						Image(systemName: "plus")
					}
				}
			}
			.sheet(isPresented: $isShowingAddLog) {
				AddLogView(viewModel: logListViewModel)
			}
			.sheet(item: $logToEdit) { log in
				AddLogView(viewModel: logListViewModel, logToEdit: log)
			}
		}
	}
}
