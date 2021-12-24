//
//  UIView.swift
//  BaseProject
//
//  Created by user.name on 7/17/20.
//  Copyright © 2020 user.name. All rights reserved.
//

import UIKit

extension UIView {
    class func nib() -> UINib {
        return UINib(nibName: String(describing: self), bundle: nil)
    }
    
    class func loadNib<T: UIView>() -> T {
        let name = String(describing: self)
        let bundle = Bundle(for: T.self)
        guard let xib = bundle.loadNibNamed(name, owner: nil, options: nil)?.first as? T else {
            fatalError("Cannot load nib named `\(name)`")
        }
        return xib
    }
    
    @IBInspectable
    var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue*heightRatio
            layer.masksToBounds = newValue > 0
        }
    }
    
    func border(color: UIColor, width: CGFloat) {
        layer.borderColor = color.cgColor
        layer.borderWidth = width
        layer.cornerRadius = cornerRadius
        layer.masksToBounds = true
    }
    
    func shadowView(color: UIColor = .black,
                    alpha: Float = 0.25,
                    x: CGFloat = 0,
                    y: CGFloat = 3,
                    blur: CGFloat = 8) {
        layer.shadowColor = color.cgColor
        layer.shadowOffset = CGSize(width: x, height: y)
        layer.shadowOpacity = alpha
        layer.shadowRadius = blur
        layer.masksToBounds = false
    }
    
    func circle() {
        layoutIfNeeded()
        layer.cornerRadius = min(bounds.width, bounds.height) / 2
        layer.masksToBounds = true
    }
    
    func parentView<T: UIView>(of type: T.Type) -> T? {
        guard let view = superview else {
            return nil
        }
        return (view as? T) ?? view.parentView(of: T.self)
    }
    
    func roundLeft(with radius: CGFloat, borderWidth: CGFloat = 0, borderColor: UIColor = .clear) {
        layer.cornerRadius = radius
        layer.borderWidth = borderWidth
        layer.borderColor = borderColor.cgColor
        layer.maskedCorners = [.layerMinXMinYCorner]
        layer.masksToBounds = true
    }
    
    func roundRight(with radius: CGFloat, borderWidth: CGFloat = 0, borderColor: UIColor = .clear) {
        layer.cornerRadius = radius
        layer.borderWidth = borderWidth
        layer.borderColor = borderColor.cgColor
        layer.maskedCorners = [.layerMaxXMinYCorner]
        layer.masksToBounds = true
    }
    
    func roundTopEdges(with radius: CGFloat, borderWidth: CGFloat = 0, borderColor: UIColor = .clear) {
        layer.cornerRadius = radius
        layer.borderWidth = borderWidth
        layer.borderColor = borderColor.cgColor
        layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        layer.masksToBounds = true
    }
    
    func roundCorners(_ corners: UIRectCorner,
                      radius: CGFloat,
                      borderColor: UIColor = .clear,
                      borderWidth: CGFloat = 2,
                      shadowColor: UIColor = .black) {
        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        layer.mask = mask
        
        let borderLayer = CAShapeLayer()
        borderLayer.name = "corner"
        borderLayer.path = path.cgPath
        borderLayer.lineWidth = borderWidth
        borderLayer.strokeColor = borderColor.cgColor
        borderLayer.fillColor = UIColor.clear.cgColor
        borderLayer.frame = mask.bounds
        layer.addSublayer(borderLayer)
    }
    
    func mask(withRect rect: CGRect, inverse: Bool = false) {
        let path = UIBezierPath(rect: rect)
        let maskLayer = CAShapeLayer()
        
        if inverse {
            path.append(UIBezierPath(rect: self.bounds))
            maskLayer.fillRule = CAShapeLayerFillRule.evenOdd
            path.usesEvenOddFillRule = true
        }
        
        maskLayer.path = path.cgPath
        
        layer.mask = maskLayer
    }
    
    func mask(withPath path: UIBezierPath, inverse: Bool = false) {
        let path = path
        let maskLayer = CAShapeLayer()
        
        if inverse {
            path.append(UIBezierPath(rect: self.bounds))
            maskLayer.fillRule = CAShapeLayerFillRule.evenOdd
        }
        
        maskLayer.path = path.cgPath
        
        layer.mask = maskLayer
    }
    
    func setGradient(colors: [UIColor], isHorizontal: Bool = true) {
        let gradientLayer = CAGradientLayer(frame: bounds, colors: colors, isHorizontal: isHorizontal)
        layer.insertSublayer(gradientLayer, at: 0)
    }
    
    func constrainCentered(_ subview: UIView) {
        subview.translatesAutoresizingMaskIntoConstraints = false
        let verticalContraint = NSLayoutConstraint(
            item: subview,
            attribute: .centerY,
            relatedBy: .equal,
            toItem: self,
            attribute: .centerY,
            multiplier: 1.0,
            constant: 0)
        
        let horizontalContraint = NSLayoutConstraint(
            item: subview,
            attribute: .centerX,
            relatedBy: .equal,
            toItem: self,
            attribute: .centerX,
            multiplier: 1.0,
            constant: 0)
        
        let heightContraint = NSLayoutConstraint(
            item: subview,
            attribute: .height,
            relatedBy: .equal,
            toItem: nil,
            attribute: .notAnAttribute,
            multiplier: 1.0,
            constant: subview.frame.height)
        
        let widthContraint = NSLayoutConstraint(
            item: subview,
            attribute: .width,
            relatedBy: .equal,
            toItem: nil,
            attribute: .notAnAttribute,
            multiplier: 1.0,
            constant: subview.frame.width)
        
        addConstraints([
            horizontalContraint,
            verticalContraint,
            heightContraint,
            widthContraint])
        
    }
    
    func constrainToEdges(_ subview: UIView) {
        subview.translatesAutoresizingMaskIntoConstraints = false
        let topContraint = NSLayoutConstraint(
            item: subview,
            attribute: .top,
            relatedBy: .equal,
            toItem: self,
            attribute: .top,
            multiplier: 1.0,
            constant: 0)
        
        let bottomConstraint = NSLayoutConstraint(
            item: subview,
            attribute: .bottom,
            relatedBy: .equal,
            toItem: self,
            attribute: .bottom,
            multiplier: 1.0,
            constant: 0)
        
        let leadingContraint = NSLayoutConstraint(
            item: subview,
            attribute: .leading,
            relatedBy: .equal,
            toItem: self,
            attribute: .leading,
            multiplier: 1.0,
            constant: 0)
        
        let trailingContraint = NSLayoutConstraint(
            item: subview,
            attribute: .trailing,
            relatedBy: .equal,
            toItem: self,
            attribute: .trailing,
            multiplier: 1.0,
            constant: 0)
        
        addConstraints([
            topContraint,
            bottomConstraint,
            leadingContraint,
            trailingContraint])
    }
    
    func animateIn() {
        self.alpha = 0
        self.isHidden = false
        UIView.animate(withDuration: 0.3) {
            self.alpha = 1
        }
    }
    
    func animateOut() {
        UIView.animate(withDuration: 0.3, animations: {
            self.alpha = 0
        }) { (finished) in
            self.isHidden = finished
        }
    }
    
    func gradient(firstColor: UIColor, secondColor: UIColor, startPoint: CGPoint, endPoint: CGPoint) {
        let gradientLayer = CAGradientLayer().then {
            layoutIfNeeded()
            $0.frame = bounds
            $0.colors = [firstColor.cgColor, secondColor.cgColor]
            $0.locations = [0.0, 1.0]
            $0.startPoint = startPoint
            $0.endPoint = endPoint
            $0.name = "gradient"
        }
        
        if let oldGradientLayer = layer.sublayers?[0],
           oldGradientLayer.name == "gradient" {
            layer.replaceSublayer(oldGradientLayer, with: gradientLayer)
        } else {
            layer.insertSublayer(gradientLayer, at: 0)
        }
    }
    
    
    func borderGradient(colors: [UIColor],
                        lineWidth: CGFloat,
                        startPoint: CGPoint,
                        endPoint: CGPoint,
                        cornerRadius: CGFloat = 0) {
        let shape = CAShapeLayer().then {
            $0.lineWidth = lineWidth
            $0.path = UIBezierPath(roundedRect: bounds, cornerRadius: cornerRadius).cgPath
            $0.strokeColor = UIColor.black.cgColor
            $0.fillColor = UIColor.clear.cgColor
        }
        
        let gradientLayer = CAGradientLayer().then {
            $0.frame =  CGRect(origin: CGPoint.zero, size: frame.size)
            $0.colors = colors.map { $0.cgColor }
            $0.locations = [0.0, 1.0]
            $0.startPoint = startPoint
            $0.endPoint = endPoint
            $0.name = "gradient"
            $0.mask = shape
        }
        
        if let oldGradientLayer = layer.sublayers?[0],
           oldGradientLayer.name == "gradient" {
            layer.replaceSublayer(oldGradientLayer, with: gradientLayer)
        } else {
            layer.insertSublayer(gradientLayer, at: 0)
        }
    }

    func shake() {
        let animation = CAKeyframeAnimation(keyPath: "transform.translation.x")
        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.linear)
        animation.duration = 0.6
        animation.values = [-20.0, 20.0, -20.0, 20.0, -10.0, 10.0, -5.0, 5.0, 0.0 ]
        layer.add(animation, forKey: "shake")
    }
}

extension UIView {

    /// Border color of view; also inspectable from Storyboard.
    @IBInspectable var viewBorderColor: UIColor? {
        get {
            guard let color = layer.borderColor else { return nil }
            return UIColor(cgColor: color)
        }
        set {
            guard let color = newValue else {
                layer.borderColor = nil
                return
            }
            // Fix React-Native conflict issue
            guard String(describing: type(of: color)) != "__NSCFType" else { return }
            layer.borderColor = color.cgColor
        }
    }

    /// Border width of view; also inspectable from Storyboard.
    @IBInspectable var viewBorderWidth: CGFloat {
        get {
            return layer.borderWidth
        }
        set {
            layer.borderWidth = newValue
        }
    }

    /// Height of view.
    var height: CGFloat {
        get {
            return frame.size.height
        }
        set {
            frame.size.height = newValue
        }
    }

    /// Check if view is in RTL format.
    var isRightToLeft: Bool {
        if #available(tvOS 10.0, *) {
            return effectiveUserInterfaceLayoutDirection == .rightToLeft
        } else {
            return false
        }
    }

    /// Take screenshot of view (if applicable).
    var screenshot: UIImage? {
        UIGraphicsBeginImageContextWithOptions(layer.frame.size, false, 0)
        defer {
            UIGraphicsEndImageContext()
        }
        guard let context = UIGraphicsGetCurrentContext() else { return nil }
        layer.render(in: context)
        return UIGraphicsGetImageFromCurrentImageContext()
    }

    /// Shadow color of view; also inspectable from Storyboard.
    @IBInspectable var shadowColor: UIColor? {
        get {
            guard let color = layer.shadowColor else { return nil }
            return UIColor(cgColor: color)
        }
        set {
            layer.shadowColor = newValue?.cgColor
        }
    }

    /// Shadow offset of view; also inspectable from Storyboard.
    @IBInspectable var shadowOffset: CGSize {
        get {
            return layer.shadowOffset
        }
        set {
            layer.shadowOffset = newValue
        }
    }

    /// Shadow opacity of view; also inspectable from Storyboard.
    @IBInspectable var shadowOpacity: Float {
        get {
            return layer.shadowOpacity
        }
        set {
            layer.shadowOpacity = newValue
        }
    }

    /// Shadow radius of view; also inspectable from Storyboard.
    @IBInspectable var shadowRadius: CGFloat {
        get {
            return layer.shadowRadius
        }
        set {
            layer.shadowRadius = newValue
        }
    }

    /// Size of view.
    var size: CGSize {
        get {
            return frame.size
        }
        set {
            width = newValue.width
            height = newValue.height
        }
    }

    /// Get view's parent view controller
    var parentViewController: UIViewController? {
        weak var parentResponder: UIResponder? = self
        while parentResponder != nil {
            // swiftlint:disable:next force_unwrapping
            parentResponder = parentResponder!.next
            if let viewController = parentResponder as? UIViewController {
                return viewController
            }
        }
        return nil
    }

    /// Width of view.
    var width: CGFloat {
        get {
            return frame.size.width
        }
        set {
            frame.size.width = newValue
        }
    }

    /// x origin of view.
    var x: CGFloat {
        get {
            return frame.origin.x
        }
        set {
            frame.origin.x = newValue
        }
    }

    /// y origin of view.
    var y: CGFloat {
        get {
            return frame.origin.y
        }
        set {
            frame.origin.y = newValue
        }
    }
}
