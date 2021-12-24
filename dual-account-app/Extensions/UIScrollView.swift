//
//  UIScrollView.swift
//  Base Project
//
//  Created by user.name on 10/10/20.
//  Copyright © 2020 user.name. All rights reserved.
//

import UIKit

extension UIScrollView {

    var scrollIndicators: (horizontal: UIView?, vertical: UIView?) {

        guard self.subviews.count >= 2 else {
            return (horizontal: nil, vertical: nil)
        }

        func viewCanBeScrollIndicator(view: UIView) -> Bool {
            let viewClassName = NSStringFromClass(type(of: view))
            if viewClassName == "_UIScrollViewScrollIndicator" || viewClassName == "UIImageView" {
                return true
            }
            return false
        }

        let horizontalScrollViewIndicatorPosition = self.subviews.count - 2
        let verticalScrollViewIndicatorPosition = self.subviews.count - 1

        var horizontalScrollIndicator: UIView?
        var verticalScrollIndicator: UIView?

        let viewForHorizontalScrollViewIndicator = self.subviews[horizontalScrollViewIndicatorPosition]
        if viewCanBeScrollIndicator(view: viewForHorizontalScrollViewIndicator) {
            horizontalScrollIndicator = viewForHorizontalScrollViewIndicator.subviews[0]
        }

        let viewForVerticalScrollViewIndicator = self.subviews[verticalScrollViewIndicatorPosition]
        if viewCanBeScrollIndicator(view: viewForVerticalScrollViewIndicator) {
            verticalScrollIndicator = viewForVerticalScrollViewIndicator.subviews[0]
        }
        return (horizontal: horizontalScrollIndicator, vertical: verticalScrollIndicator)
    }

}

///Use it
// MARK: - CollectionView Delegate
//extension TopViewController: UICollectionViewDelegate {
//    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        DispatchQueue.main.async {
//            scrollView.scrollIndicators.vertical?.backgroundColor = UIColor.green
//        }
//    }
//}
