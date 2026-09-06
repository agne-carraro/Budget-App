import SwiftUI

struct LogView: View {
	let log: Log

	var body: some View {
		HStack {
			Image(systemName: log.type.icon)

			VStack(alignment: .leading) {
				HStack {
					Text(log.date, style: .date)
					Spacer()
				}
				if !log.note.isEmpty {
					Text(log.note)
						.foregroundColor(.secondary)
				}
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
	}
}

#Preview {
	LogView(log: Log(amount: 42.5, date: Date(), type: .food, note: "Lunch", isIncome: false))
}
