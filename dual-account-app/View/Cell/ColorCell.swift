//
//  ColorCell.swift
//  Base Project
//
//  Created by user.name on 10/10/20.
//  Copyright © 2020 user.name. All rights reserved.
//

import UIKit

class ColorCell: BaseCollectionViewSelectionCell {
    @IBOutlet private weak var noneImageView: UIImageView!
    @IBOutlet private weak var colorView: UIView!
    @IBOutlet private weak var colorRoundSelectedView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        isEnableShrink = true
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
    }
    
    func bind(type: ColorType, selectedType: ColorType) {
        colorRoundSelectedView.isHidden = true
        
        noneImageView.do {
            $0.image = #imageLiteral(resourceName: "ic_none")
            $0.isHidden = type != .none
            $0.tintColor = type == selectedType ? .hex_FEE600 : .hex_C4C4C4
        }
        
        colorView.do {
            $0.isHidden = type == .none
            $0.backgroundColor = type.color
        }

        colorRoundSelectedView.do {
            $0.isHidden = type == .none || type != selectedType
        }
        
        DispatchQueue.main.async {
            self.colorRoundSelectedView.circle()
            self.colorView.circle()
        }
    }
}
