import SwiftUI

struct HomeView: View {
    @ObservedObject var viewModel: LogListViewModel

    private var total: Double {
        viewModel.logs.reduce(0) { partial, log in
            partial + (log.isIncome ? log.amount : -log.amount)
        }
    }

	var body: some View {
		NavigationStack {
			VStack(spacing: 24) {
				VStack {
					Text("Total")
						.font(.headline)
						.foregroundColor(.primary)
					Text(total, format: .currency(code: "EUR"))
						.font(.largeTitle.bold())
						.foregroundColor(total >= 0 ? .green : .red)
				}
				.padding()
				.frame(maxWidth: .infinity)
				.background(Color(.secondarySystemGroupedBackground))
				.cornerRadius(16)
				.shadow(radius: 0.2)

				if let last = viewModel.logs.last {
					VStack(alignment: .leading) {
						Text("Last log")
							.font(.headline)
							.foregroundColor(.primary)
						LogView(log: last)
					}
					.padding()
					.background(Color(.secondarySystemGroupedBackground))
					.cornerRadius(16)
					.shadow(radius: 0.2)
				}

				Spacer()
			}
			.padding()
			.frame(maxWidth: .infinity, maxHeight: .infinity)
			.background(Color(.systemGroupedBackground))
			.navigationTitle("Home")
		}
    }
}

#Preview {
	HomeView(viewModel: LogListViewModel(store: LogStoreService()))
}
