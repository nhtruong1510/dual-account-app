//
//  UITextField.swift
//  BaseProject
//
//  Created by user.name on 7/17/20.
//  Copyright © 2020 user.name. All rights reserved.
//

import UIKit

extension UITextField {
    func setup(font: UIFont, textColor: UIColor, textAlignment: NSTextAlignment = .left, backgroundColor: UIColor = .clear) {
        self.font = font
        self.textColor = textColor
        self.textAlignment = textAlignment
        self.backgroundColor = backgroundColor
    }

    func setColorPlaceholder(text: String, color: UIColor) {
        self.attributedPlaceholder = NSAttributedString(string: text,
                                                        attributes: [NSAttributedString.Key.foregroundColor: color])
    }

    func isWhiteSpaceOrEmpty() -> Bool {
        return text?.isWhiteSpaceOrEmpty ?? false
    }
    
    func setPadding(_ amount: CGFloat) {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: frame.size.height))
        self.leftView = paddingView
        self.leftViewMode = .always
        self.rightView = paddingView
        self.rightViewMode = .always
    }
}
