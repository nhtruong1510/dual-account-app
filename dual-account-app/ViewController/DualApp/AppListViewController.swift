//
//  AppListViewController.swift
//  dual-account-app
//
//  Created by Huu Truong Nguyen on 11/18/21.
//

import UIKit

class AppListViewController: BaseViewController {

    @IBOutlet weak var tfSeach: UITextField!
    @IBOutlet weak var tableView: UITableView!

    @IBAction func createDual() {
        self.createDualApp()
    }
    
    @IBAction func back() {
        self.navigationController?.popViewController(animated: true)
    }
    
    private var arrayData = [DualAppObj]()
    private var arrayDataFilter = [DualAppObj]()
    private var indexSelected = -1

    override func viewDidLoad() {
        super.viewDidLoad()
 //       navigationController?.setNavigationBarHidden(false, animated: true)
//        configNavi(title: "App List", leftButton: .back, rightButton: .checkMark) {
//            self.navigationController?.popViewController(animated: true)
//        } rightCompletion: {
//            self.createDualApp()
//        }
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(AppListTableViewCell.self)
        initData()
    }

    func initData() {
        arrayData = initDataLocal()
        seach()
    }

    func createDualApp() {
        indexSelected = tableView.indexPathForSelectedRow?.row ?? -1
        if indexSelected < 0 {
            self.showAlert(title: "Dual App", message: "Please select app", actionTitle: "OK") {
                
            }
            return
        }
        let data = self.arrayDataFilter[indexSelected]
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "PopUpViewController") as! PopUpViewController
        vc.editWidgetType = .edit(title: "Edit Account", value: data.userName)
        vc.placeholder = "Username"
        vc.handleSave = { [weak self] name in
            data.userName = name
            data.saveData(true)
            self?.navigationController?.popViewController(animated: true)
            self?.reloadData()
        }
        vc.modalTransitionStyle = .crossDissolve
        vc.modalPresentationStyle = .overCurrentContext
        self.present(vc, animated: true)
    }
}

extension AppListViewController {

    private func initDataLocal() -> [DualAppObj] {
        if let bundlePath = Bundle.main.path(forResource: "dualalldefault", ofType: "json") {
            do {
                guard let jsonData = try String(contentsOfFile: bundlePath).data(using: .utf8) else {
                    return []
                }
                let decoder = JSONDecoder()
                let newModel = try decoder.decode(DualAppResponse.self, from: jsonData)
                let arrayData = newModel.login?.compactMap({ dt in
                    return DualAppObj(dt)
                }) ?? []
                return arrayData.filter({ app in
                    return DualAppManager.sharedInstance.getAllDual().firstIndex(where: {$0.ids == app.ids}) == nil
                })
            } catch let jsonError as NSError {
                print("JSON decode failed: \(jsonError.description)")
                return []
            }
        }
        return []
    }

    func reloadData() {
        OperationQueue.main.addOperation {
            self.tableView.reloadData()
        }
    }

    func seach(text: String = "") {
        arrayDataFilter = text.trimming().isEmpty ? arrayData : arrayData.filter { ob in
            return ob.name.uppercased().contains(text.trimming().uppercased())
        }
        reloadData()
    }
}

extension AppListViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.endEditing(true)
        tfSeach.text = textField.text?.trimming()
        seach(text: textField.text ?? "")
        return true
    }

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if let text = textField.text,
           let textRange = Range(range, in: text) {
            let updatedText = text.replacingCharacters(in: textRange, with: string)

            seach(text: updatedText)
        }
        return true
    }
}

extension AppListViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayDataFilter.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeue(AppListTableViewCell.self)
        cell.config(data: arrayDataFilter[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        createDualApp()
    }
}


