import Combine
import Foundation

class LogListViewModel: ObservableObject {
	@Published private(set) var logs: [Log] = []

	private let store: LogStoring

	init(store: LogStoring) {
		self.store = store
		self.logs = store.load()
	}

	func logs(for month: SelectedMonth) -> [Log] {
		let calendar = Calendar.current

		return logs.filter { log in
			calendar.component(.month, from: log.date) == month.month
				&& calendar.component(.year, from: log.date) == month.year
		}
	}

	func addLog(amount: Double, date: Date, type: LogType, note: String, isIncome: Bool) {
		let newLog = Log(amount: amount, date: date, type: type, note: note, isIncome: isIncome)
		logs.append(newLog)
		store.save(logs: logs)
	}

	func deleteLog(id: UUID) {
		logs.removeAll { $0.id == id }
		store.save(logs: logs)
	}

	func updateLog(
		id: UUID, amount: Double, date: Date, type: LogType, note: String, isIncome: Bool
	) {
		guard let index = logs.firstIndex(where: { $0.id == id }) else { return }
		logs[index].amount = amount
		logs[index].date = date
		logs[index].type = type
		logs[index].note = note
		logs[index].isIncome = isIncome
		store.save(logs: logs)
	}

	func totalSpent(for month: SelectedMonth) -> Double {
		let calendar = Calendar.current
		return
			logs
			.filter { log in
				!log.isIncome && calendar.component(.month, from: log.date) == month.month
					&& calendar.component(.year, from: log.date) == month.year
			}
			.reduce(0) { $0 + $1.amount }
	}
}
