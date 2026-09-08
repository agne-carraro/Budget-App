import SwiftUI

struct RootTabView: View {
    @StateObject private var logListViewModel: LogListViewModel
	@StateObject private var settingsViewModel: SettingsViewModel
	@StateObject private var budgetListViewModel: BudgetListViewModel
	@State private var selectedMonth: SelectedMonth = .current

	init(logStore: LogStoreService, settingsStore: SettingsStoreService, budgetStore: BudgetStoreService, overallStore: OverallBudgetStoreService) {
        _logListViewModel = StateObject(wrappedValue: LogListViewModel(store: logStore))
		_settingsViewModel = StateObject(wrappedValue: SettingsViewModel(store: settingsStore))
		_budgetListViewModel = StateObject(wrappedValue: BudgetListViewModel(store: budgetStore, overallStore: overallStore))
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

            LogListView(logListViewModel: logListViewModel, selectedMonth: $selectedMonth)
                .tabItem { Label("Logs", systemImage: "list.bullet") }
			
			BudgetListView(budgetListViewModel: budgetListViewModel, logListViewModel: logListViewModel, selectedMonth: $selectedMonth)
				.tabItem { Label("Budgets", systemImage: "chart.pie.fill") }

            SettingsView(logListViewModel: logListViewModel, budgetListViewModel: budgetListViewModel, settingsViewModel: settingsViewModel)
                .tabItem { Label("Settings", systemImage: "gear") }
        }
		.preferredColorScheme(colorScheme)
    }
}

#Preview {
	RootTabView(logStore: LogStoreService(), settingsStore: SettingsStoreService(), budgetStore: BudgetStoreService(), overallStore: OverallBudgetStoreService())
}
