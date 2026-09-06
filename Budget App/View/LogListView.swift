import SwiftUI

struct LogListView: View {
    @ObservedObject var logListViewModel: LogListViewModel
    @State private var isShowingAddLog = false
	@State private var logToEdit: Log?

    var body: some View {
        NavigationStack {
			List {
				ForEach(logListViewModel.logs) { log in
					LogView(log: log)
						.contentShape(Rectangle())
						.onTapGesture {
							logToEdit = log
						}
				}
				.onDelete(perform: logListViewModel.deleteLog)
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

#Preview {
    LogListView(logListViewModel: LogListViewModel(store: LogStoreService()))
}
