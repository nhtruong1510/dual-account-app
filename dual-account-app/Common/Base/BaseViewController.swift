//
//  BaseViewController.swift
//  BaseProject
//
//  Created by user.name on 7/17/20.
//  Copyright © 2020 user.name. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift
import PanModal

class BaseViewController: UIViewController {

    // MARK: - Public Properties
    private var titleNavigation: String = "" {
        didSet {
            navigationItem.title = titleNavigation
        }
    }
    
    // MARK: - Public Properties
//    enum LeftButtonNavi {
//        case back
//        case menu
//        case close
//
//        var icon: UIImage? {
//            switch self {
//            case .back:
//                return #imageLiteral(resourceName: "ic_back")
//            case .menu:
//                return #imageLiteral(resourceName: "ic_menu")
//            case .close:
//                return #imageLiteral(resourceName: "ic_close")
//            }
//        }
//    }
//
//    enum RightButtonNavi {
//        case trash
//        case checkMark
//
//        var icon: UIImage? {
//            switch self {
//            case .trash:
//                return #imageLiteral(resourceName: "ic_trash")
//            case .checkMark:
//                return #imageLiteral(resourceName: "ic_check_mark")
//            }
//        }
//    }

    // MARK: - Override
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .default // default: black, lightContent: white
    }
    
    override var prefersStatusBarHidden: Bool {
        return false
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        defaultStyle()
        setupUI()
        bindRxOutlets()
        setupData()
    }

    // MARK: - Public Functions
    internal func setupUI() {}
    
    internal func bindRxOutlets() {}
    
    internal func setupData() {}
    
    func presentPanModalBase(vc: PanModalPresentable.LayoutType) {
        if isIPad {
            self.presentPanModal(vc, sourceView: self.view, sourceRect: CGRect(x: 0,
                                                                               y: self.view.bounds.midY,
                                                                               width: 0,
                                                                               height: 0))
        } else {
            self.presentPanModal(vc)
        }
    }
    
    deinit {
        debugPrint("\(String(describing: type(of: self))) \(#function)")
        NotificationCenter.default.removeObserver(self)
    }

    func showPopover(ofViewController popoverViewController: UIViewController, originView: UIView) {
        popoverViewController.modalPresentationStyle = UIModalPresentationStyle.popover
        if let popoverController = popoverViewController.popoverPresentationController {
            popoverController.delegate = self
            popoverController.sourceView = originView
            popoverController.sourceRect = originView.bounds
            popoverController.permittedArrowDirections = UIPopoverArrowDirection.any
        }
        self.present(popoverViewController, animated: true)
    }
}

extension BaseViewController: UIPopoverPresentationControllerDelegate {
    func adaptivePresentationStyle(for controller: UIPresentationController, traitCollection: UITraitCollection) -> UIModalPresentationStyle{
        return .popover
    }
}

// MARK: - Private Functions
extension BaseViewController {
    private func defaultStyle() {
        
    }
    
    func createBarButtonItem(isLeft: Bool,
                                     _ icon: UIImage?,
                                     _ titleNavi: String?,
                                     completion: (() -> Void)? = nil) -> UIBarButtonItem {
        let button = UIButton().with {
            $0.imageView?.contentMode = .scaleAspectFit
            $0.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
            $0.contentHorizontalAlignment = isLeft ? .leading : .trailing
            $0.setImage(icon, for: .normal)
            $0.setTitle(titleNavi, for: .normal)
            $0.setTitleColor(.red, for: .normal)
            $0.tintColor = .black
            $0.rx.tap
                .subscribe(onNext: {
                    completion?()
                })
                .disposed(by: rx.disposeBag)
        }
        return UIBarButtonItem(customView: button)
    }
}

// MARK: - Public Functions
//extension BaseViewController {
//    func configNavi(title: String,
//                    leftButton: LeftButtonNavi? = .none,
//                    rightButton: RightButtonNavi? = .none,
//                    leftCompletion: (() -> Void)? = nil,
//                    rightCompletion: (() -> Void)? = nil) {
//
//        titleNavigation = title
//        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor(hex: "643CA5", alpha: 1)]//, NSAttributedString.Key.font: UIFont.roboto(weight: .medium, size: 18)]
//        let spaceButton = UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
//        if leftButton.isNotNil {
//            navigationItem.backBarButtonItem = UIBarButtonItem(title: nil,
//                                                               style: .plain,
//                                                               target: nil,
//                                                               action: nil)
//            
//            let leftBarButton = createBarButtonItem(isLeft: true, leftButton?.icon, nil, completion: leftCompletion)
//            navigationItem.leftBarButtonItems = [spaceButton, leftBarButton]
//        } else {
//            navigationItem.leftBarButtonItem = nil
//            navigationItem.setHidesBackButton(true, animated: true)
//        }
//        
//        if rightButton.isNotNil {
//            navigationItem.rightBarButtonItem = UIBarButtonItem(title: nil,
//                                                                style: .plain,
//                                                                target: nil,
//                                                                action: nil)
//            let rightBarButton = createBarButtonItem(isLeft: false, rightButton?.icon, nil, completion: rightCompletion)
//            navigationItem.rightBarButtonItems = rightButton.isNil ? nil : [spaceButton, rightBarButton]
//        } else {
//            navigationItem.rightBarButtonItem = nil
//        }
//    }
//    
//}
