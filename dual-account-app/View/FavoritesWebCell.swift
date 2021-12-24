//
//  FavoritesWebCell.swift
//  DualAccount
//
//  Created by Phung Anh Dung on 08/08/2021.
//

import UIKit

class FavoritesWebCell: UICollectionViewCell {

    @IBOutlet weak var webName: UILabel!
    @IBOutlet weak var imgWeb: CustomImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func config(data: FavoriteWeb) {
        imgWeb.loadImageUsingCache(withUrl: data.image)
        webName.text = data.name
    }
}
