//
//  Campus_GuidebookApp.swift
//  Campus-Guidebook
//
//  Created by isaak wheeler on 4/17/22.
//

import SwiftUI

@main
struct Campus_GuidebookApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
