//
//  UIImageView.swift
//  BaseProject
//
//  Created by user.name on 7/17/20.
//  Copyright © 2020 user.name. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift
//import Kingfisher

//extension UIImageView {
//
//    func loadImage(placeholderImage: UIImage?,
//                   anotherUrl: String?,
//                   withBackgroundImageColor color: UIColor = .lightGray) {
//        guard let urlString = anotherUrl, let url = URL(string: urlString) else {
//            return
//        }
//        kf.setImage(
//            with: url,
//            placeholder: placeholderImage,
//            options: [
//                .processor(DownsamplingImageProcessor(size: self.bounds.size)),
//                .scaleFactor(UIScreen.main.scale),
//                .transition(.fade(0.3)),
//                .cacheOriginalImage
//        ]) { result in
//            switch result {
//            case .success:
//                break
//            case .failure:
//                break
//            }
//        }
//    }
//}
let imageCache = NSCache<NSString, UIImage>()

class CustomImageView: UIImageView {
    var urlImageString: String?

    func loadImageUsingCache(withUrl urlPath : String) {
        urlImageString = urlPath
        let urlString = URL(string: urlPath)
        if urlString == nil {return}
        self.image = nil

        // check cached image
        if let cachedImage = imageCache.object(forKey: urlPath as NSString)  {
            self.image = cachedImage
            return
        }

        let activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView.init(style: .gray)
        addSubview(activityIndicator)
//        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
//        activityIndicator.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
//        activityIndicator.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
//        activityIndicator.width = 50
//        activityIndicator.height = 50
//        activityIndicator.startAnimating()
        activityIndicator.style = .gray
        // if not, download image from url

        URLSession.shared.dataTask(with: urlString!, completionHandler: { (data, response, error) in
            if error != nil {
                print(error!)
                return
            }
            DispatchQueue.main.async {
                if let imageToCache = UIImage(data: data!) {
                    if self.urlImageString == urlPath {
                        self.image = imageToCache
                        activityIndicator.stopAnimating()
                    }
                    imageCache.setObject(imageToCache, forKey: urlPath as NSString)
                }
            }
        }).resume()
    }
}
