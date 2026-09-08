import SwiftUI

@main
struct Budget_AppApp: App {

    var body: some Scene {
        WindowGroup {
			RootTabView(logStore: LogStoreService(), settingsStore: SettingsStoreService(), budgetStore: BudgetStoreService(), overallStore: OverallBudgetStoreService())
        }
    }
}
