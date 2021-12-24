//
//  RepeatType.swift
//  DualAccount
//
//  Created by user.name on 26/07/2021.
//

import Foundation
import UIKit

enum RepeatType: String, CaseIterable, Codable {
    case never = ""
    case justOneTime = "Never"
    case always = "Always"
    case weekly = "Weekly"
    case monthly = "Monthly"
    
    var icon: UIImage? {
        switch self {
        case .never:
            return nil
        case .justOneTime:
            return #imageLiteral(resourceName: "notification")
        case .always:
            return #imageLiteral(resourceName: "notification")
        case .weekly:
            return #imageLiteral(resourceName: "notification")
        case .monthly:
            return #imageLiteral(resourceName: "notification")
        }
    }
}
