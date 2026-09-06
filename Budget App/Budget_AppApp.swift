import SwiftUI

@main
struct Budget_AppApp: App {

    var body: some Scene {
        WindowGroup {
            LogView(log: Log(amount: 42.5, date: Date(), type: .food, note: "Lunch", isIncome: false))
        }
    }
}