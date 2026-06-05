//
//  BirthdayWidgetBundle.swift
//  BirthdayWidget
//
//  Created by Jonathan Quast on 24.05.26.
//

import WidgetKit
import SwiftUI

@main
struct BirthdayWidgetBundle: WidgetBundle {
    var body: some Widget {
        BirthdayWidget()
        BirthdayWidgetLiveActivity()
    }
}
