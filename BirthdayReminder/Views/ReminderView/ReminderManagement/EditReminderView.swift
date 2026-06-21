import SwiftUI
import SwiftData
import Contacts

struct EditReminderView: View {
    @Environment(\.dismiss) private var dismiss
    let reminder: Reminder

    @State private var name: String
    @State private var selectedType: ReminderType
    @State private var selectedDay: Int
    @State private var selectedMonth: Int
    @State private var selectedYear: Int?
    @State private var associatedContact: CNContact? = nil
    @State private var note: String? = nil
    @State private var showContactPicker: Bool = false
    @State private var contactLoadError: String? = nil

    init(reminder: Reminder) {
        self.reminder = reminder
        _name = State(initialValue: reminder.name)
        _selectedType = State(initialValue: reminder.type)
        _selectedDay = State(initialValue: reminder.day)
        _selectedMonth = State(initialValue: reminder.month)
        _selectedYear = State(initialValue: reminder.year)
        _associatedContact = State(initialValue: nil)
        _note = State(wrappedValue: reminder.note)
    }

    var body: some View {
        Form {
            ReminderForm(
                name: $name,
                selectedType: $selectedType,
                selectedDay: $selectedDay,
                selectedMonth: $selectedMonth,
                selectedYear: $selectedYear,
                associatedContact: $associatedContact,
                note: $note,
                showContactPicker: $showContactPicker
            )
        }
        .navigationTitle("Edit Reminder")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .confirmationAction) {
                Button("Save") { save() }
                    .disabled(name.trimmingCharacters(in: .whitespaces).isEmpty)
                    .tint(Color.appPrimary)
            }
        }
        .sheet(isPresented: $showContactPicker) {
            ContactPickerView { contact in
                associatedContact = contact
            }
            .ignoresSafeArea()
        }
        .task {
            loadAssociatedContact()
        }
        .alert(
            "Couldn't load contact",
            isPresented: .constant(contactLoadError != nil)
        ) {
            Button("OK") { contactLoadError = nil }
        } message: {
            Text(contactLoadError ?? "")
        }
    }

    private func save() {
        reminder.name = name.trimmingCharacters(in: .whitespaces)
        reminder.type = selectedType
        reminder.day = selectedDay
        reminder.month = selectedMonth
        reminder.year = selectedYear
        reminder.contactIdentifier = associatedContact?.identifier
        reminder.note = note
        dismiss()
    }
    
    /// Fetches the contact associated with this reminder from the device's contact store
    /// and assigns it to `associatedContact`. Runs asynchronously after the view appears.
    /// If the contact cannot be fetched, `contactLoadError` is populated with an error message
    /// to be displayed to the user. Does nothing if no `contactIdentifier` is set on the reminder.
    private func loadAssociatedContact() {
        guard let identifier = reminder.contactIdentifier else { return }
        
        Task {
            let store = CNContactStore()
            let keys = [CNContactGivenNameKey, CNContactFamilyNameKey] as [CNKeyDescriptor]
            
            do {
                let contact = try store.unifiedContact(
                    withIdentifier: identifier,
                    keysToFetch: keys
                )
                await MainActor.run {
                    associatedContact = contact
                }
            } catch {
                await MainActor.run {
                    contactLoadError = error.localizedDescription
                }
            }
        }
    }
}
