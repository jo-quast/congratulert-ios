import SwiftUI
import SwiftData
import Contacts

/// Presents a searchable list of contacts with birthdays, allowing the user to
/// import one or more as ``Reminder`` records.
struct ImportFromContactsView: View {

    // MARK: - Environment

    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss

    // MARK: - Query

    /// All currently synced reminders, used to determine already-imported contacts.
    @Query(filter: #Predicate<Reminder> { $0.isSynced })
    private var syncedReminders: [Reminder]

    // MARK: - State

    /// Contacts fetched from the device address book.
    @State private var contacts: [CNContact] = []

    /// The set of contact identifiers the user has selected for import.
    @State private var selectedIdentifiers: Set<String> = []

    /// Text entered into the search field.
    @State private var searchText = ""

    /// Whether the app has been denied contacts access.
    @State private var accessDenied = false

    /// Whether the contacts fetch is still in progress.
    @State private var isLoading = true

    // MARK: - Body

    var body: some View {
        NavigationStack {
            Group {
                if isLoading {
                    ProgressView()
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else if accessDenied {
                    accessDeniedView
                } else if filteredContacts.isEmpty {
                    emptyView
                } else {
                    contactList
                }
            }
            .navigationTitle("Import from Contacts")
            .navigationBarTitleDisplayMode(.inline)
            .searchable(text: $searchText, prompt: "Search Contacts")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Import (\(selectedIdentifiers.count))") {
                        importSelected()
                    }
                    .fontWeight(.semibold)
                    .disabled(selectedIdentifiers.isEmpty)
                }
            }
        }
        .tint(.primary)
        .task { await loadContacts() }
    }

    // MARK: - Subviews

    /// The scrollable, selectable list of contacts.
    private var contactList: some View {
        List(filteredContacts, id: \.identifier) { contact in
            ContactImportRow(
                contact: contact,
                isAlreadySynced: isAlreadySynced(contact),
                isSelected: selectedIdentifiers.contains(contact.identifier)
            )
            .contentShape(Rectangle())
            .onTapGesture { toggleSelection(for: contact) }
        }
        .listStyle(.plain)
    }

    /// Shown when the user has denied contacts permission.
    private var accessDeniedView: some View {
        ContentUnavailableView(
            "Contacts Access Required",
            systemImage: "person.crop.circle.badge.xmark",
            description: Text("Please allow access in Settings to import birthdays from your contacts.")
        )
        .safeAreaInset(edge: .bottom) {
            Button("Open Settings") {
                if let url = URL(string: UIApplication.openSettingsURLString) {
                    UIApplication.shared.open(url)
                }
            }
            .buttonStyle(.borderedProminent)
            .padding(.bottom)
        }
    }

    /// Shown when there are no contacts with birthdays, or no search results.
    private var emptyView: some View {
        ContentUnavailableView(
            searchText.isEmpty ? "No Birthdays Found" : "No Results",
            systemImage: "birthday.cake",
            description: Text(
                searchText.isEmpty
                    ? "None of your contacts have a birthday saved."
                    : "No contacts match \"\(searchText)\"."
            )
        )
    }

    // MARK: - Intents

    /// Requests contacts access and fetches all contacts that have a birthday set.
    private func loadContacts() async {
        let store = CNContactStore()
        do {
            try await store.requestAccess(for: .contacts)
        } catch {
            await MainActor.run {
                accessDenied = true
                isLoading = false
            }
            return
        }

        let keysToFetch: [CNKeyDescriptor] = [
            CNContactGivenNameKey as CNKeyDescriptor,
            CNContactFamilyNameKey as CNKeyDescriptor,
            CNContactBirthdayKey as CNKeyDescriptor,
            CNContactIdentifierKey as CNKeyDescriptor,
        ]

        let request = CNContactFetchRequest(keysToFetch: keysToFetch)
        request.sortOrder = .givenName

        var fetched: [CNContact] = []
        do {
            try store.enumerateContacts(with: request) { contact, _ in
                if contact.birthday != nil {
                    fetched.append(contact)
                }
            }
        } catch {
            // Fetch failed — present empty state rather than crashing.
        }

        await MainActor.run {
            contacts = fetched
            isLoading = false
        }
    }

    /// Toggles selection for a contact, ignoring already-synced ones.
    private func toggleSelection(for contact: CNContact) {
        guard !isAlreadySynced(contact) else { return }
        if selectedIdentifiers.contains(contact.identifier) {
            selectedIdentifiers.remove(contact.identifier)
        } else {
            selectedIdentifiers.insert(contact.identifier)
        }
    }

    /// Creates ``Reminder`` records for all selected contacts and dismisses the sheet.
    private func importSelected() {
        let toImport = contacts.filter { selectedIdentifiers.contains($0.identifier) }
        for contact in toImport {
            guard let birthday = contact.birthday else { continue }
            let reminder = Reminder(
                name: [contact.givenName, contact.familyName]
                    .filter { !$0.isEmpty }
                    .joined(separator: " "),
                type: .birthday,
                day: birthday.day ?? 1,
                month: birthday.month ?? 1,
                year: birthday.year,
                contactIdentifier: contact.identifier,
                isSynced: true
            )
            modelContext.insert(reminder)
        }
        dismiss()
    }

    // MARK: - Helpers

    /// Contacts filtered by the current search query.
    private var filteredContacts: [CNContact] {
        guard !searchText.isEmpty else { return contacts }
        return contacts.filter {
            let fullName = "\($0.givenName) \($0.familyName)"
            return fullName.localizedCaseInsensitiveContains(searchText)
        }
    }

    /// Returns `true` if a contact has already been imported as a synced reminder.
    private func isAlreadySynced(_ contact: CNContact) -> Bool {
        syncedReminders.contains { $0.contactIdentifier == contact.identifier }
    }
}

#Preview("ImportFromContactsView") {
    let container = try! ModelContainer(
        for: Reminder.self,
        configurations: ModelConfiguration(isStoredInMemoryOnly: true)
    )
    return ImportFromContactsView()
        .modelContainer(container)
}
