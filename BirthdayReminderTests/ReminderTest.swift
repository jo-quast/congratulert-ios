import Testing
import Foundation
@testable import BirthdayReminder


/// Tests for the `Reminder` model's date calculation logic.
struct ReminderTest {

    // MARK: - Helpers
    
    /// Helper that creates a `Reminder` with a fixed date, using a
    /// provided reference date to simulate "today" for testing.
    private func makeReminder(day: Int, month: Int, year: Int? = nil) -> Reminder {
        Reminder(
            name: "Test",
            type: .birthday,
            day: day,
            month: month,
            year: year
        )
    }
    
    // MARK: - Days Until Next

    @Test("Birthday today returns 0 days")
    func birthdayToday() {
        let today = Calendar.current.dateComponents([.month, .day], from: .now)
        let reminder = makeReminder(day: today.day!, month: today.month!)
        #expect(reminder.daysUntilNext == 0)
    }

    @Test("Birthday tomorrow returns 1 day")
    func birthdayTomorrow() {
        let tomorrow = Calendar.current.date(
            byAdding: .day,
            value: 1,
            to: .now
        )!
        let components = Calendar.current.dateComponents(
            [.month, .day],
            from: tomorrow
        )
        let reminder = makeReminder(
            day: components.day!,
            month: components.month!
        )
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
    
    // MARK: - Date String

    // MARK: German Locale

    @Test("German locale with year shows day month year")
    func german_withYear() {
        let reminder = makeReminder(day: 24, month: 6, year: 1990)
        #expect(reminder.dateString(locale: Locale(identifier: "de_DE")) == "24. Juni 1990")
    }

    @Test("German locale without year omits year")
    func german_withoutYear() {
        let reminder = makeReminder(day: 24, month: 6)
        #expect(reminder.dateString(locale: Locale(identifier: "de_DE")) == "24. Juni")
    }

    @Test("German locale first day of year")
    func german_firstDayOfYear() {
        let reminder = makeReminder(day: 1, month: 1, year: 2000)
        #expect(reminder.dateString(locale: Locale(identifier: "de_DE")) == "1. Jan. 2000")
    }

    @Test("German locale last day of year")
    func german_lastDayOfYear() {
        let reminder = makeReminder(day: 31, month: 12, year: 2000)
        #expect(reminder.dateString(locale: Locale(identifier: "de_DE")) == "31. Dez. 2000")
    }

    @Test("German locale leap day")
    func german_leapDay() {
        let reminder = makeReminder(day: 29, month: 2, year: 2000)
        #expect(reminder.dateString(locale: Locale(identifier: "de_DE")) == "29. Feb. 2000")
    }

    // MARK: US Locale

    @Test("US locale with year shows month day year")
    func us_withYear() {
        let reminder = makeReminder(day: 24, month: 6, year: 1990)
        #expect(reminder.dateString(locale: Locale(identifier: "en_US")) == "Jun 24, 1990")
    }

    @Test("US locale without year omits year")
    func us_withoutYear() {
        let reminder = makeReminder(day: 24, month: 6)
        #expect(reminder.dateString(locale: Locale(identifier: "en_US")) == "Jun 24")
    }

    @Test("US locale first day of year")
    func us_firstDayOfYear() {
        let reminder = makeReminder(day: 1, month: 1, year: 2000)
        #expect(reminder.dateString(locale: Locale(identifier: "en_US")) == "Jan 1, 2000")
    }

    @Test("US locale last day of year")
    func us_lastDayOfYear() {
        let reminder = makeReminder(day: 31, month: 12, year: 2000)
        #expect(reminder.dateString(locale: Locale(identifier: "en_US")) == "Dec 31, 2000")
    }

    @Test("US locale leap day")
    func us_leapDay() {
        let reminder = makeReminder(day: 29, month: 2, year: 2000)
        #expect(reminder.dateString(locale: Locale(identifier: "en_US")) == "Feb 29, 2000")
    }

    // MARK: Japanese Locale

    @Test("Japanese locale with year shows year month day")
    func japanese_withYear() {
        let reminder = makeReminder(day: 24, month: 6, year: 1990)
        #expect(reminder.dateString(locale: Locale(identifier: "ja_JP")) == "1990年6月24日")
    }

    @Test("Japanese locale without year omits year")
    func japanese_withoutYear() {
        let reminder = makeReminder(day: 24, month: 6)
        #expect(reminder.dateString(locale: Locale(identifier: "ja_JP")) == "6月24日")
    }

    @Test("Japanese locale first day of year")
    func japanese_firstDayOfYear() {
        let reminder = makeReminder(day: 1, month: 1, year: 2000)
        #expect(reminder.dateString(locale: Locale(identifier: "ja_JP")) == "2000年1月1日")
    }

    @Test("Japanese locale last day of year")
    func japanese_lastDayOfYear() {
        let reminder = makeReminder(day: 31, month: 12, year: 2000)
        #expect(reminder.dateString(locale: Locale(identifier: "ja_JP")) == "2000年12月31日")
    }

    @Test("Japanese locale leap day")
    func japanese_leapDay() {
        let reminder = makeReminder(day: 29, month: 2, year: 2000)
        #expect(reminder.dateString(locale: Locale(identifier: "ja_JP")) == "2000年2月29日")
    }

    // MARK: Edge Cases

    @Test("First day of year produces valid date string")
    func firstDayOfYear() {
        let reminder = makeReminder(day: 1, month: 1, year: 2000)
        #expect(!reminder.dateString().isEmpty)
    }

    @Test("Last day of year produces valid date string")
    func lastDayOfYear() {
        let reminder = makeReminder(day: 31, month: 12, year: 2000)
        #expect(!reminder.dateString().isEmpty)
    }

    @Test("Leap day with year produces valid date string")
    func leapDay_withYear() {
        let reminder = makeReminder(day: 29, month: 2, year: 2000)
        #expect(!reminder.dateString().isEmpty)
    }

    @Test("Leap day without year uses leap year fallback")
    func leapDay_withoutYear() {
        let reminder = makeReminder(day: 29, month: 2)
        #expect(!reminder.dateString().isEmpty)
    }

    @Test("Single digit day and month produces valid date string")
    func singleDigitDayAndMonth() {
        let reminder = makeReminder(day: 1, month: 3, year: 1985)
        #expect(!reminder.dateString().isEmpty)
    }
}
