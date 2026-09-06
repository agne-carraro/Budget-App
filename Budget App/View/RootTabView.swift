import SwiftUI

struct RootTabView: View {
    @StateObject private var logListViewModel: LogListViewModel
	@StateObject private var settingsViewModel: SettingsViewModel

	init(logStore: LogStoreService, settingsStore: SettingsStoreService) {
        _logListViewModel = StateObject(wrappedValue: LogListViewModel(store: logStore))
		_settingsViewModel = StateObject(wrappedValue: SettingsViewModel(store: settingsStore))
    }
	
	private var colorScheme: ColorScheme? {
		switch settingsViewModel.appearanceMode {
		case .light: return .light
		case .dark: return .dark
		case .system: return nil
		}
	}

    var body: some View {
        TabView {
            HomeView(logListViewModel: logListViewModel, settingsViewModel: settingsViewModel)
                .tabItem { Label("Home", systemImage: "house.fill") }

            LogListView(logListViewModel: logListViewModel)
                .tabItem { Label("Logs", systemImage: "list.bullet") }

            SettingsView(logListViewModel: logListViewModel, settingsViewModel: settingsViewModel)
                .tabItem { Label("Settings", systemImage: "gear") }
        }
		.preferredColorScheme(colorScheme)
    }
}

#Preview {
	RootTabView(logStore: LogStoreService(), settingsStore: SettingsStoreService())
}
