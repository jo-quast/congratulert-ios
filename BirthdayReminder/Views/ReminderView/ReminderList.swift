import SwiftUI

/// Scrollable list of ``Reminder`` objects ordered by next occurrence.
struct ReminderList: View {
    
    let reminders: [Reminder]
    
    var body: some View {
        Group {
            if reminders.isEmpty {
                emptyState
            } else {
                List(reminders) { reminder in
                    NavigationLink(value: reminder) {
                        ReminderRow(reminder: reminder)
                    }
                    .listRowSeparator(.visible)
                    .listRowInsets(EdgeInsets())
                    .listRowBackground(Color.clear)
                }
                .listStyle(.plain)
                .navigationDestination(for: Reminder.self) { reminder in
                    EditReminderView(reminder: reminder)
                }
            }
        }
    }
    
    /// Shown when the reminders list is empty.
    private var emptyState: some View {
        ContentUnavailableView(
            "No reminders yet",
            systemImage: "calendar.badge.plus",
            description: Text("Tap + to create a reminder.")
        )
    }
}

#Preview {
    NavigationStack {
        ReminderList(reminders: Reminder.sampleData)
    }
}
