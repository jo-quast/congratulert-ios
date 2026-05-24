//
//  Item.swift
//  BirthdayReminder
//
//  Created by Jonathan Quast on 24.05.26.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
