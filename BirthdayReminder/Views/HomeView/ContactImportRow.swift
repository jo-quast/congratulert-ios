import Contacts
import SwiftUI

/// A single row in the contacts import list, showing name, birthday, and selection state.
struct ContactImportRow: View {

    let contact: CNContact
    let isAlreadySynced: Bool
    let isSelected: Bool

    // MARK: - Body

    var body: some View {
        HStack(spacing: 14) {
            // Selection indicator
            ZStack {
                Circle()
                    .strokeBorder(borderColor, lineWidth: 1.5)
                    .frame(width: 26, height: 26)

                if isAlreadySynced {
                    Image(systemName: "checkmark")
                        .font(.system(size: 12, weight: .semibold))
                        .foregroundStyle(Color.secondary)
                } else if isSelected {
                    Circle()
                        .fill(Color.appPrimaryDark)
                        .frame(width: 26, height: 26)
                    Image(systemName: "checkmark")
                        .font(.system(size: 12, weight: .semibold))
                        .foregroundStyle(.white)
                }
            }

            // Name and birthday
            VStack(alignment: .leading, spacing: 2) {
                Text(fullName)
                    .font(.body)
                    .foregroundStyle(isAlreadySynced ? Color.secondary : Color.primary)

                if let birthdayString {
                    Text(birthdayString)
                        .font(.subheadline)
                        .foregroundStyle(Color.secondary)
                }
            }

            Spacer()

            if isAlreadySynced {
                Text("Added")
                    .font(.caption)
                    .foregroundStyle(Color.secondary)
            }
        }
        .padding(.vertical, 4)
        .contentShape(Rectangle())
    }

    // MARK: - Helpers

    private var fullName: String {
        [contact.givenName, contact.familyName]
            .filter { !$0.isEmpty }
            .joined(separator: " ")
    }

    private var borderColor: Color {
        if isAlreadySynced { return Color.secondary.opacity(0.4) }
        if isSelected { return Color.appPrimaryDark }
        return Color.secondary.opacity(0.4)
    }

    /// A human-readable birthday string, omitting year if not set.
    private var birthdayString: String? {
        guard let components = contact.birthday else { return nil }
        var dateComponents = DateComponents()
        dateComponents.day = components.day
        dateComponents.month = components.month
        if let year = components.year, year != 1 {
            dateComponents.year = year
        }
        guard let date = Calendar.current.date(from: dateComponents) else { return nil }
        let hasYear = dateComponents.year != nil
        let formatter = DateFormatter()
        formatter.dateFormat = hasYear ? "d MMMM yyyy" : "d MMMM"
        return formatter.string(from: date)
    }
}

#Preview("ContactImportRow – States") {
    List {
        ContactImportRow(
            contact: previewContacts[0],
            isAlreadySynced: false,
            isSelected: false
        )
        ContactImportRow(
            contact: previewContacts[1],
            isAlreadySynced: false,
            isSelected: true
        )
        ContactImportRow(
            contact: previewContacts[2],
            isAlreadySynced: true,
            isSelected: false
        )
    }
    .listStyle(.plain)
}
