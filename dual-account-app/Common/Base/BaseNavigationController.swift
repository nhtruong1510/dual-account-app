//
//  BaseNavigationController.swift
//  BaseProject
//
//  Created by user.name on 7/17/20.
//  Copyright © 2020 user.name. All rights reserved.
//

import UIKit

class BaseNavigationController: UINavigationController, UIGestureRecognizerDelegate {
    
    // MARK: - Override
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
    }
}

// MARK: - Private Functions
extension BaseNavigationController {
    
    private func setupNavigationBar() {
        let attribute = [NSAttributedString.Key.foregroundColor: UIColor.hex_12518E,] //NSAttributedString.Key.font: UIFont.roboto(weight: .medium, size: 18)]
        navigationBar.do {
            $0.isTranslucent = true
            $0.titleTextAttributes = attribute
            $0.shadowImage = UIImage()
            $0.setBackgroundImage(UIImage(), for: .default)
        }
        delegate = self
        interactivePopGestureRecognizer?.delegate = self
    }
    
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        super.pushViewController(viewController, animated: true)
        viewController.removeBackButtonTitle()
    }
}

// MARK: - Navigation delegate
extension BaseNavigationController: UINavigationControllerDelegate {
    func navigationController(_ navigationController: UINavigationController,
                              didShow viewController: UIViewController, animated: Bool) {
        if viewControllers.count > 1 {
            interactivePopGestureRecognizer?.isEnabled = true
        } else {
            interactivePopGestureRecognizer?.isEnabled = false
        }
    }
}
