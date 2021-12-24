//
//  UITextView.swift
//  BaseProject
//
//  Created by user.name on 7/17/20.
//  Copyright © 2020 user.name. All rights reserved.
//

import UIKit

extension UITextView {
    func setup(font: UIFont, textColor: UIColor, backgroundColor: UIColor = .clear, text: String? = nil) {
        self.font = font
        self.textColor = textColor
        self.backgroundColor = backgroundColor
        self.text = text
    }

    func setup(font: UIFont, textColor: UIColor, alignment: NSTextAlignment, backgroundColor: UIColor = .clear, text: String? = nil) {
        self.setup(font: font, textColor: textColor, backgroundColor: backgroundColor, text: text)
        self.textAlignment = alignment
    }

    func setLineSpacing(lineHeight: CGFloat = 0.0,
                        alignment: NSTextAlignment = .left,
                        lineSpace: CGFloat = 0.0,
                        lineBreakMode: NSLineBreakMode = .byWordWrapping) {
        guard let labelText = text else { return }
        let paragraphStyle = NSMutableParagraphStyle()
        let lineHeightMultiple = lineHeight / (font?.lineHeight ?? 1)

        paragraphStyle.lineHeightMultiple = lineHeightMultiple
        paragraphStyle.lineSpacing = lineSpace
        paragraphStyle.lineBreakMode = lineBreakMode
        paragraphStyle.alignment = alignment

        let attributedString: NSMutableAttributedString
        if let labelattributedText = attributedText {
            attributedString = NSMutableAttributedString(attributedString: labelattributedText)
        } else {
            attributedString = NSMutableAttributedString(string: labelText)
        }

        attributedString.addAttribute(.paragraphStyle,
                                      value: paragraphStyle,
                                      range: NSRange(location: 0, length: attributedString.length))
        attributedText = attributedString
    }
    
    func constraintTextToEdges(_ amount: CGFloat) {
        let padding = amount - textContainer.lineFragmentPadding
        textContainerInset = UIEdgeInsets(top: padding, left: padding, bottom: padding, right: padding)
    }
}
