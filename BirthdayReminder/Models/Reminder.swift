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
    
    /// Returns a locale-aware formatted date string for this reminder.
    /// When a year is set, uses medium date style (e.g. "24. Juni 1990" in German, "Jun 24, 1990" in English).
    /// When no year is set, omits the year (e.g. "24. Juni", "Jun 24").
    /// - Parameter locale: The locale to use for formatting. Defaults to the device's current locale.
    func dateString(locale: Locale = .current) -> String {
        let formatter = DateFormatter()
        formatter.timeStyle = .none
        formatter.locale = locale
        
        var components = DateComponents()
        components.day = day
        components.month = month
        components.year = year ?? Calendar.current.component(.year, from: .now)
        
        guard let date = Calendar.current.date(from: components) else {
            return "\(day).\(month)"
        }
        
        if year != nil {
            formatter.dateFormat = DateFormatter.dateFormat(
                fromTemplate: "dMMMyyyy",
                options: 0,
                locale: locale
            )
        } else {
            formatter.dateFormat = DateFormatter.dateFormat(
                fromTemplate: "dMMM",
                options: 0,
                locale: locale
            )
        }
        
        return formatter.string(from: date)
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
