//
//  BirthdayReminderApp.swift
//  BirthdayReminder
//
//  Created by Jonathan Quast on 24.05.26.
//

import SwiftUI
import SwiftData

@main
struct BirthdayReminderApp: App {
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Reminder.self,
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .tint(Color.reminderBackground)
        }
        .modelContainer(sharedModelContainer)
    }
}
