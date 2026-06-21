import Foundation
import SwiftData

@Model
final class Reminder {
    var id: UUID
    var name: String
    var type: ReminderType
    var day: Int
    var month: Int
    var year: Int?
    var note: String?
    var contactIdentifier: String?
    var isSynced: Bool
    var getReminded: Bool

    
    /// Initializes a new `Reminder` object.
    /// - Parameters:
    ///   - isSynced: Defaults to `false` for manually created reminders.
    init(
        name: String,
        type: ReminderType = .birthday,
        day: Int,
        month: Int,
        year: Int? = nil,
        note: String? = nil,
        contactIdentifier: String? = nil,
        isSynced: Bool = false,
        getReminded: Bool = true
    ) {
        self.id = UUID()
        self.name = name
        self.type = type
        self.day = day
        self.month = month
        self.year = year
        self.note = note
        self.contactIdentifier = contactIdentifier
        self.isSynced = isSynced
        self.getReminded = getReminded
    }

    var daysUntilNext: Int {
        let calendar = Calendar.current
        let today = calendar.dateComponents([.month, .day], from: .now)
        let todayMonth = today.month!
        let todayDay = today.day!

        if month > todayMonth || (month == todayMonth && day >= todayDay) {
            return daysBetween(
                fromMonth: todayMonth,
                fromDay: todayDay,
                toMonth: month,
                toDay: day
            )
        } else {
            // Next year
            let daysToEndOfYear = daysBetween(
                fromMonth: todayMonth,
                fromDay: todayDay,
                toMonth: 12,
                toDay: 31
            )
            return daysToEndOfYear
            + daysBetween(
                fromMonth: 1,
                fromDay: 1,
                toMonth: month,
                toDay: day
            ) + 1
        }
    }
    
    var daysUntilNextLabel: String {
        let days = daysUntilNext
        switch days {
        case 0:        return "Today 🎉"
        case 1:        return "Tomorrow"
        default:       return "\(days) days"
        }
    }

    private func daysBetween(
        fromMonth: Int,
        fromDay: Int,
        toMonth: Int,
        toDay: Int
    ) -> Int {
        let calendar = Calendar.current
        let year = calendar.component(.year, from: .now)
        let from = calendar.date(
            from: DateComponents(year: year, month: fromMonth, day: fromDay)
        )!
        let to = calendar.date(
            from: DateComponents(year: year, month: toMonth, day: toDay)
        )!
        return calendar.dateComponents([.day], from: from, to: to).day!
    }
}
