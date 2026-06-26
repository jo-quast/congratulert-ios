#if DEBUG
import Contacts

// MARK: - Mock Contact Factory

/// Creates a mock ``CNContact`` populated with the given properties, for use in SwiftUI previews.
/// - Parameters:
///   - givenName: The contact's first name.
///   - familyName: The contact's last name.
///   - birthdayMonth: The month component of the contact's birthday.
///   - birthdayDay: The day component of the contact's birthday.
///   - birthdayYear: The optional year component of the contact's birthday.
func makeMockContact(
    givenName: String,
    familyName: String,
    birthdayMonth: Int,
    birthdayDay: Int,
    birthdayYear: Int? = nil
) -> CNContact {
    let contact = CNMutableContact()
    contact.givenName = givenName
    contact.familyName = familyName
    var birthday = DateComponents()
    birthday.month = birthdayMonth
    birthday.day = birthdayDay
    birthday.year = birthdayYear
    contact.birthday = birthday
    return contact.copy() as! CNContact
}

// MARK: - Sample Data

/// A curated set of mock contacts with birthdays, for use in SwiftUI previews.
let previewContacts: [CNContact] = [
    makeMockContact(givenName: "Ada",   familyName: "Lovelace",   birthdayMonth: 12, birthdayDay: 10, birthdayYear: 1815),
    makeMockContact(givenName: "Grace", familyName: "Hopper",     birthdayMonth: 12, birthdayDay: 9,  birthdayYear: 1906),
    makeMockContact(givenName: "Alan",  familyName: "Turing",     birthdayMonth: 6,  birthdayDay: 23),
    makeMockContact(givenName: "Tim",   familyName: "Berners-Lee", birthdayMonth: 6,  birthdayDay: 8),
]
#endif
