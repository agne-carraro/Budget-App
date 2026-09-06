import SwiftUI

struct AddLogView: View {
    @ObservedObject var viewModel: LogListViewModel

    var body: some View {

    }
}

#Preview {
    AddLogView(viewModel: LogListViewModel(store: LogStoreService()))
}