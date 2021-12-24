//
//  ContentSettingVC.swift
//  dual-account-app
//
//  Created by Huu Truong Nguyen on 11/25/21.
//

import UIKit

class ContentSettingVC: UIViewController {
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var lbName: UILabel!
    var content = ""
    var name = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        lbName.text = name
        textView.text = content
        // Do any additional setup after loading the view.
    }

    @IBAction func backAction() {
        navigationController?.popViewController(animated: true)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

