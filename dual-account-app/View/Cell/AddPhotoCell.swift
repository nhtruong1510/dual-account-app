//
//  ColorCell.swift
//  Base Project
//
//  Created by user.name on 10/10/20.
//  Copyright © 2020 user.name. All rights reserved.
//

import UIKit

class AddPhotoCell: BaseCollectionViewSelectionCell {
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var removeButton: UIButton!
    
    var handleRemove: (() -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        isEnableShrink = true
        
        removeButton.rx.tap
            .subscribe(onNext: { [unowned self] in
                handleRemove?()
            })
            .disposed(by: rx.disposeBag)
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
    }
    
    func bind(image: UIImage, allowEdit: Bool) {
        photoImageView.image = image
        removeButton.isHidden = !allowEdit
    }
}
