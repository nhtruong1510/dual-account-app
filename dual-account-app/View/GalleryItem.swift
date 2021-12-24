//
//  GalleryItem.swift
//  DualAccount
//
//  Created by Phung Anh Dung on 29/08/2021.
//

import UIKit
import SDWebImage
import AVKit

class GalleryItem: UICollectionViewCell {

    @IBOutlet weak var lblVideoInfo: UILabel!
    @IBOutlet weak var viewSelected: UIView!
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var iconSelect: UIImageView!

    var handleSelect: ((Bool) -> Void)?

    var isMultiSelected = false {
        didSet {
            viewSelected.isHidden = isMultiSelected
        }
    }

    var isSelecteds = false {
        didSet {
            iconSelect.image = isSelecteds ? #imageLiteral(resourceName: "tick (1)") : #imageLiteral(resourceName: "tick")
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func config(_ obj: GalleryObj, isMultiSelect: Bool) {

        isMultiSelected = !isMultiSelect
        lblVideoInfo.isHidden = !obj.isVideo
        isSelecteds = obj.isSelected

        if obj.isVideo {
            let urlVideo = URL(fileURLWithPath: FilePaths.filePaths.path+obj.fileName)
            self.image.image = getThumbnailFrom(path: urlVideo)
            lblVideoInfo.text = obj.duration.formatDuration()
        }else{
            let urlImage = URL(fileURLWithPath: FilePaths.filePaths.path+obj.fileName)
            self.image.sd_setImage(with: urlImage)
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

    @IBAction func actionTap(_ sender: Any) {
        handleSelect?(isSelecteds)
    }
}

extension Double {
    func formatDuration() -> String {
        let formatter = DateComponentsFormatter()
        formatter.zeroFormattingBehavior = .pad
        if self >= 3600 {
            formatter.allowedUnits = [.hour, .minute, .second]
        } else {
            formatter.allowedUnits = [.minute, .second]
        }
        return formatter.string(from: self) ?? ""
    }
}
