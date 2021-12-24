//
//  PreviewViewController.swift
//  dual-account-app
//
//  Created by Huu Truong Nguyen on 11/24/21.
//

import UIKit
import Lightbox

class PreviewViewController: BaseViewController {
    @IBOutlet weak var viewImage: UIView!
    //@IBOutlet weak var lblInfo: UILabel!
    @IBOutlet weak var viewVideo: UIView!
    @IBOutlet weak var lblDuration: UILabel!
    @IBOutlet weak var imgPreview: UIImageView!
    @IBAction func back() {
        self.navigationController?.popViewController(animated: true)
    }
    let lightboxController = LightboxController(images: [])
    var albums = [GalleryObj]()
    var index = 0

    override func viewDidLoad() {
        super.viewDidLoad()
//        configNavi(title: "Preview",
//                   leftButton: .back,
//                   rightButton: .none,
//                   leftCompletion:  {
//                    self.navigationController?.popViewController(animated: true)
//                   })
        let obj = albums[index]

        if obj.isVideo {
            let urlVideo = URL(fileURLWithPath: FilePaths.filePaths.path+obj.fileName)
            self.imgPreview.image = GalleryManagerDic().getThumbnailFrom(path: urlVideo)
            self.lblDuration.text = obj.duration.formatDuration()
            viewImage.backgroundColor = .black
        }else{
            let urlImage = URL(fileURLWithPath: FilePaths.filePaths.path+obj.fileName)
            self.imgPreview.sd_setImage(with: urlImage)
            viewVideo.isHidden = true
            viewImage.backgroundColor = .white
        }
//        ReverseGeocoding.geocode(latitude: obj.lat, longitude: obj.long) { mark, adds, err in
//            self.lblInfo.text = adds?.isEmpty ?? true ? "None" : adds
//        }
    }

    @IBAction func actionPreview(_ sender: Any) {
        goToPreview(index)
    }

    @IBAction func acttionShared(_ sender: UIButton) {
        shareSelector(sender)
    }

    private func shareSelector(_ sender: UIButton) {
        var shareAll = [] as [Any]
        let obj = albums[index]
        let filePath = FilePaths.filePaths.path+obj.fileName
        let file = NSURL(fileURLWithPath: filePath)
        shareAll.append(file)
        let activityViewController = UIActivityViewController(activityItems: shareAll, applicationActivities: nil)
        if isIPad {
            if activityViewController.responds(to: #selector(getter: UIViewController.popoverPresentationController)) {
                activityViewController.popoverPresentationController?.sourceView = sender
            }
        }
        activityViewController.hidesBottomBarWhenPushed = true
        self.present(activityViewController, animated: true, completion: nil)
    }

    private func goToPreview(_ index: Int) {
        lightboxController.dynamicBackground = true
        lightboxController.modalPresentationStyle = .fullScreen
        let lightBox = albums.map { (obj) -> LightboxImage in
            if obj.isVideo {
                return LightboxImage(image: GalleryManagerDic().getThumbnailFrom(path: URL(fileURLWithPath: FilePaths.filePaths.path + obj.fileName))!,
                                     text: "Privew Video",
                                     videoURL: URL(fileURLWithPath: FilePaths.filePaths.path + obj.fileName))
            }else {
                return LightboxImage(image: UIImage(contentsOfFile: FilePaths.filePaths.path + obj.fileName)!)
            }
        }
        lightboxController.images = lightBox
        lightboxController.goTo(index)
        self.present(lightboxController, animated: true) {
        }
    }
}

extension UIImageView {
    func enableZoom() {
        let pinchGesture = UIPinchGestureRecognizer(target: self, action: #selector(startZooming(_:)))
        isUserInteractionEnabled = true
        addGestureRecognizer(pinchGesture)
    }

    @objc
    private func startZooming(_ sender: UIPinchGestureRecognizer) {
        let scaleResult = sender.view?.transform.scaledBy(x: sender.scale, y: sender.scale)
        guard let scale = scaleResult, scale.a > 1, scale.d > 1 else { return }
        sender.view?.transform = scale
        sender.scale = 1
    }
}

