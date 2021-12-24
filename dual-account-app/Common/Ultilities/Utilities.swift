//
//  Utilities.swift
//  BaseProject
//
//  Created by user.name on 7/17/20.
//  Copyright © 2020 user.name. All rights reserved.
//

import UIKit
import CoreLocation

func openSetting(completion: (() -> Void) = {}) {
    if let settingUrl = URL(string: UIApplication.openSettingsURLString) {
        if UIApplication.shared.canOpenURL(settingUrl) {
            UIApplication.shared.open(settingUrl)
            completion()
        }
    }
}

func openGoogleMaps(coordinate: CLLocationCoordinate2D) {
    let application = UIApplication.shared
    if let appURL = OpenMapType.app(coordinate).url, application.canOpenURL(appURL) {
        application.open(appURL)
    } else if let browserURL = OpenMapType.browser(coordinate).url {
        application.open(browserURL)
    }
}

func after(interval: TimeInterval, completion: (() -> Void)?) {
    DispatchQueue.main.asyncAfter(deadline: .now() + interval) {
        completion?()
    }
}
