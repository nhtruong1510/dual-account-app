//
//  OpenMapType.swift
//  BaseProject
//
//  Created by user.name on 7/17/20.
//  Copyright © 2020 user.name. All rights reserved.
//

import CoreLocation

enum OpenMapType {
    case app(CLLocationCoordinate2D)
    case browser(CLLocationCoordinate2D)
    var url: URL? {
        switch self {
        case .app(let coordinate):
            let latitude = String(coordinate.latitude)
            let longitude = String(coordinate.longitude)
            let urlFormat = String(format: "%@%@%@%@%@",
                                   "comgooglemaps://?q=",
                                   latitude, ",",
                                   longitude,
                                   "&x-success=sourceapp://?resume=true&x-source=AirApp")
            return URL(string: urlFormat)
        case .browser(let coordinate):
            let latitude = String(coordinate.latitude)
            let longitude = String(coordinate.longitude)
            let urlFormat = String(format: "%@%@%@%@",
                                   "https://www.google.com/maps?q=",
                                   latitude, ",",
                                   longitude)
            return URL(string: urlFormat)
        }
    }
}
