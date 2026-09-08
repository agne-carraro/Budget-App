import Foundation

struct OverallBudget: Identifiable, Codable {
    let id: UUID
    var monthlyLimit: Double
    var year: Int
    var month: Int

    init(id: UUID = UUID(), monthlyLimit: Double, year: Int, month: Int) {
        self.id = id
        self.monthlyLimit = monthlyLimit
        self.year = year
        self.month = month
    }
}

struct IdentifiableTarget: Identifiable {
    let target: BudgetTarget
    var id: BudgetTarget { target }
}