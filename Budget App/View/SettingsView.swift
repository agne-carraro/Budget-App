import SwiftUI

struct SettingsView: View {
	@ObservedObject var logListViewModel: LogListViewModel
	@ObservedObject var budgetListViewModel: BudgetListViewModel
	@ObservedObject var settingsViewModel: SettingsViewModel
	@FocusState private var isAmountFocused: Bool

	@State private var balanceInput: Double = 0
	@State private var exportURL: URL?

	var body: some View {
		NavigationStack {
			Form {
				Section("Appearance") {
					Picker(
						"Mode",
						selection: Binding(
							get: { settingsViewModel.appearanceMode },
							set: { settingsViewModel.updateAppearanceMode($0) }
						)
					) {
						Text("System").tag(AppearanceMode.system)
						Text("Light").tag(AppearanceMode.light)
						Text("Dark").tag(AppearanceMode.dark)
					}
					.pickerStyle(.segmented)
				}

				Section("Starting Balance") {
					TextField("Starting balance", value: $balanceInput, format: .number)
						.keyboardType(.decimalPad)
						.focused($isAmountFocused)
						.toolbar {
							ToolbarItemGroup(placement: .keyboard) {
								Spacer()
								Button("Done") {
									settingsViewModel.updateStartingBalance(balanceInput)
									isAmountFocused = false
								}
							}
						}
				}

				Section("Data") {
					if let exportURL = settingsViewModel.exportAllData(
						logListViewModel.logs, budgetListViewModel.budgets)
					{
						ShareLink("Export All Data", item: exportURL)
					} else {
						Text("Nothing to export yet")
					}
				}
			}
			.navigationTitle("Settings")
			.onAppear {
				balanceInput = settingsViewModel.startingBalance
			}
		}
	}
}

#Preview {
	SettingsView(
		logListViewModel: LogListViewModel(store: LogStoreService()),
		budgetListViewModel: BudgetListViewModel(store: BudgetStoreService()),
		settingsViewModel: SettingsViewModel(store: SettingsStoreService()))
}
