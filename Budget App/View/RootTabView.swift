import SwiftUI

struct RootTabView: View {
    @StateObject private var viewModel: LogListViewModel

    init(store: LogStoreService) {
        _viewModel = StateObject(wrappedValue: LogListViewModel(store: store))
    }

    var body: some View {
        TabView {
            HomeView(viewModel: viewModel)
                .tabItem { Label("Home", systemImage: "house.fill") }

            LogListView(viewModel: viewModel)
                .tabItem { Label("Logs", systemImage: "list.bullet") }

            SettingsView()
                .tabItem { Label("Settings", systemImage: "gear") }
        }
    }
}

#Preview {
	RootTabView(store: LogStoreService())
}