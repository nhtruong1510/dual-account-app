//
//  UIColor.swift
//  BaseProject
//
//  Created by user.name on 7/17/20.
//  Copyright © 2020 user.name. All rights reserved.
//

import UIKit

extension UIColor {
    
    static var hex_12518E: UIColor {
        UIColor(hex: "12518E")
    }
    
    static var hex_0076E9: UIColor {
        UIColor(hex: "0076E9")
    }
    
    static var hex_858585: UIColor {
        UIColor(hex: "858585")
    }
    
    static var hex_E2F1FF: UIColor {
        UIColor(hex: "E2F1FF")
    }
    
    static var hex_FEE600: UIColor {
        UIColor(hex: "FEE600")
    }
    
    static var hex_C4C4C4: UIColor {
        UIColor(hex: "C4C4C4")
    }
    
    static var redCustom: UIColor {
        UIColor(hex: "F02121")
    }
    
    static var cerulean: UIColor {
        UIColor(hex: "D8F6F8")
    }
    
    
    static func rgb(red: Int, green: Int, blue: Int, alpha: CGFloat = 1.0) -> UIColor {
        let denominator: CGFloat = 255.0
        let color = UIColor(red: CGFloat(red) / denominator,
                            green: CGFloat(green) / denominator,
                            blue: CGFloat(blue) / denominator,
                            alpha: alpha)
        return color
    }
    
    convenience init(hex: String, alpha: CGFloat = 1.0) {
        var hexFormatted: String = hex.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).uppercased()

        if hexFormatted.hasPrefix("#") {
            hexFormatted = String(hexFormatted.dropFirst())
        }

        assert(hexFormatted.count == 6, "Invalid hex code used.")

        var rgbValue: UInt64 = 0
        Scanner(string: hexFormatted).scanHexInt64(&rgbValue)

        self.init(red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
                  green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
                  blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
                  alpha: alpha)
    }
    
    var hexString: String {
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0
        
        getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        
        let rgb: Int = (Int)(red * 255) << 16 | (Int)(green * 255) << 8 | (Int)(blue * 255) << 0
        
        return String(format: "#%06x", rgb)
    }
}
