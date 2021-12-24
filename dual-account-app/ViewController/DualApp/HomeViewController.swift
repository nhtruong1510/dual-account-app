//
//  HomeViewController.swift
//  dual-account-app
//
//  Created by Huu Truong Nguyen on 11/17/21.
//

import UIKit
import SideMenu

class HomeViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UIPopoverPresentationControllerDelegate {
    
    @IBOutlet var collectionView: UICollectionView!
    var arrayData = [DualAppObj]()

    override func viewDidLoad() {
        super.viewDidLoad()
        SideMenuManager.default.addPanGestureToPresent(toView: self.navigationController!.navigationBar)
        SideMenuManager.default.addScreenEdgePanGesturesToPresent(toView: self.navigationController!.view)
        collectionView.register(nibWithCellClass: DualAppCLVCell.self)
        collectionView.dataSource = self
        collectionView.delegate = self
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        reloadData()
    }
    
    @IBAction func menuAction(){
        // Define the menu
        // SideMenuNavigationController is a subclass of UINavigationController, so do any additional configuration
        // of it here like setting its viewControllers. If you're using storyboards, you'll want to do something like:
        let menu = storyboard!.instantiateViewController(withIdentifier: "SideMenuNavigationController") as! SideMenuNavigationController
        menu.menuWidth = UIScreen.main.bounds.width * 3/5
        //menu.presentationStyle = .menuSlideIn
        present(menu, animated: true, completion: nil)
    }
    
    func reloadData() {
        arrayData = DualAppManager.sharedInstance.getAllDual();
        collectionView.reloadData()
    }
    
    func optionDualApp(app: DualAppObj, cell: DualAppCLVCell) {
        let ac = UIAlertController(title: "Multiple Account", message: nil, preferredStyle: .actionSheet)
        ac.addAction(UIAlertAction(title: "Rename", style: .default, handler: { _ in
            self.editDualApp(app: app)
        }))
        ac.addAction(UIAlertAction(title: "Delete", style: .default, handler: { _ in
            self.deleteDualApp(app: app)
        }))
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        showPopover(ofViewController: ac, originView: cell.contentView)
    }
    
    func showPopover(ofViewController popoverViewController: UIViewController, originView: UIView) {
        popoverViewController.modalPresentationStyle = UIModalPresentationStyle.popover
        if let popoverController = popoverViewController.popoverPresentationController {
            popoverController.delegate = self
            popoverController.sourceView = originView
            popoverController.sourceRect = originView.bounds
            popoverController.permittedArrowDirections = UIPopoverArrowDirection.any
        }
        self.present(popoverViewController, animated: true)
    }
    
    func editDualApp(app: DualAppObj) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "PopUpViewController") as! PopUpViewController
        vc.editWidgetType = .edit(title: "Edit Account", value: app.userName)
        vc.placeholder = "Username"
        vc.handleSave = { [weak self] name in
            app.userName = name
            app.updateData()
            self?.reloadData()
        }
        vc.modalTransitionStyle = .crossDissolve
        vc.modalPresentationStyle = .overCurrentContext
        self.present(vc, animated: true)
    }

    func deleteDualApp(app: DualAppObj) {
        self.present(title: "Warning",
                     message: "Do you want to remove this app?",
                     actionTitles: ["Cancel", "OK"],
                     handler: { [unowned self] action in
                        switch action.title {
                        case "OK":
                            app.delete()
                            reloadData()
                        default:
                            break
                        }
                     })
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
extension HomeViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrayData.count + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withClass: DualAppCLVCell.self, for: indexPath)
        if indexPath.item == arrayData.count {
            cell.labelName.text = ""
            cell.imgView.image = #imageLiteral(resourceName: "plus")
        }
        else {
            cell.config(app: arrayData[indexPath.item])
        }
        if indexPath.item < arrayData.count {
            cell.handleEdited = { [weak self] in
                guard let self = self else { return }
                self.optionDualApp(app: self.arrayData[indexPath.item], cell: cell)
            }
            cell.editButton.isHidden = false
        }
        else {
            cell.editButton.isHidden = true
        }
        cell.shadowView(alpha: 0.5, x: 2, y: 2, blur: 4)
        cell.layer.cornerRadius = 10
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = isIPad ? (collectionView.frame.width / 6) - 20 : (collectionView.frame.width / 3) - 20
        return CGSize(width: width, height: width)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 20
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 20
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //self.present(vc, animated: true)
        if indexPath.item < arrayData.count {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "DualAppViewController") as! DualAppViewController
            vc.modalPresentationStyle = .fullScreen
            vc.appObj = arrayData[indexPath.item]
            //vc.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(vc, animated: true)
        }
        else {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "AppListViewController") as! AppListViewController
            vc.modalPresentationStyle = .fullScreen
            //vc.appObj = arrayData[indexPath.item]
            //vc.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}
