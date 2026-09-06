import SwiftUI

struct LogListView: View {
    @StateObject private var viewModel: LogListViewModel
    @State private var isShowingAddLog = false

    init(store: LogStoreService) {
        _viewModel = StateObject(wrappedValue: LogListViewModel(store: store))
    }

    var body: some View {
        NavigationStack {
            List {
                ForEach(viewModel.logs) { log in
                    LogView(log: log)
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
        }

    }

}

#Preview {
    LogListView(store: LogStoreService())
}
