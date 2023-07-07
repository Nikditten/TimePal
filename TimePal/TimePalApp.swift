//
//  TimePalApp.swift
//  TimePal
//
//  Created by Niklas Børner on 07/07/2023.
//

import SwiftUI

@main
struct TimePalApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
