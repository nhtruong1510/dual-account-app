//
//  Define.swift
//  BaseProject
//
//  Created by user.name on 7/17/20.
//  Copyright © 2020 user.name. All rights reserved.
//

import UIKit

let isIPad = DeviceType.IS_IPAD
let heightRatio = screenSize.height/812
let widthRatio = screenSize.width/375

let appid = "1588365894"
let mailSupport = "vutung.mayman20@gmail.com"

//Key admob ios 2
let admobBanner = "ca-app-pub-7204820750600293/5297372523"
let admobFull = "ca-app-pub-7204820750600293/5105800838"
let openAds = "ca-app-pub-7204820750600293/7540392487"
let adNativeAd = ""
var numberToShowAd = 6

class FilePaths {
    static let documentsPath : AnyObject = NSSearchPathForDirectoriesInDomains(.documentDirectory,.userDomainMask,true)[0] as AnyObject
    struct videoPaths {
        static var path = FilePaths.documentsPath.appending("/data/video/")
        func urlVideoFileName(_ fileName: String) -> URL {
            return URL(fileURLWithPath: FilePaths.videoPaths.path+fileName)
        }
    }
    struct imagePaths {
        static var path = FilePaths.documentsPath.appending("/data/image/")
        func urlImageFileName(_ fileName: String) -> URL {
            return URL(fileURLWithPath: FilePaths.imagePaths.path+fileName)
        }
    }

    struct filePaths {
        static var path = FilePaths.documentsPath.appending("/data/")
        func urlImageFileName(_ fileName: String) -> URL {
            return URL(fileURLWithPath: FilePaths.imagePaths.path+fileName)
        }
    }
}
