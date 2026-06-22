import SwiftUI
import SwiftData

/// Displays all upcoming reminders sorted by proximity to today.
struct HomeView: View {

    // MARK: - Environment
    
    @Environment(\.modelContext) private var modelContext
    
    // MARK: - Query

    /// All reminders fetched from the SwiftData store, sorted by next occurrence date.
    @Query(sort: \Reminder.day, order: .forward)
    private var reminders: [Reminder]

    // MARK: - State

    /// Controls presentation of the add reminder sheet.
    @State private var showingAddReminder = false
    
    /// Text entered into the search field.
    @State private var searchText = ""

    // MARK: - Body

    var body: some View {
        NavigationStack {
            ReminderList(reminders: filteredReminders, onDelete: deleteReminder)
                .navigationTitle("Upcoming")
                .navigationBarTitleDisplayMode(.large)
                .searchable(text: $searchText, prompt: "Search Reminders")
                .toolbar {
                    ToolbarItem(placement: .topBarTrailing) {
                        Button {
                            showingAddReminder = true
                        } label: {
                            Image(systemName: "plus")
                                .fontWeight(.semibold)
                                .foregroundStyle(Color.appPrimaryDark)
                        }
                        .sheet(isPresented: $showingAddReminder) {
                            AddReminderView()
                        }
                    }
                }
        }
    }
    
    // MARK: - Intents

    /// Removes a reminder from the SwiftData store.
    private func deleteReminder(_ reminder: Reminder) {
        modelContext.delete(reminder)
    }

    // MARK: - Helpers
    
    /// Reminders filtered by the current search query.
    private var filteredReminders: [Reminder] {
        guard !searchText.isEmpty else { return reminders }
        return reminders.filter {
            $0.name.localizedCaseInsensitiveContains(searchText)
        }
    }
}

#Preview {
    let container = try! ModelContainer(
        for: Reminder.self,
        configurations: ModelConfiguration(isStoredInMemoryOnly: true)
    )
    for reminder in Reminder.sampleData {
        container.mainContext.insert(reminder)
    }
    return HomeView()
        .modelContainer(container)
}
