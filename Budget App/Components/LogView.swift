import SwiftUI

struct LogView: View {
	let log: Log

	var body: some View {
		HStack {
			Image(systemName: log.type.icon)
			.padding()
			VStack(alignment: .leading) {
				HStack {
					Text(log.date, style: .date)
				}
				Text(log.note)
			}
			Spacer()
			Text(
				log.isIncome
				? "+\(log.amount, specifier: "%.2f")"
				: "-\(log.amount, specifier: "%.2f")"
			)
			.foregroundColor(log.isIncome ? .green : .red)
			.font(.headline)
		}
		.padding(.horizontal)
	}
}

#Preview {
	LogView(log: Log(amount: 42.5, date: Date(), type: .food, note: "Lunch", isIncome: false))
}
