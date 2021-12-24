//
//  Constant.swift
//  BaseProject
//
//  Created by user.name on 7/17/20.
//  Copyright © 2020 user.name. All rights reserved.
//

import Foundation
import CoreLocation
import UIKit

struct Constants {
    enum Strings {
        static let languageCode = (NSLocale.current.languageCode ?? "en").lowercased()
        static let appName = ""
        static let linkApp = "https://apps.apple.com/app/id" + appid
    }
    
}

extension Notification.Name {
    static let hideTabBar = Notification.Name("hideTabBar")
    static let reloadMasterDataNote = Notification.Name("reloadMasterDataNote")
    static let showTabBar = Notification.Name("showTabBar")
}

enum UserDefaultKeyConstants {
    static let noteDisplayTypeSelected = "noteDisplayTypeSelected"
    static let noteSortType = "noteSortType"
}
