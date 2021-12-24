//
//  AppListTableViewCell.swift
//  DualAccount
//
//  Created by Phung Anh Dung on 08/08/2021.
//

import UIKit

class AppListTableViewCell: UITableViewCell {

    @IBOutlet weak var imgSelected: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var imgIcon: CustomImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
//        imgSelected.image = selected ? UIImage(named: "ic_album_select") : UIImage(named: "ic_no_select")
        // Configure the view for the selected state
    }

    func config(data: DualAppObj) {
        imgIcon.image = UIImage(named: data.image)
        lblName.text = data.name
//        imgSelected.image = data.isSelected ? UIImage(named: "ic_album_select") : UIImage(named: "ic_no_select")
    }
    
}
