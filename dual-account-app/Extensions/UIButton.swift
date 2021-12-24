//
//  UIButton.swift
//  BaseProject
//
//  Created by user.name on 7/17/20.
//  Copyright © 2020 user.name. All rights reserved.
//

import UIKit

extension UIButton {
    func disable(_ isDisable: Bool) {
        isUserInteractionEnabled = !isDisable
        alpha = isDisable ? 0.5 : 1
    }
    
    func setAttributes(_ attributes: [(text: String, font: UIFont, color: UIColor)],
                       lineHeight: CGFloat = 0.0,
                       alignment: NSTextAlignment = .center,
                       lineSpace: CGFloat = 0.0,
                       lineBreakMode: NSLineBreakMode = .byTruncatingTail, controlState: UIControl.State = .normal) {
        guard !attributes.isEmpty else {
            return
        }
        titleLabel?.numberOfLines = 0
        let attributedStrings = NSMutableAttributedString(string: "")
        attributes.forEach { (text, font, color) in
            let attr = NSAttributedString(string: text, attributes: [.font: font, .foregroundColor: color])
            attributedStrings.append(attr)
        }
        let paragraphStyle = NSMutableParagraphStyle()
        
        let lineHeightMultiple = lineHeight / attributes[0].font.lineHeight
        
        paragraphStyle.lineHeightMultiple = lineHeightMultiple
        paragraphStyle.lineSpacing = lineSpace
        paragraphStyle.alignment = alignment
        paragraphStyle.lineBreakMode = lineBreakMode
        
        attributedStrings.addAttribute(.paragraphStyle,
                                       value: paragraphStyle,
                                       range: NSRange(location: 0, length: attributedStrings.length))
        setAttributedTitle(attributedStrings, for: controlState)
    }
    
    /// Setup style for your UIButton by parameters value
    ///
    /// - Parameters:
    ///   - title: String
    ///   - font: UIFont
    ///   - titleColor: UIColor
    ///   - imageBackground: UIImage
    ///   - controlState: UIControl.State
    func setup(title: String, font: UIFont, titleColor: UIColor, imageBackground: UIImage, controlState: UIControl.State = .normal) {
        setup(title: title, font: font, titleColor: titleColor, controlState: controlState)
        setBackgroundImage(imageBackground, for: controlState)
    }

    /// Setup style for your UIButton by parameters value
    ///
    /// - Parameters:
    ///   - title: String
    ///   - font: UIFont
    ///   - titleColor: UIColor
    ///   - backgroundColor: UIColor
    ///   - controlState: UIControl.State
    func setup(title: String, font: UIFont, titleColor: UIColor, backgroundColor: UIColor = .clear, controlState: UIControl.State = .normal) {
        titleLabel?.font = font
        setTitleColor(titleColor, for: controlState)
        setTitle(title, for: controlState)
        self.backgroundColor = backgroundColor
    }
    
    /// Setup style for your UIButton by parameters value
    ///
    /// - Parameters:
    ///   - title: String
    ///   - font: UIFont
    ///   - titleColor: UIColor
    ///   - imageBackgroundFromColor: UIColor
    ///   - controlState: UIControl.State
    func setup(title: String, font: UIFont, titleColor: UIColor, imageBackgroundFromColor: UIColor, controlState: UIControl.State = .normal) {
        setup(title: title, font: font, titleColor: titleColor, controlState: controlState)
    }

    func swapImage() {
        transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
        titleLabel?.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
        imageView?.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
    }

    func centerVertically(withPadding padding: CGFloat = 6.0) {
        guard let imageSize = imageView?.frame.size, let titleSize = titleLabel?.frame.size else {
            return
        }
        let totalHeight = imageSize.height + titleSize.height + padding
        imageEdgeInsets = UIEdgeInsets(top: -(totalHeight - imageSize.height),
                                       left: 0.0,
                                       bottom: 0.0,
                                       right: -titleSize.width)
        titleEdgeInsets = UIEdgeInsets(top: 0.0,
                                       left: -imageSize.width,
                                       bottom: -(totalHeight - titleSize.height),
                                       right: 0.0)
    }

    func border(width: CGFloat) {
        layer.borderWidth = width
        layer.borderColor = currentTitleColor.cgColor
    }
}

// MARK: - Properties
extension UIButton {

    /// Image of disabled state for button; also inspectable from Storyboard.
    @IBInspectable
    var imageForDisabled: UIImage? {
        get {
            return image(for: .disabled)
        }
        set {
            setImage(newValue, for: .disabled)
        }
    }

    /// Image of highlighted state for button; also inspectable from Storyboard.
    @IBInspectable
    var imageForHighlighted: UIImage? {
        get {
            return image(for: .highlighted)
        }
        set {
            setImage(newValue, for: .highlighted)
        }
    }

    /// Image of normal state for button; also inspectable from Storyboard.
    @IBInspectable
    var imageForNormal: UIImage? {
        get {
            return image(for: .normal)
        }
        set {
            setImage(newValue, for: .normal)
        }
    }

    /// Image of selected state for button; also inspectable from Storyboard.
    @IBInspectable
    var imageForSelected: UIImage? {
        get {
            return image(for: .selected)
        }
        set {
            setImage(newValue, for: .selected)
        }
    }

    /// Title color of disabled state for button; also inspectable from Storyboard.
    @IBInspectable
    var titleColorForDisabled: UIColor? {
        get {
            return titleColor(for: .disabled)
        }
        set {
            setTitleColor(newValue, for: .disabled)
        }
    }

    /// Title color of highlighted state for button; also inspectable from Storyboard.
    @IBInspectable
    var titleColorForHighlighted: UIColor? {
        get {
            return titleColor(for: .highlighted)
        }
        set {
            setTitleColor(newValue, for: .highlighted)
        }
    }

    /// Title color of normal state for button; also inspectable from Storyboard.
    @IBInspectable
    var titleColorForNormal: UIColor? {
        get {
            return titleColor(for: .normal)
        }
        set {
            setTitleColor(newValue, for: .normal)
        }
    }

    /// Title color of selected state for button; also inspectable from Storyboard.
    @IBInspectable
    var titleColorForSelected: UIColor? {
        get {
            return titleColor(for: .selected)
        }
        set {
            setTitleColor(newValue, for: .selected)
        }
    }

    /// Title of disabled state for button; also inspectable from Storyboard.
    @IBInspectable
    var titleForDisabled: String? {
        get {
            return title(for: .disabled)
        }
        set {
            setTitle(newValue, for: .disabled)
        }
    }

    /// Title of highlighted state for button; also inspectable from Storyboard.
    @IBInspectable
    var titleForHighlighted: String? {
        get {
            return title(for: .highlighted)
        }
        set {
            setTitle(newValue, for: .highlighted)
        }
    }

    /// Title of normal state for button; also inspectable from Storyboard.
    @IBInspectable
    var titleForNormal: String? {
        get {
            return title(for: .normal)
        }
        set {
            setTitle(newValue, for: .normal)
        }
    }

    /// Title of selected state for button; also inspectable from Storyboard.
    @IBInspectable
    var titleForSelected: String? {
        get {
            return title(for: .selected)
        }
        set {
            setTitle(newValue, for: .selected)
        }
    }

}

// MARK: - Methods
extension UIButton {

    private var states: [UIControl.State] {
        return [.normal, .selected, .highlighted, .disabled]
    }

    /// Set image for all states.
    ///
    /// - Parameter image: UIImage.
    func setImageForAllStates(_ image: UIImage) {
        states.forEach { setImage(image, for: $0) }
    }

    /// Set title color for all states.
    ///
    /// - Parameter color: UIColor.
    func setTitleColorForAllStates(_ color: UIColor) {
        states.forEach { setTitleColor(color, for: $0) }
    }

    /// Set title for all states.
    ///
    /// - Parameter title: title string.
    func setTitleForAllStates(_ title: String) {
        states.forEach { setTitle(title, for: $0) }
    }

    /// Center align title text and image
    /// - Parameters:
    ///   - imageAboveText: set true to make image above title text, default is false, image on left of text
    ///   - spacing: spacing between title text and image.
    func centerTextAndImage(imageAboveText: Bool = false, spacing: CGFloat) {
        if imageAboveText {
            // https://stackoverflow.com/questions/2451223/#7199529
            guard
                let imageSize = imageView?.image?.size,
                let text = titleLabel?.text,
                let font = titleLabel?.font
                else { return }

            let titleSize = text.size(withAttributes: [.font: font])

            let titleOffset = -(imageSize.height + spacing)
            titleEdgeInsets = UIEdgeInsets(top: 0.0, left: -imageSize.width, bottom: titleOffset, right: 0.0)

            let imageOffset = -(titleSize.height + spacing)
            imageEdgeInsets = UIEdgeInsets(top: imageOffset, left: 0.0, bottom: 0.0, right: -titleSize.width)

            let edgeOffset = abs(titleSize.height - imageSize.height) / 2.0
            contentEdgeInsets = UIEdgeInsets(top: edgeOffset, left: 0.0, bottom: edgeOffset, right: 0.0)
        } else {
            let insetAmount = spacing / 2
            imageEdgeInsets = UIEdgeInsets(top: 0, left: -insetAmount, bottom: 0, right: insetAmount)
            titleEdgeInsets = UIEdgeInsets(top: 0, left: insetAmount, bottom: 0, right: -insetAmount)
            contentEdgeInsets = UIEdgeInsets(top: 0, left: insetAmount, bottom: 0, right: insetAmount)
        }
    }

}
