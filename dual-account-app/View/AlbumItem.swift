//
//  AlbumItem.swift
//  dual-account-app
//
//  Created by Huu Truong Nguyen on 11/23/21.
//

import UIKit
import Photos
import SDWebImage

class AlbumItem: UICollectionViewCell {
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var images: UIImageView!
    @IBOutlet weak var btnEdit: UIButton!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func config(_ obj: AlbumObj) {
        btnEdit.isHidden = obj.id == "-1"
        label.text = obj.name.count == 0 ? "No title" : obj.name
        if label.text == "All" {
            galleryManager.getOneItemByAllAlbum(obj.id) { (gallery, count) in
                //                self.lbCount.text = "\(count)"
                if gallery.isVideo {
                    let urlVideo = URL(fileURLWithPath: FilePaths.filePaths.path+gallery.fileName)
                    self.images.image = self.getThumbnailFrom(path: urlVideo)
                }else{
                    let urlImage = URL(fileURLWithPath: FilePaths.filePaths.path+gallery.fileName)
                    self.images.sd_setImage(with: urlImage)
                }
            }
        }else{
            galleryManager.getOneItemByIdAlbum(obj.id) { (gallery, count) in
                //                self.lbCount.text = "\(count)"
                if gallery.isVideo {
                    if gallery.fileName == "" {
                        self.images.image = UIImage.init(named: "ic_bg_album")
                    }else{
                        let urlVideo = URL(fileURLWithPath: FilePaths.filePaths.path+gallery.fileName)
                        self.images.image = self.getThumbnailFrom(path: urlVideo)
                    }
                }else{
                    if gallery.fileName == "" {
                        self.images.image = UIImage.init(named: "ic_bg_album")
                    }else{
                        let urlImage = URL(fileURLWithPath: FilePaths.filePaths.path+gallery.fileName)
                        self.images.sd_setImage(with: urlImage)
                    }
                }
            }
        }
    }

    func getThumbnailFrom(path: URL) -> UIImage? {
        do {
            let asset = AVURLAsset(url: path , options: nil)
            let imgGenerator = AVAssetImageGenerator(asset: asset)
            imgGenerator.appliesPreferredTrackTransform = true
            let cgImage = try imgGenerator.copyCGImage(at: CMTimeMake(value: 0, timescale: 1), actualTime: nil)
            let thumbnail = UIImage(cgImage: cgImage)
            return thumbnail
        } catch let error {
            print("*** Error generating thumbnail: \(error.localizedDescription)")
            return nil
        }
    }
}
