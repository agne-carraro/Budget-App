import SwiftUI

@main
struct Budget_AppApp: App {

    var body: some Scene {
        WindowGroup {
            RootTabView(store: LogStoreService())
        }
    }
}