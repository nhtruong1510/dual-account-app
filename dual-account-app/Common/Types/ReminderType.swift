//
//  ReminderType.swift
//  DualAccount
//
//  Created by user.name on 25/07/2021.
//

import Foundation

enum ReminderType: CaseIterable {
    case time
    case hour
    case `repeat`
    
    var title: String {
        switch self {
        case .time:
            return "Time"
        case .hour:
            return "Hours"
        case .`repeat`:
            return "Repeat"
        }
    }
}
