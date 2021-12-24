//
//  BaseCollectionViewCell.swift
//  BaseProject
//
//  Created by user.name on 7/17/20.
//  Copyright © 2020 user.name. All rights reserved.
//

import UIKit

class BaseCollectionViewSelectionCell: UICollectionViewCell {
    
    var isEnableShrink = false
    
    override var isHighlighted: Bool {
        didSet {
            guard isEnableShrink else { return }
            shrink(down: isHighlighted)
        }
    }
    
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
        UIView.animate(withDuration: 0.1) {
            self.transform = down ? CGAffineTransform(scaleX: 0.95, y: 0.95) : .identity
        }
    }
}
