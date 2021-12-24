//
//  CAGradientLayer.swift
//  BaseProject
//
//  Created by user.name on 7/17/20.
//  Copyright © 2020 user.name. All rights reserved.
//

import UIKit
extension CAGradientLayer {
    convenience init(frame: CGRect, colors: [UIColor], isHorizontal: Bool = true) {
        self.init()
        self.frame = frame
        self.colors = colors.map { $0.cgColor }
        if isHorizontal {
            startPoint = CGPoint(x: 0, y: 1)
            endPoint = CGPoint(x: 1, y: 1)
        }
    }
    
    func createGradientImage() -> UIImage? {
        var image: UIImage?
        UIGraphicsBeginImageContext(bounds.size)
        if let context = UIGraphicsGetCurrentContext() {
            render(in: context)
            image = UIGraphicsGetImageFromCurrentImageContext()
        }
        UIGraphicsEndImageContext()
        return image
    }
}
