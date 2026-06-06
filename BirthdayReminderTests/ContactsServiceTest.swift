import Testing
import Contacts
@testable import BirthdayReminder

/**
 * A mock contacts store for use in unit tests.
 * Returns a configurable list of contacts without accessing the device.
 */
final class MockContactStore: ContactStoreProtocol {

    /** Contacts to return when enumerated. */
    var contacts: [CNMutableContact] = []

    /**
     * Enumerates the mock contacts, calling the block for each one.
     */
    func enumerateContacts(with fetchRequest: CNContactFetchRequest,
                           usingBlock block: (CNContact, UnsafeMutablePointer<ObjCBool>) -> Void) throws {
        for contact in contacts {
            var stop: ObjCBool = false
            block(contact, &stop)
            if stop.boolValue { break }
        }
    }

    /**
     * Convenience helper to create a mock contact with a birthday.
     */
    static func contactWithBirthday(name: String, day: Int, month: Int, year: Int? = nil) -> CNMutableContact {
        let contact = CNMutableContact()
        contact.givenName = name
        var components = DateComponents()
        components.day = day
        components.month = month
        components.year = year
        contact.birthday = components
        return contact
    }
}

/**
 * Tests for `ContactsService` sync logic using a mock contacts store.
 */
struct ContactsServiceTests {

    @Test("Fetches birthday from contact correctly")
    func fetchesBirthday() throws {
        let mockStore = MockContactStore()
        mockStore.contacts = [
            MockContactStore.contactWithBirthday(name: "Alice", day: 15, month: 6, year: 1990)
        ]

        let service = ContactsService(store: mockStore)
        let reminders = try service.fetchFromContacts()

        #expect(reminders.count == 1)
        #expect(reminders[0].name == "Alice")
        #expect(reminders[0].day == 15)
        #expect(reminders[0].month == 6)
        #expect(reminders[0].year == 1990)
        #expect(reminders[0].type == .birthday)
        #expect(reminders[0].isSynced == true)
        #expect(reminders[0].getReminded == true)
    }

    @Test("Contact without birthday is ignored")
    func ignoresContactWithoutBirthday() throws {
        let mockStore = MockContactStore()
        let contact = CNMutableContact()
        contact.givenName = "No Birthday"
        mockStore.contacts = [contact]

        let service = ContactsService(store: mockStore)
        let reminders = try service.fetchFromContacts()

        #expect(reminders.isEmpty)
    }
}
