import SwiftUI
import SwiftData
import Contacts

/// Sheet presented when the user wants to create a new ``Reminder``.
struct AddReminderView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss

    @State private var name: String = ""
    @State private var selectedType: ReminderType = .birthday
    @State private var selectedDay: Int = Calendar.current.component(
        .day,
        from: Date()
    )
    @State private var selectedMonth: Int = Calendar.current.component(
        .month,
        from: Date()
    )
    @State private var selectedYear: Int? = Calendar.current.component(
        .year,
        from: Date()
    )
    @State private var associatedContact: CNContact? = nil
    @State private var note: String? = ""
    @State private var showContactPicker: Bool = false

    var body: some View {
        NavigationStack {
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
            .navigationTitle("New Reminder")
            .navigationBarTitleDisplayMode(.inline)
            .presentationDragIndicator(.visible)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "xmark")
                            .fontWeight(.semibold)
                    }
                    .tint(Color.appPrimary)
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Add") { save() }
                        .disabled(
                            name.trimmingCharacters(in: .whitespaces).isEmpty
                        )
                        .tint(Color.appPrimary)
                }
            }
            .sheet(isPresented: $showContactPicker) {
                ContactPickerView { contact in
                    associatedContact = contact
                    prefillNameIfNeeded(from: contact)
                }
                .ignoresSafeArea()
            }
        }
    }

    // MARK: - Actions

    /// Pre-fills the name field from a contact if the field is currently empty.
    private func prefillNameIfNeeded(from contact: CNContact) {
        guard name.trimmingCharacters(in: .whitespaces).isEmpty else { return }
        let firstName = contact.givenName
        let typeName = selectedType.label
        if firstName.isEmpty {
            name = "\(contact.familyName)'s \(typeName)"
        } else {
            name = "\(firstName)'s \(typeName)"
        }
    }

    /// Validates the form and inserts a new ``Reminder`` into the model context.
    private func save() {
        let trimmedName = name.trimmingCharacters(in: .whitespaces)
        guard !trimmedName.isEmpty else { return }

        let reminder = Reminder(
            name: trimmedName,
            type: selectedType,
            day: selectedDay,
            month: selectedMonth,
            year: selectedYear
        )
        modelContext.insert(reminder)
        dismiss()
    }
}
