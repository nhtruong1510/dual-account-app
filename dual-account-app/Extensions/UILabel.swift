//
//  UILabel.swift
//  BaseProject
//
//  Created by user.name on 7/17/20.
//  Copyright © 2020 user.name. All rights reserved.
//

import Foundation
import UIKit

extension UILabel {
    /// Setup style for your UILabel with parameters value with text
    ///
    /// - Parameters:
    ///   - text: String?
    ///   - font: UIFont
    ///   - textColor: UIColor
    ///   - alignment: NSTextAlingment
    ///   - backgroundColor: UIColor
    func setup(text: String?, font: UIFont, textColor: UIColor, alignment: NSTextAlignment = .left, backgroundColor: UIColor = .clear) {
        self.font = font
        self.textColor = textColor
        self.backgroundColor = backgroundColor
        self.text = text
        self.textAlignment = alignment
    }
    
    /// Setup style for your UILabel with parameters value without text
    ///
    /// - Parameters:
    ///   - font: UIFont
    ///   - textColor: UIColor
    ///   - alignment: NSTextAlignment
    ///   - backgroundColor: UIColor
    func setup(_ font: UIFont, textColor: UIColor, alignment: NSTextAlignment = .left, backgroundColor: UIColor = .clear) {
        self.font = font
        self.textColor = textColor
        self.backgroundColor = backgroundColor
        self.textAlignment = alignment
    }
    
    func setLineSpacing(lineHeight: CGFloat = 0.0,
                        alignment: NSTextAlignment = .left,
                        lineSpace: CGFloat = 0.0,
                        lineBreakMode: NSLineBreakMode = .byWordWrapping) {
        guard let labelText = text else { return }
        let paragraphStyle = NSMutableParagraphStyle()
        
        let lineHeightMultiple = lineHeight / font.lineHeight
        
        paragraphStyle.lineHeightMultiple = lineHeightMultiple
        paragraphStyle.lineSpacing = lineSpace / 2
        paragraphStyle.alignment = alignment
        paragraphStyle.lineBreakMode = lineBreakMode
        
        let attributedString: NSMutableAttributedString = {
            if let labelattributedText = attributedText {
                return NSMutableAttributedString(attributedString: labelattributedText)
            }
            return NSMutableAttributedString(string: labelText)
        }()
        
        attributedString.addAttribute(.paragraphStyle,
                                      value: paragraphStyle,
                                      range: NSRange(location: 0, length: attributedString.length))
        attributedText = attributedString
    }
    
    /// Apply a hyperlink style for "link"
    ///
    /// - Parameters:
    ///   - link: text to make hyperlink style
    ///   - color: color for hyperlink style
    ///   - baselineOffset: space between text and the line
    func setHighlight(_ string: String, color: UIColor, font: UIFont) {
        let attributedString: NSMutableAttributedString = {
            if let labelattributedText = attributedText {
                return NSMutableAttributedString(attributedString: labelattributedText)
            }
            return NSMutableAttributedString(string: text ?? "")
        }()
        
        let range = (attributedString.string as NSString).range(of: string)
        attributedString.addAttributes([.foregroundColor: color,
                                        .font: font,
                                        .underlineStyle: NSUnderlineStyle.single.rawValue],
                                       range: range)
        attributedText = attributedString
    }
    
    func setHighlights(_ strings: [String],
                       color: UIColor,
                       font: UIFont) {
        let attributedString: NSMutableAttributedString = {
            if let labelattributedText = attributedText {
                return NSMutableAttributedString(attributedString: labelattributedText)
            }
            return NSMutableAttributedString(string: text ?? "")
        }()
        
        for string in strings {
            let range = (attributedString.string as NSString).range(of: string)
            attributedString.addAttributes([.foregroundColor: color,
                                            .font: font,
                                            .underlineStyle: NSUnderlineStyle.single.rawValue],
                                           range: range)
        }
       
        attributedText = attributedString
    }
    
    func setBaselineOffset(_ baselineOffset: CGFloat) {
        let attributedString: NSMutableAttributedString = {
            if let labelattributedText = attributedText {
                return NSMutableAttributedString(attributedString: labelattributedText)
            }
            return NSMutableAttributedString(string: text ?? "")
        }()
        
        attributedString.addAttributes([.baselineOffset: baselineOffset], range: NSRange(location: 0, length: attributedString.length))
        attributedText = attributedString
    }
    
    func setAttributes(_ attributes: [(text: String, font: UIFont, color: UIColor)],
                       lineHeight: CGFloat = 0.0,
                       alignment: NSTextAlignment = .left,
                       lineSpace: CGFloat = 0.0,
                       lineBreakMode: NSLineBreakMode = .byWordWrapping) {
        let attributedStrings: NSMutableAttributedString = {
            if let labelattributedText = attributedText {
                return NSMutableAttributedString(attributedString: labelattributedText)
            }
            return NSMutableAttributedString(string: text ?? "")
        }()
        attributes.forEach { (text, font, color) in
            let attr = NSAttributedString(string: text, attributes: [.font: font, .foregroundColor: color])
            attributedStrings.append(attr)
        }
        
        let paragraphStyle = NSMutableParagraphStyle()
        
        let lineHeightMultiple = lineHeight / font.lineHeight
        
        paragraphStyle.lineHeightMultiple = lineHeightMultiple
        paragraphStyle.lineSpacing = lineSpace
        paragraphStyle.alignment = alignment
        paragraphStyle.lineBreakMode = lineBreakMode

        attributedStrings.addAttribute(.paragraphStyle,
                                       value: paragraphStyle,
                                       range: NSRange(location: 0, length: attributedStrings.length))
        
        attributedText = attributedStrings
    }
    
    /// Create underline for current "text" by NSAttributedString
    func underline() {
        guard let textString = text else { return }
        let attributedString = NSMutableAttributedString(string: textString)
        attributedString.addAttribute(NSAttributedString.Key.underlineStyle, value: NSUnderlineStyle.single.rawValue,
                                      range: NSRange(location: 0, length: attributedString.length))
        attributedText = attributedString
    }

    func characterSpacing(_ spacing: CGFloat) {
        let attributedStrings: NSMutableAttributedString = {
            if let labelattributedText = attributedText {
                return NSMutableAttributedString(attributedString: labelattributedText)
            }
            return NSMutableAttributedString(string: text ?? "")
        }()
        attributedStrings.addAttribute(.kern, value: spacing, range: NSRange(location: 0, length: attributedStrings.length))
        attributedText = attributedStrings
    }
}

extension UILabel {

    func setLeftIcon(image: UIImage, tintColor: UIColor? = nil, with text: String) {
        let textShadow = NSShadow()
        textShadow.shadowBlurRadius = 2
        textShadow.shadowOffset = CGSize(width: 0, height: 0.6)
        textShadow.shadowColor = UIColor.gray.withAlphaComponent(0.7)
        let attachment = NSTextAttachment()
        if let tintColor = tintColor {
            attachment.image = image.tint(tintColor, blendMode: .copy)
        } else {
            attachment.image = image
        }

        let imagePoint = CGPoint(x: 0, y: -(image.size.height * 0.15))
        attachment.bounds = CGRect(origin: imagePoint, size: image.size)
        let attachmentStr = NSAttributedString(attachment: attachment)

        let mutableAttributedString = NSMutableAttributedString()
        mutableAttributedString.append(attachmentStr)
        let newText = String(format: "%@%@", " ", text)

        let textString = NSAttributedString(
            string: newText,
            // swiftlint:disable:next force_unwrapping
            attributes: [.font: self.font!, .shadow: textShadow])
        mutableAttributedString.append(textString)

        self.attributedText = mutableAttributedString
    }

    func setShadow(text: String, radius: CGFloat = 2, offset: CGSize = CGSize(width: 0, height: 0.2), color: UIColor = UIColor.gray.withAlphaComponent(0.5)) {
        let textShadow = NSShadow()
        textShadow.shadowBlurRadius = radius
        textShadow.shadowOffset = offset
        textShadow.shadowColor = color
        let strokeTextAttributes = [
            NSAttributedString.Key.shadow: textShadow]
            as [NSAttributedString.Key: Any]
        attributedText = NSMutableAttributedString(
            string: text,
            attributes: strokeTextAttributes)
    }
}

extension UILabel {
    @IBInspectable
    var isAutoResize: Bool {
        get {
            return self.isAutoResize
        }
        set {
            if newValue {
                self.font = self.font.autoResize()
            }
        }
    }
}

extension UIButton {
    @IBInspectable
    var isAutoResize: Bool {
        get {
            return self.isAutoResize
        }
        set {
            if newValue {
                self.titleLabel?.font = self.titleLabel?.font.autoResize()
            }
        }
    }
}

extension UIFont {
    func autoResize() -> UIFont {
        var sizeScale: CGFloat = 1
        if isIPad {
            sizeScale = 1.3
        }
        return UIFont(name: self.fontName, size: self.pointSize * sizeScale)!
    }
}
