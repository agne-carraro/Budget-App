//
//  Budget_AppApp.swift
//  Budget App
//
//  Created by Agnese Carraro on 2026-08-30.
//

import SwiftUI
import CoreData

@main
struct Budget_AppApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
