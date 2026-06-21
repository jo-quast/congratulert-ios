import Foundation

extension Reminder {
    static let sampleData: [Reminder] = [
        Reminder(
            name: "Mum's Birthday",
            type: .birthday,
            day: 24,
            month: 6,
            year: 1960
        ),
        Reminder(
            name: "Tom & Sarah's Anniversary",
            type: .relationshipAnniversary,
            day: 14,
            month: 2,
            year: 2019
        ),
        Reminder(
            name: "Grandpa Joe died",
            type: .deathDay,
            day: 3,
            month: 11
        ),
        Reminder(
            name: "Meeting Alex",
            type: .friendshipAnniversary,
            day: 1,
            month: 9,
            year: 2015,
            note: "Met at uni orientation"
        ),
        Reminder(
            name: "Work Start @Apple",
            type: .jobAnnieversary,
            day: 15,
            month: 3,
            year: 2021
        ),
        Reminder(
            name: "Luna's Adoption Day",
            type: .adoptionDay,
            day: 8,
            month: 8
        )
    ]
}
