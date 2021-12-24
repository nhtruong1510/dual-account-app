//
//  Double + Float.swift
//  BaseProject
//
//  Created by user.name on 7/17/20.
//  Copyright © 2020 user.name. All rights reserved.
//

import UIKit

extension Double {
    /// Rounds the double to decimal places value
    func rounded(toPlaces places: Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
    
    var toString: String {
        return "\(self)"
    }
}

extension Float {
    // Rounds the double to decimal places value
    func rounded(toPlaces places: Int) -> Float {
        let divisor = pow(10.0, Float(places))
        return (self * divisor).rounded() / divisor
    }
}

extension CGFloat {
    
}

extension Int {
    var toString: String {
        return "\(self)"
    }
    
    func secondsToMinutesSeconds() -> (String, String) {
        let m = (self % 3600) / 60
        let s = (self % 3600) % 60
        return (m > 9 ? "\(m)" : "0\(m)", s > 9 ? "\(s)" : "0\(s)")
    }
    
    func secondsToHoursMinutesSeconds() -> (String, String, String) {
        let h = self / 3600
        let m = (self % 3600) / 60
        let s = (self % 3600) % 60
        return ("\(h)", m > 9 ? "\(m)" : "0\(m)", s > 9 ? "\(s)" : "0\(s)")
    }
}
