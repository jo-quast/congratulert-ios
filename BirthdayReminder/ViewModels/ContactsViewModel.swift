import Observation
import SwiftData
import Foundation

/**
 Manages the state and logic for triggering a contacts sync
 and surfacing the result to the UI.
 */
@Observable
final class ContactsViewModel {

    var isSyncing = false
    var errorMessage: String?
    var lastSyncResult: SyncResult?

    /** Whether contact synchronisation is enabled. Persisted in UserDefaults. */
    var isSyncEnabled: Bool {
        get { UserDefaults.standard.bool(forKey: "contactSyncEnabled") }
        set { UserDefaults.standard.set(newValue, forKey: "contactSyncEnabled") }
    }

    private let service = ContactsService()

    /**
     Enables sync, requests contacts access, and performs an initial sync.
     - parameter context: The SwiftData `ModelContext` to sync into.
     */
    func enableSync(in context: ModelContext) async {
        guard await service.requestAccess() else {
            errorMessage = String(localized: "contacts_permission_denied")
            return
        }
        isSyncEnabled = true
        await performSync(in: context)
    }

    /**
     Disables sync and deletes all reminders marked as synced from the store.
     Manually created reminders are unaffected.
     - parameter context: The SwiftData `ModelContext` to delete from.
     */
    func disableSync(in context: ModelContext) throws {
        isSyncEnabled = false
        let synced = try context.fetch(
            FetchDescriptor<Reminder>(predicate: #Predicate { $0.isSynced })
        )
        synced.forEach { context.delete($0) }
    }

    /**
     Synchronises reminders with the contacts store if sync is enabled.
     - parameter context: The SwiftData `ModelContext` to sync into.
     */
    func performSync(in context: ModelContext) async {
        guard isSyncEnabled else { return }
        isSyncing = true
        defer { isSyncing = false }

        do {
            lastSyncResult = try await service.sync(into: context)
        } catch {
            errorMessage = String(localized: "contacts_sync_failed")
        }
    }
}
