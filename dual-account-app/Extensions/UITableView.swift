//
//  UITableView.swift
//  BaseProject
//
//  Created by user.name on 7/17/20.
//  Copyright © 2020 user.name. All rights reserved.
//

import UIKit
import RxCocoa

extension UITableViewCell {
    var tableView: UITableView? {
        return parentView(of: UITableView.self)
    }
}

extension UITableView {
//    var isEmpty: Binder<Bool> {
//        return Binder(self) { tableView, isEmpty in
//            if isEmpty {
//                let frame = CGRect(x: 0,
//                                   y: 0,
//                                   width: tableView.frame.size.width,
//                                   height: tableView.frame.size.height)
//                let emptyView = EmptyDataView(frame: frame)
//                tableView.backgroundView = emptyView
//            } else {
//                tableView.backgroundView = nil
//            }
//        }
//    }
    
    func register<T: UITableViewCell>(_ aClass: T.Type) {
        let name = String(describing: aClass)
        let bundle = Bundle.main
        if bundle.path(forResource: name, ofType: "nib") != nil {
            let nib = UINib(nibName: name, bundle: bundle)
            register(nib, forCellReuseIdentifier: name)
        } else {
            register(aClass, forCellReuseIdentifier: name)
        }
    }
    
    func register<T: UITableViewHeaderFooterView>(_ aClass: T.Type) {
        let name = aClass.className
        let bundle = Bundle.main
        if bundle.path(forResource: name, ofType: "nib") != nil {
            let nib = UINib(nibName: name, bundle: bundle)
            register(nib, forHeaderFooterViewReuseIdentifier: name)
        } else {
            register(aClass, forHeaderFooterViewReuseIdentifier: name)
        }
    }
    
    func dequeue<T: UITableViewCell>(_ aClass: T.Type) -> T {
        let name = String(describing: aClass)
        guard let cell = dequeueReusableCell(withIdentifier: name) as? T else {
            fatalError("`\(name)` is not registed")
        }
        return cell
    }
    
    func dequeue<T: UITableViewHeaderFooterView>(_ aClass: T.Type) -> T {
        let name = aClass.className
        guard let cell = dequeueReusableHeaderFooterView(withIdentifier: name) as? T else {
            fatalError("`\(name)` is not registed")
        }
        return cell
    }
    
    func cellAtIndexPath<T: UITableViewCell>(_ type: T.Type, indexPath: IndexPath) -> T? {
        return cellForRow(at: indexPath) as? T
    }
    
    func setSeparetorZero(_ cell: UITableViewCell) {
        if responds(to: #selector(setter: UITableViewCell.separatorInset)) {
            separatorInset = UIEdgeInsets.zero
        }
        
        if responds(to: #selector(setter: UIView.layoutMargins)) {
            layoutMargins = UIEdgeInsets.zero
        }
        
        if cell.responds(to: #selector(setter: UIView.layoutMargins)) {
            cell.layoutMargins = UIEdgeInsets.zero
        }
    }
    
    func reloadData(completion: (() -> Void)? = nil) {
        reloadData()
        guard let comp = completion else { return }
        DispatchQueue.main.async(execute: { comp() })
    }
    
    func isLastCell(at indexPath: IndexPath) -> Bool {
        return indexPath.row == (numberOfRows(inSection: indexPath.section) - 1)
    }
    
    func isLastSectionAndLastRow(at indexPath: IndexPath) -> Bool {
        return indexPath.section == (numberOfSections - 1) && isLastCell(at: indexPath)
    }
    
    func lastIndexPath() -> IndexPath? {
        for index in (0 ..< numberOfSections).reversed() {
            if numberOfRows(inSection: index) > 0 {
                return IndexPath(row: numberOfRows(inSection: index) - 1, section: index)
            }
        }
        return nil
    }
    
    func reloadTableView(type: ReloadTableViewType) {
        let transition = CATransition()
        transition.type = CATransitionType.push
        transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        transition.fillMode = CAMediaTimingFillMode.forwards
        transition.duration = 0.5
        transition.subtype = type == .push ? .fromRight : .fromLeft
        self.layer.add(transition, forKey: "UITableViewReloadDataAnimationKey")
        // Update your data source here
        self.reloadData()
    }
    
    func scroll(to: ScrollDirection, animated: Bool) {
        let numberOfSections = self.numberOfSections
        
        guard numberOfSections > 0 else { return }
        
        let numberOfRows = self.numberOfRows(inSection: numberOfSections - 1)
        switch to {
        case .top:
            if numberOfRows > 0 {
                let indexPath = IndexPath(row: 0, section: 0)
                self.scrollToRow(at: indexPath, at: .top, animated: animated)
            }
        case .bottom:
            if numberOfRows > 0 {
                let indexPath = IndexPath(row: numberOfRows - 1, section: (numberOfSections - 1))
                self.scrollToRow(at: indexPath, at: .bottom, animated: animated)
            }
        }
    }
    
    enum ScrollDirection {
        case top
        case bottom
    }
    
    var contentHeight: CGFloat {
        self.layoutIfNeeded()

        return self.contentSize.height
    }
}

enum ReloadTableViewType {
    case push
    case pop
}
