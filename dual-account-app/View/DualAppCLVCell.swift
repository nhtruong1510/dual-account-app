//
//  DualAppCLVCell.swift
//  dual-account-app
//
//  Created by Huu Truong Nguyen on 11/18/21.
//

import UIKit

class DualAppCLVCell: UICollectionViewCell {
    @IBOutlet weak var labelName: UILabel!
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var view: UIView!
    @IBOutlet weak var editButton: UIButton!
    var handleEdited: (() -> Void)?

    override func awakeFromNib() {
        super.awakeFromNib()
        view.layer.cornerRadius = 5
        view.layer.borderWidth = 0.5
        view.layer.borderColor = #colorLiteral(red: 0.54668957, green: 0.2059954703, blue: 0.5747321844, alpha: 1)
        // Initialization code
    }
    
    func config(app: DualAppObj) {
        imgView.image = UIImage(named: app.image)?.resizeImage(targetSize: CGSize(width: self.frame.width/2, height: self.frame.width/2))
        labelName.text = app.userName
    }
    
    @IBAction func editAction() {
        handleEdited?()
    }
}
