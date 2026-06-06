import SwiftData
import SwiftUI

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var reminders: [Reminder]
    @State private var contactsViewModel = ContactsViewModel()

    var body: some View {
        NavigationSplitView {
            List {
                ForEach(reminders) { reminder in
                    NavigationLink {
                        Text(reminder.name)
                    } label: {
                        Text(reminder.name)
                    }
                }
                .onDelete(perform: deleteReminder)
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    EditButton()
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: addReminder) {
                        Label(
                            String(localized: "add_reminder"),
                            systemImage: "plus"
                        )
                    }
                }
            }
        } detail: {
            Text(String(localized: "select_a_reminder"))
        }
    }

    private func addReminder() {
        withAnimation {
            // TODO
        }
    }

    private func deleteReminder(offsets: IndexSet) {
        withAnimation {
            // TODO
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(for: Reminder.self, inMemory: true)
}
