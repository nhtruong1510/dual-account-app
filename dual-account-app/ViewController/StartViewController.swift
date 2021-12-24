//
//  StartViewController.swift
//  dual-account-app
//
//  Created by Huu Truong Nguyen on 11/15/21.
//

import UIKit

class StartViewController: UIViewController {
    @IBOutlet weak var startView: UIView!
    
    @IBAction func startAction() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "NavigationController") as! UINavigationController
        vc.modalPresentationStyle = .fullScreen
        //self.navigationController?.pushViewController(vc, animated: true)
        self.present(vc, animated: true)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        startView.layer.cornerRadius = 15
        // Do any additional setup after loading the view.
    }


}

