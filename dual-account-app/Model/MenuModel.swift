//
//  MenuModel.swift
//  dual-account-app
//
//  Created by Huu Truong Nguyen on 11/17/21.
//

import Foundation
import UIKit

struct MenuModel {
    var image: UIImage!
    var name: String = ""
}

class MenuData {
    static let shared: MenuData = MenuData()
    var menu = [
        MenuModel(image: #imageLiteral(resourceName: "home"), name: "Home"),
        MenuModel(image: #imageLiteral(resourceName: "private-browser"), name: "Private Browser"),
        MenuModel(image: #imageLiteral(resourceName: "note"), name: "Private Notes"),
        MenuModel(image: #imageLiteral(resourceName: "app-list"), name: "Album"),
        MenuModel(image: #imageLiteral(resourceName: "setting"), name: "Setting"),
        MenuModel(image: #imageLiteral(resourceName: "info"), name: "Info"),
    ]
}
