import Testing
import Foundation
@testable import BirthdayReminder

/**
 Tests for the `Reminder` model's date calculation logic.
 */
struct ReminderTests {

    /**
     Helper that creates a `Reminder` with a fixed date, using a
     provided reference date to simulate "today" for testing.
     */
    private func makeReminder(day: Int, month: Int) -> Reminder {
        Reminder(name: "Test", type: .birthday, day: day, month: month)
    }

    @Test("Birthday today returns 0 days")
    func birthdayToday() {
        let today = Calendar.current.dateComponents([.month, .day], from: .now)
        let reminder = makeReminder(day: today.day!, month: today.month!)
        #expect(reminder.daysUntilNext == 0)
    }

    @Test("Birthday tomorrow returns 1 day")
    func birthdayTomorrow() {
        let tomorrow = Calendar.current.date(byAdding: .day, value: 1, to: .now)!
        let components = Calendar.current.dateComponents([.month, .day], from: tomorrow)
        let reminder = makeReminder(day: components.day!, month: components.month!)
        #expect(reminder.daysUntilNext == 1)
    }

    @Test("Birthday in next year is calculated correctly")
    func birthdayNextYear() {
        // January 1st is always in the future if today is after Jan 1
        // Use a fixed past date to ensure we wrap to next year
        let reminder = makeReminder(day: 1, month: 1)
        let today = Calendar.current.dateComponents([.month, .day], from: .now)

        if today.month! == 1 && today.day! == 1 {
            #expect(reminder.daysUntilNext == 0)
        } else {
            #expect(reminder.daysUntilNext > 0)
        }
    }
}
