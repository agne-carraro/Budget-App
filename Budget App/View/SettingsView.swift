import SwiftUI

struct SettingsView: View {
	@ObservedObject var logListViewModel: LogListViewModel
	@ObservedObject var settingsViewModel: SettingsViewModel
	
	@State private var balanceInput: String = ""
	@State private var exportURL: URL?
	
	var body: some View {
		NavigationStack {
			Form {
				Section("Appearance") {
					Picker("Mode", selection: Binding(
						get: { settingsViewModel.appearanceMode },
						set: { settingsViewModel.updateAppearanceMode($0) }
					)) {
						Text("System").tag(AppearanceMode.system)
						Text("Light").tag(AppearanceMode.light)
						Text("Dark").tag(AppearanceMode.dark)
					}
					.pickerStyle(.segmented)
				}

				Section("Starting Balance") {
					TextField("Starting balance", text: $balanceInput)
						.keyboardType(.decimalPad)
						.onSubmit {
							if let value = Double(balanceInput) {
								settingsViewModel.updateStartingBalance(value)
							}
						}
				}

				Section("Data") {
					if let exportURL = settingsViewModel.exportLogs(logListViewModel.logs) {
						ShareLink("Export Logs", item: exportURL)
					} else {
						Text("No logs to export")
					}
				}
			}
			.navigationTitle("Settings")
			.onAppear {
				balanceInput = String(settingsViewModel.startingBalance)
			}
		}
	}
}

#Preview {
	SettingsView(logListViewModel: LogListViewModel(store: LogStoreService()), settingsViewModel: SettingsViewModel(store: SettingsStoreService()))
}
