//
//  PassCodeVC.swift
//  PassCodeManager
//
//  Created by Anh Dũng on 11/2/19.
//  Copyright © 2019 Anh Dũng. All rights reserved.
//

import UIKit
import BiometricAuthentication

class PassCodeVC: UIViewController {
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet var PasscodeTf: [UITextField]!
    @IBOutlet var NumberButtons: [UIButton]!
    
    var strOldPasscode : String! = ""
    var strPasscode : String! = ""
    var strConfirmPasscode : String! = ""
    var checkPasscode : Bool! = false
    var typeView : NSInteger = 0
    
    @IBOutlet weak var btnTouchID: UIButton!
    @IBOutlet weak var btnCancel: UIButton!
    
//    class func instance() -> PassCodeVC {
//        let vc = PassCodeVC.init(nibName: isIPad ? "\(PassCodeVC.className)_iPad" : PassCodeVC.className, bundle: Bundle.main)
//        return vc
//    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.view.layoutIfNeeded()
        for button in NumberButtons {
            button.layer.cornerRadius = button.frame.size.width/2;
            button.layer.masksToBounds = true
            button.isExclusiveTouch = true
        }
        for textfield in PasscodeTf {
            textfield.isUserInteractionEnabled = false
            textfield.text = ""
            textfield.layer.borderColor = UIColor.black.cgColor

            textfield.layer.masksToBounds = true
            textfield.layer.cornerRadius = textfield.frame.size.width/2
            textfield.backgroundColor = UIColor(hex: "C4C4C4", alpha: 1)
        }
        
        btnCancel.isHidden = typeView == 1 ? false : true
        if typeView == 1 {
            self.lblTitle.text = "Enter your old Passcode"
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setRoot() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "NavigationController") as! UINavigationController
        vc.modalPresentationStyle = .fullScreen
        //self.navigationController?.pushViewController(vc, animated: true)
        self.present(vc, animated: true)
    }
    
    @IBAction func dismissView(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
//    @IBAction func clickTouchId(_ sender: Any) {
//
//        // start authentication
//        BioMetricAuthenticator.authenticateWithBioMetrics(reason: "") { (result) in
//            switch result {
//            case .success( _):
//                print("Authentication Successful")
//                TAppDelegate.initMenu()
//            case .failure(let error):
//                print("Authentication Failed")
//                // do nothing on canceled
//                if error == .canceledByUser || error == .canceledBySystem {
//                    return
//                }
//
//                    // device does not support biometric (face id or touch id) authentication
//                else if error == .biometryNotAvailable {
//                    self.showErrorAlert(message: error.message())
//                }
//
//                    // show alternatives on fallback button clicked
//                else if error == .fallback {
//
//                    // here we're entering username and password
//                }
//
//                    // No biometry enrolled in this device, ask user to register fingerprint or face
//                else if error == .biometryNotEnrolled {
//                    if #available(iOS 10.0, *) {
//                        self.showGotoSettingsAlert(message: error.message())
//                    } else {
//                        // Fallback on earlier versions
//                    }
//                }
//
//                    // Biometry is locked out now, because there were too many failed attempts.
//                    // Need to enter device passcode to unlock.
//                else if error == .biometryLockedout {
//                    self.showPasscodeAuthentication(message: error.message())
//                }
//
//                    // show error on authentication failed
//                else {
//                    self.showErrorAlert(message: error.message())
//                }
//            }
//
//        }
//    }
//
//    // show passcode authentication
//    func showPasscodeAuthentication(message: String) {
//        BioMetricAuthenticator.authenticateWithPasscode(reason: message) { (result) in
//            switch result {
//            case .success( _):
//                print("Authentication Successful")
//                TAppDelegate.initMenu()
//            case .failure(let error):
//                print("Authentication Failed")
//                print(error.message())
//            }
//        }
//    }
    
    @IBAction func clickBack(_ sender: Any) {
        if UserDefaults.standard.bool(forKey: "isPasscode") == false {
            if strPasscode.count == 6 {
                strConfirmPasscode = String(strConfirmPasscode.dropLast())
            } else {
                strPasscode = String(strPasscode.dropLast())
            }

            setTextfield()
        } else {
            if typeView == 0 {
                strPasscode = String(strPasscode.dropLast())
                setTextfieldWhenTurnOffPasscode()
            } else {
                if strOldPasscode.count < 6 {
                    strOldPasscode = String(strOldPasscode.dropLast())
                } else if strOldPasscode.count == 6 && strPasscode.count < 6 {
                    strPasscode = String(strPasscode.dropLast())
                } else {
                    strConfirmPasscode = String(strConfirmPasscode.dropLast())
                }
                setTextfieldWhenChangePasscode()
            }
        }
    }
    
    @IBAction func clickNumber(_ sender: Any) {
        let button = sender as! UIButton
        if UserDefaults.standard.bool(forKey: "isPasscode") == false {
            if strConfirmPasscode.count > 5 {
                return
            }
            if strPasscode.count == 6 {
                strConfirmPasscode = strConfirmPasscode + String(button.tag)
            } else {
                strPasscode = strPasscode + String(button.tag)
            }
            setTextfield()
        } else {
            if typeView == 1 {
                // - Change PassCode
                if strOldPasscode.count < 6 {
                    if strOldPasscode.count > 5 {
                        return
                    }
                    strOldPasscode = strOldPasscode + String(button.tag)
                } else if strOldPasscode.count == 6 && strPasscode.count < 6 {
                    if strPasscode.count > 5 {
                        return
                    }
                    strPasscode = strPasscode + String(button.tag)
                } else {
                    if strConfirmPasscode.count > 5 {
                        return
                    }
                    strConfirmPasscode = strConfirmPasscode + String(button.tag)
                }
                setTextfieldWhenChangePasscode()

            } else {
                if strPasscode.count > 5 {
                    return
                }
                strPasscode = strPasscode + String(button.tag)
                setTextfieldWhenTurnOffPasscode()
            }
        }
        
    }
    
    func setTextfield() {
        UIView.animate(withDuration: 0.2, animations: {
            if self.checkPasscode == false {
                for textfield in self.PasscodeTf {
                    if self.strPasscode.count > textfield.tag - 1 {
                        textfield.backgroundColor = .purple
                        textfield.layer.borderWidth = 0
                    } else {
                        textfield.backgroundColor = UIColor(hex: "C4C4C4", alpha: 1)

                    }
                }
            }
        }) { (isComplete) in
            if isComplete == true {
                if self.strPasscode.count == 6 {

                    self.checkPasscode = true
                    self.lblTitle.text = "Confirm Passcode"

                    UIView.animate(withDuration: 0.2, animations: {
                        for textfield in self.PasscodeTf {
                            if self.strConfirmPasscode.count > textfield.tag - 1 {
                                textfield.backgroundColor = .purple
                                textfield.layer.borderWidth = 0
                            } else {
                                textfield.backgroundColor = UIColor(hex: "C4C4C4", alpha: 1)

                            }
                        }
                    }, completion: { (isComplete) in
                        if self.strConfirmPasscode.count == 6 {
                            //                            sleep(1)
                            if self.strPasscode != self.strConfirmPasscode {
                                self.lblTitle.shake()
                                self.strConfirmPasscode = ""
                                for textfield in self.PasscodeTf {

                                    textfield.backgroundColor = UIColor(hex: "C4C4C4", alpha: 1)
                                }
                            } else {
                                UserDefaults.standard.set(true, forKey: "isPasscode")
                                UserDefaults.standard.set(self.strPasscode, forKey: "strPasscode")
                                UserDefaults.standard.synchronize()
                                if self.typeView == 0 {
                                    self.setRoot()
                                } else {
                                    self.setRoot()
                                }
                            }

                        }
                    })

                }
            }

        }
    }

    func setTextfieldWhenTurnOffPasscode() {
        UIView.animate(withDuration: 0.2, animations: {
            if self.checkPasscode == false {
                for textfield in self.PasscodeTf {
                    if self.strPasscode.count > textfield.tag - 1 {
                        textfield.backgroundColor = .purple
                        textfield.layer.borderWidth = 0
                    } else {
                        textfield.backgroundColor = UIColor(hex: "C4C4C4", alpha: 1)

                    }
                }
            }
        }) { (isComplete) in
            if isComplete == true {
                if self.strPasscode.count == 6 {
                    if (UserDefaults.standard.object(forKey: "strPasscode") == nil) {
                        return
                    }
                    let oldPasscode : String = UserDefaults.standard.object(forKey: "strPasscode") as! String

                    if self.strPasscode != oldPasscode {
                        self.lblTitle.shake()
                        self.strPasscode = ""
                        for textfield in self.PasscodeTf {
                            textfield.backgroundColor = UIColor(hex: "C4C4C4", alpha: 1)

                        }
                    } else {
                        self.setRoot()
                    }

                }
            }

        }
    }

    func setTextfieldWhenChangePasscode() {
        UIView.animate(withDuration: 0.2, animations: {
            if self.strOldPasscode.count < 6 {
                for textfield in self.PasscodeTf {
                    if self.strOldPasscode.count > textfield.tag - 1 {
                        textfield.backgroundColor = .purple
                        textfield.layer.borderWidth = 0
                    } else {
                        textfield.backgroundColor = UIColor(hex: "C4C4C4", alpha: 1)
                    }
                }
            }
        }) { (isComplete) in
            if isComplete == true {
                if self.strOldPasscode.count == 6 {
                    //                    sleep(1)
                    if (UserDefaults.standard.object(forKey: "strPasscode") == nil) {
                        return
                    }
                    let oldPasscode : String = UserDefaults.standard.object(forKey: "strPasscode") as! String

                    if self.strOldPasscode != oldPasscode {
                        self.lblTitle.shake()
                        self.strOldPasscode = ""
                        for textfield in self.PasscodeTf {
                            textfield.backgroundColor = UIColor(hex: "C4C4C4", alpha: 1)

                        }
                    } else {
                        if self.strPasscode.count < 6 {
                            self.lblTitle.text = "Enter new passcode"
                        }
                        self.setTextfield()
                    }

                }
            }
        }
    }
}

extension PassCodeVC {
    func showLoginSucessAlert() {
        self.showMessage("Login successful")
    }
    
    func showErrorAlert(message: String) {
        self.showMessage(message)
    }
    
    @available(iOS 10.0, *)
    func showGotoSettingsAlert(message: String) {
//        _ = self.present(style: .alert, title: message, message: nil, attributedActionTitles: [("OK", .default), ("Cancel", .cancel)], handler: { (action) in
//            if action.title == "OK" {
//                guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
//                    return
//                }
//                if UIApplication.shared.canOpenURL(settingsUrl) {
//                    if #available(iOS 10.0, *) {
//                        UIApplication.shared.open(settingsUrl, completionHandler: { (success) in
//                            print("Settings opened: \(success)") // Prints true
//                        })
//                    } else {
//                        // Fallback on earlier versions
//                    }
//                }
//            }
//        })
    }
}
