import Foundation

struct Budget: Identifiable, Codable {
    let id: UUID
    var type: LogType
    var monthlyLimit: Double
    var year: Int
    var month: Int

    init(id: UUID = UUID(), type: LogType, monthlyLimit: Double, year: Int, month: Int) {
        self.id = id
        self.type = type
        self.monthlyLimit = monthlyLimit
        self.year = year
        self.month = month
    }
}

enum BudgetTarget: Hashable {
    case category(LogType)
    case total
}
