//
//  UIFont.swift
//  BaseProject
//
//  Created by user.name on 7/30/20.
//  Copyright © 2020 user.name. All rights reserved.
//

import UIKit

enum Roboto_Weight {
    case regular
    case medium
    case bold
    
    var name: String {
        switch self {
        case .regular:
            return "Roboto-Regular"
        case .medium:
            return "Roboto-Medium"
        case .bold:
            return "Roboto-Bold"
        }
    }
}

extension UIFont {
//    static func roboto(weight: Roboto_Weight, size: CGFloat) -> UIFont {
//        // swiftlint:disable:next force_unwrapping
//        let font = UIFont(name: weight.name, size: size)!
//        return Common.getFontForDeviceWithFontDefault(fontDefault: font)
//    }
}
