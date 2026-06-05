import Foundation
import SwiftData

@Model
final class Birthday {
    var name: String
    var date: Date
    var notes: String
    
    init(name: String, date: Date, notes: String = "") {
        self.name = name
        self.date = date
        self.notes = notes
    }
}
