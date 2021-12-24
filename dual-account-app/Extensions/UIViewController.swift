//
//  UIViewController.swift
//  BaseProject
//
//  Created by user.name on 7/17/20.
//  Copyright © 2020 user.name. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

typealias ActionHandler = (_ action: UIAlertAction) -> ()
typealias AttributedActionTitle = (title: String, style: UIAlertAction.Style)

extension UIViewController {
    var topBarHeight: CGFloat {
        if #available(iOS 13.0, *) {
            return (view.window?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0.0) +
                (self.navigationController?.navigationBar.frame.height ?? 0.0)
        } else {
            return UIApplication.shared.statusBarFrame.height +
                (self.navigationController?.navigationBar.frame.height ?? 0.0)
        }
    }
    
    var bottomBarHeight: CGFloat {
        UIApplication.shared.windows.first(where: { $0.isKeyWindow })?.safeAreaInsets.bottom ?? 0
    }
    
    func topMostViewController() -> UIViewController? {
        if let navigation = self as? UINavigationController {
            return navigation.visibleViewController?.topMostViewController()
        }
        
        if let tab = self as? UITabBarController {
            if let selectedTab = tab.selectedViewController {
                return selectedTab.topMostViewController()
            }
            return tab.topMostViewController()
        }
        
        if self.presentedViewController == nil {
            return self
        }
        if let navigation = self.presentedViewController as? UINavigationController {
            if let visibleController = navigation.visibleViewController {
                return visibleController.topMostViewController()
            }
        }
        if let tab = self.presentedViewController as? UITabBarController {
            if let selectedTab = tab.selectedViewController {
                return selectedTab.topMostViewController()
            }
            return tab.topMostViewController()
        }
        return self.presentedViewController?.topMostViewController()
    }
    
    private func forcePresentAlertVC(_ alertVC: UIAlertController) {
        if let presentedViewController = presentedViewController {
            if !presentedViewController.isKind(of: UIAlertController.self) {
                presentedViewController.present(alertVC, animated: true, completion: nil)
            }
        } else {
            present(alertVC, animated: true, completion: nil)
        }
    }
    
    func showAlert(title: String?, message: String?, actionTitle: String,  _ action: (() -> Void)? = nil) {
        let alertVC = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: actionTitle, style: .default) { _ in
            action?()
        }
        alertVC.addAction(action)
        forcePresentAlertVC(alertVC)
    }
    
    func present(title: String?, message: String?,  actionTitles: [String]?, handler: ActionHandler? = nil) {
        let alertVC = UIAlertController(title: title, message: message, preferredStyle: .alert)
        if let actionsTitles = actionTitles {
            for actionsTitle in actionsTitles {
                let buttonAction = UIAlertAction(title: actionsTitle, style: .default) { (action) in
                    handler?(action)
                }
                alertVC.addAction(buttonAction)
            }
        }
        
        forcePresentAlertVC(alertVC)
    }
    
    func showMessage(_ message: String?) {
        let alertView = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        forcePresentAlertVC(alertView)
    }
    
//    func showAlertViewController(_ alertViewController: BaseViewController, animated: Bool = true, completion: (() -> Void)? = nil) {
//        present(alertViewController, animated: animated, completion: completion)
//    }
    
    func showErrorAlert(_ error: Error?) {
        if let _ = error {
            return
        }
        showErrorLocalizedAlert(error)
    }
    
    func showErrorLocalizedAlert(_ error: Error?, action: (() -> Void)? = nil) {
        guard let message = error?.localizedDescription, !message.isEmpty else {
            action?()
            return
        }
        showErrorMessageAlert(message, action: action)
    }
    
    func showErrorMessageAlert(_ message: String? = nil, action: (() -> Void)? = nil) {
        showAlert(title: "", message: message, actionTitle: "Close")
    }
    
    func add(_ childController: UIViewController) {
        childController.willMove(toParent: self)
        addChild(childController)
        view.addSubview(childController.view)
        childController.didMove(toParent: self)
    }
    
    func removeBackButtonTitle() {
        if let topItem = navigationController?.navigationBar.topItem {
            topItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        }
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    }
    
    func presentAlert(_ alert: UIViewController, animated: Bool, completion: (() -> Void)?) {
        if let popoverController = alert.popoverPresentationController {
            popoverController.sourceView = self.view //to set the source of your alert
            popoverController.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0) // you can set this as per your requirement.
            popoverController.permittedArrowDirections = [] //to hide the arrow of any particular direction
        }
        present(alert, animated: animated, completion: completion)
    }
}

extension Reactive where Base: UIViewController {
    var isError: Binder<Error> {
        return Binder(base) { vc, error in
          vc.showErrorAlert(error)
        }
    }
}

extension UITabBarController {
    func setTabBarHidden(_ isHidden: Bool, animated: Bool, completion: (() -> Void)? = nil) {
        if tabBar.isHidden == isHidden {
            completion?()
        }

        if !isHidden {
            tabBar.isHidden = false
        }

        let height = tabBar.frame.size.height
        let offsetY = view.frame.height - (isHidden ? 0 : height)
        let duration = (animated ? 0.3 : 0.0)

        let frame = CGRect(origin: CGPoint(x: tabBar.frame.minX, y: offsetY), size: tabBar.frame.size)
        UIView.animate(withDuration: duration, animations: {
            self.tabBar.frame = frame
        }, completion: { _ in
                self.tabBar.isHidden = isHidden
                completion?()
            })
    }
}
