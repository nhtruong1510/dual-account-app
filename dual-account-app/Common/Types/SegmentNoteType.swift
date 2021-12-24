//
//  SegmentNoteType.swift
//  DualAccount
//
//  Created by user.name on 25/07/2021.
//

import Foundation

enum SegmentNoteType {
    case background
    case reminder
    case addPhoto
    
    var title: String {
        switch self {
        case .background:
            return "Background"
        case .reminder:
            return "Reminder"
        case .addPhoto:
            return "Add Photo"
        }
    }
}
