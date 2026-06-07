import SwiftUI
import SwiftData

/// The main entry point for the BirthdayReminder app.
///
/// Responsible for bootstrapping the SwiftData stack by configuring
/// the `ModelContainer` with the app's schema, and injecting it into
/// the SwiftUI environment for use across all views.
@main
struct BirthdayReminderApp: App {
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Reminder.self,
        ])
        let modelConfiguration = ModelConfiguration(
            schema: schema,
            isStoredInMemoryOnly: false
        )

        do {
            return try ModelContainer(
                for: schema,
                configurations: [modelConfiguration]
            )
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .tint(Color.appBackground)
        }
        .modelContainer(sharedModelContainer)
    }
}
