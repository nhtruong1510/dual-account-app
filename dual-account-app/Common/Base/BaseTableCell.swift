//
//  BaseTableCell.swift
//  BaseProject
//
//  Created by user.name on 7/17/20.
//  Copyright © 2020 user.name. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class BaseTableCell: UITableViewCell {
    
    // MARK: - Properties
    let disposedBag = DisposeBag()
    var isEnableShrink = false
    
    // MARK: - Override
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
        setupData()
    }
    
    // MARK: - Public Functions
    public func setupUI() {}
    public func setupData() {}
    
    private func shrink(down: Bool) {
        guard isEnableShrink else { return }
        UIView.animate(withDuration: 0.1) {
            self.transform = down ? CGAffineTransform(scaleX: 0.95, y: 0.95) : .identity
        }
    }
    
    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        super.setHighlighted(highlighted, animated: animated)
        shrink(down: isHighlighted)
    }
}
