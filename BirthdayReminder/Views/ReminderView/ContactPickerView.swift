import SwiftUI
import ContactsUI

/// A `UIViewControllerRepresentable` that presents the system contact picker.
/// Calls `onSelect` with the chosen ``CNContact``.
struct ContactPickerView: UIViewControllerRepresentable {
    var onSelect: (CNContact) -> Void

    func makeUIViewController(context: Context) -> CNContactPickerViewController {
        let picker = CNContactPickerViewController()
        picker.delegate = context.coordinator
        // Request enough keys to build a pre-fill name.
        picker.predicateForEnablingContact = nil
        return picker
    }

    func updateUIViewController(_ uiViewController: CNContactPickerViewController, context: Context) {}

    func makeCoordinator() -> Coordinator { Coordinator(onSelect: onSelect) }

    /// Bridges `CNContactPickerDelegate` callbacks into SwiftUI.
    class Coordinator: NSObject, CNContactPickerDelegate {
        let onSelect: (CNContact) -> Void
        init(onSelect: @escaping (CNContact) -> Void) { self.onSelect = onSelect }

        func contactPicker(_ picker: CNContactPickerViewController, didSelect contact: CNContact) {
            onSelect(contact)
        }
    }
}
