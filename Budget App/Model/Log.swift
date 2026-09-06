import Foundation

struct Log: Identifiable, Codable {
    let id: UUID
    var amount: Double
    var date: Date
    var type: LogType
    var note: String
    var isIncome: Bool

    init(id: UUID = UUID(), amount: Double, date: Date, type: LogType, note: String, isIncome: Bool) {
        self.id = id
        self.amount = amount
        self.date = date
        self.type = type
        self.note = note
        self.isIncome = isIncome
    }
}