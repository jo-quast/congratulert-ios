import Foundation
import SwiftData

enum ReminderType: String, Codable, CaseIterable {
    case birthday
    case anniversary

    var label: String {
        switch self {
        case .birthday: return String(localized: "type_birthday")
        case .anniversary: return String(localized: "type_anniversary")
        }
    }

    var icon: String {
        switch self {
        case .birthday: return "🎂"
        case .anniversary: return "💍"
        }
    }
}

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

    init(
        name: String,
        type: ReminderType = .birthday,
        day: Int,
        month: Int,
        year: Int? = nil,
        note: String? = nil
    ) {
        self.id = UUID()
        self.name = name
        self.type = type
        self.day = day
        self.month = month
        self.year = year
        self.note = note
    }

    var daysUntilNextReminder: Int {
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
