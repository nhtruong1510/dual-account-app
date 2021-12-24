//
//  DualAppViewController.swift
//  dual-account-app
//
//  Created by Huu Truong Nguyen on 11/18/21.
//

import WebKit

class DualAppViewController: BaseViewController {
    @IBOutlet weak var webView: WKWebView!
    @IBOutlet weak var labelName: UILabel!

    var appObj = DualAppObj()
    @IBAction func back() {
        self.navigationController?.popViewController(animated: true)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
//        navigationController?.setNavigationBarHidden(false, animated: true)
//        configNavi(title: appObj.name,
//                   leftButton: .back,
//                   rightButton: .none,
//                   leftCompletion:  {
//                    self.navigationController?.popViewController(animated: true)
//                   })
        labelName.text = appObj.name
        print(appObj.url)
        if let myURLs = URL(string: appObj.url) {
            let myRequest = URLRequest(url: myURLs)
            webView.load(myRequest)
        }
    }
}
