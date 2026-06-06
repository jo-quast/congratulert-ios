import Contacts
import SwiftData

/// Abstracts contact fetching to allow mocking in tests.
protocol ContactStoreProtocol {
    func enumerateContacts(
        with fetchRequest: CNContactFetchRequest,
        usingBlock block: (CNContact, UnsafeMutablePointer<ObjCBool>) -> Void
    ) throws
}

extension CNContactStore: ContactStoreProtocol {}

/// Provides functionality for synchronising reminders with the user's
/// Contacts library, including permission handling and change detection.
final class ContactsService {

    private let store: ContactStoreProtocol

    init(store: ContactStoreProtocol = CNContactStore()) {
        self.store = store
    }

    /// Requests access to the user's contacts.
    /// - returns: `true` if access was granted, `false` otherwise.
    func requestAccess() async -> Bool {
        let store = CNContactStore()
        let status = CNContactStore.authorizationStatus(for: .contacts)

        switch status {
        case .authorized: return true
        case .notDetermined:
            return (try? await store.requestAccess(for: .contacts)) ?? false
        default: return false
        }
    }

    /// Synchronises reminders derived from contacts birthdays with the SwiftData store.
    /// Inserts new reminders, updates changed ones, and deletes reminders
    /// whose source contact no longer exists or has no relevant dates.
    ///
    /// - Parameter context: The SwiftData `ModelContext` to sync into.
    /// - Returns: A `SyncResult` summarising what changed.
    /// - Throws: A `CNError` if the contacts store cannot be accessed.
    func sync(into context: ModelContext) async throws -> SyncResult {
        let contactReminders = try fetchFromContacts()

        // Build a lookup of existing contact-linked reminders by contactIdentifier
        let existing = try context.fetch(FetchDescriptor<Reminder>())
        let existingByIdentifier = Dictionary(
            uniqueKeysWithValues:
                existing
                .filter { $0.contactIdentifier != nil }
                .map { ($0.contactIdentifier!, $0) }
        )

        // Build a lookup of fetched contacts by identifier
        let fetchedByIdentifier = Dictionary(grouping: contactReminders) {
            $0.contactIdentifier!
        }

        var inserted = 0
        var updated = 0
        var deleted = 0

        // Insert or update
        for (identifier, reminders) in fetchedByIdentifier {
            for fetched in reminders {
                if let existing = existingByIdentifier[identifier] {
                    // Update if date has changed
                    if existing.day != fetched.day
                        || existing.month != fetched.month
                        || existing.year != fetched.year
                    {
                        existing.day = fetched.day
                        existing.month = fetched.month
                        existing.year = fetched.year
                        updated += 1
                    }
                } else {
                    context.insert(fetched)
                    inserted += 1
                }
            }
        }

        // Delete reminders whose contact no longer has a relevant date
        for (identifier, reminder) in existingByIdentifier {
            if fetchedByIdentifier[identifier] == nil {
                context.delete(reminder)
                deleted += 1
            }
        }

        return SyncResult(
            inserted: inserted,
            updated: updated,
            deleted: deleted
        )
    }

    
    /// Fetches all contacts that have a birthday date and maps them to `Reminder` instances.
    ///
    /// - Returns: An array of `Reminder` objects derived from the contacts store.
    /// - Throws: A `CNError` if the contacts store cannot be accessed.
    func fetchFromContacts() throws -> [Reminder] {
        let keysToFetch: [CNKeyDescriptor] = [
            CNContactGivenNameKey as CNKeyDescriptor,
            CNContactFamilyNameKey as CNKeyDescriptor,
            CNContactBirthdayKey as CNKeyDescriptor,
            CNContactIdentifierKey as CNKeyDescriptor,
        ]

        let request = CNContactFetchRequest(keysToFetch: keysToFetch)
        var reminders: [Reminder] = []

        try self.store.enumerateContacts(with: request) { contact, _ in
            let fullName = [contact.givenName, contact.familyName]
                .filter { !$0.isEmpty }
                .joined(separator: " ")

            if let bday = contact.birthday,
               let month = bday.month, let day = bday.day
            {
                reminders.append(
                    Reminder(
                        name: fullName,
                        type: .birthday,
                        day: day,
                        month: month,
                        year: bday.year,
                        contactIdentifier: contact.identifier,
                        isSynced: true
                    )
                )
            }
        }

        return reminders
    }
}

/// Summarises the outcome of a contacts sync operation.
struct SyncResult {
    let inserted: Int
    let updated: Int
    let deleted: Int
}
