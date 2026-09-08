import Foundation

struct SelectedMonth: Equatable {
    var year: Int
    var month: Int 

    static var current: SelectedMonth {
        let comps = Calendar.current.dateComponents([.year, .month], from: Date())
        return SelectedMonth(year: comps.year!, month: comps.month!)
    }

    func offset(by value: Int) -> SelectedMonth {
        var comps = DateComponents()
        comps.year = year
        comps.month = month + value
        let date = Calendar.current.date(from: comps)!
        let newComps = Calendar.current.dateComponents([.year, .month], from: date)
        return SelectedMonth(year: newComps.year!, month: newComps.month!)
    }

    var displayString: String {
        let comps = DateComponents(year: year, month: month)
        let date = Calendar.current.date(from: comps)!
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM yyyy"
        return formatter.string(from: date)
    }
}
