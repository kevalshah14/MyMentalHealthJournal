//
//  MyMentalHealthJournalApp.swift
//  MyMentalHealthJournal
//
//  Created by Keval Shah on 4/22/23.
//

import SwiftUI

@main
struct MyMentalHealthJournalApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
