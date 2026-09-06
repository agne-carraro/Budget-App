import SwiftUI

struct LogListView: View {
    @ObservedObject var viewModel: LogListViewModel
    @State private var isShowingAddLog = false
	@State private var logToEdit: Log?

    var body: some View {
        NavigationStack {
			List {
				ForEach(viewModel.logs) { log in
					LogView(log: log)
						.contentShape(Rectangle())
						.onTapGesture {
							logToEdit = log
						}
				}
				.onDelete(perform: viewModel.deleteLog)
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
                AddLogView(viewModel: viewModel)
            }
			.sheet(item: $logToEdit) { log in
				AddLogView(viewModel: viewModel, logToEdit: log)
			}
        }

    }

}

#Preview {
    LogListView(viewModel: LogListViewModel(store: LogStoreService()))
}