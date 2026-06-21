import Foundation
import SwiftUI

enum ReminderType: String, CaseIterable, Codable {
    case birthday
    case lunarBirthday
    case nameDay
    case relationshipAnniversary
    case weddingDay
    case friendshipAnniversary
    case deathDay
    case adoptionDay
    case jobAnnieversary
    case immigrationDay
    case holiday
    case other

    /// The display label shown in the UI.
    var label: String {
        switch self {
        case .birthday: return String(localized: "type_birthday")
        case .lunarBirthday: return String(localized: "type_lunar_birthday")
        case .nameDay: return String(localized:"type_name_day")
        case .relationshipAnniversary: return String(
            localized: "type_relationship_anniversary"
        )
        case .weddingDay: return String(localized: "type_wedding_day")
        case .friendshipAnniversary: return String(
            localized: "type_friend_anniversary"
        )
        case .deathDay: return String(localized: "type_death_day")
        case .adoptionDay: return String(localized: "type_adoption_day")
        case .jobAnnieversary: return String(localized: "type_job_anniversary")
        case .immigrationDay: return String(localized: "type_immigration_day")
        case .holiday: return String(localized: "type_holiday")
        case .other: return String(localized: "type_other")
        }
    }
    
    var icon: String {
        switch self {
        case .birthday: return "🎂"
        case .lunarBirthday: return "🌝"
        case .nameDay: return "😇"
        case .relationshipAnniversary: return "❤️"
        case .weddingDay: return "💍"
        case .friendshipAnniversary: return "🩷"
        case .deathDay: return "🕊️"
        case .adoptionDay: return "🏠"
        case .jobAnnieversary: return "💼"
        case .immigrationDay: return "🌍"
        case .holiday: return "🌷"
        case .other: return "💌"
        }
    }
    
    var color: Color {
        switch self {
        case .birthday:
            return Color(
                red: 1.00,
                green: 0.76,
                blue: 0.03
            ) // Amber
        case .lunarBirthday:
            return Color(
                red: 0.29,
                green: 0.18,
                blue: 0.65
            ) // Deep Indigo
        case .nameDay:
            return Color(
                red: 0.20,
                green: 0.60,
                blue: 0.86
            ) // Sky Blue
        case .relationshipAnniversary:
            return Color(
                red: 0.91,
                green: 0.25,
                blue: 0.35
            ) // Rose Red
        case .weddingDay:
            return Color(
                red: 0.94,
                green: 0.80,
                blue: 0.29
            ) // Champagne Gold
        case .friendshipAnniversary:
            return Color(
                red: 0.95,
                green: 0.45,
                blue: 0.67
            ) // Hot Pink
        case .deathDay:
            return Color(
                red: 0.40,
                green: 0.51,
                blue: 0.56
            ) // Slate Grey
        case .adoptionDay:
            return Color(
                red: 0.24,
                green: 0.67,
                blue: 0.47
            ) // Emerald
        case .jobAnnieversary:
            return Color(
                red: 0.18,
                green: 0.38,
                blue: 0.62
            ) // Navy
        case .immigrationDay:
            return Color(
                red: 0.13,
                green: 0.59,
                blue: 0.53
            ) // Teal
        case .holiday:
            return Color(
                red: 0.30,
                green: 0.69,
                blue: 0.31
            ) // Leaf Green
        case .other:
            return Color(
                red: 0.58,
                green: 0.44,
                blue: 0.86
            ) // Soft Purple
        }
    }
    
    func getDefaultReminderName(for contactName: String) -> String {
        switch self {
        case .birthday: return String(localized: "\(contactName)'s Birthday")
        case .lunarBirthday: return String(
            localized:"\(contactName)'s Lunar Birthday"
        )
        case .nameDay: return String(localized:"\(contactName)'s Nameday")
        case .relationshipAnniversary: return String(
            localized:"Anniversary with \(contactName)"
        )
        case .weddingDay: return "💍"
        case .friendshipAnniversary: return "🩷"
        case .deathDay: return "🕊️"
        case .adoptionDay: return "🏠"
        case .jobAnnieversary: return "💼"
        case .immigrationDay: return "🌍"
        case .holiday: return "🌷"
        case .other: return "💌"
        }
    }
}
