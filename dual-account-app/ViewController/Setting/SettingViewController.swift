//
//  SettingViewController.swift
//  dual-account-app
//
//  Created by Huu Truong Nguyen on 11/17/21.
//

import UIKit

class SettingViewController: UIViewController {
    @IBOutlet weak var collectionViewMain: UICollectionView!
    var listSetting: [SettingModel] = [SettingModel]()
    override func viewDidLoad() {
        super.viewDidLoad()
        listSetting = SettingData.shared.menu
        collectionViewMain.backgroundColor = .clear
        collectionViewMain.register(UINib(nibName: "AlbumItem", bundle: nil), forCellWithReuseIdentifier: "AlbumItem")
        var cellWidth = 0
        if UIDevice.current.userInterfaceIdiom == .pad {
            cellWidth = Int(UIScreen.main.bounds.width) / 5 - 10
        } else {
            cellWidth = Int(UIScreen.main.bounds.width) / 3 - 10
        }
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.itemSize = CGSize(width: cellWidth, height: (cellWidth * 120) / 90)
        flowLayout.sectionInset = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5)
        flowLayout.scrollDirection = UICollectionView.ScrollDirection.vertical
        flowLayout.minimumInteritemSpacing = 0.0
        collectionViewMain.collectionViewLayout = flowLayout
        // Do any additional setup after loading the view.
    }
    
    @IBAction func backAction(){
        self.navigationController?.popViewController(animated: true)
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

extension SettingViewController: UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.item == 3 {
            actionShare()
        }
        else if indexPath.item == 0 {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "PassCodeVC") as! PassCodeVC
            vc.typeView = 1
            vc.modalPresentationStyle = .fullScreen
            self.present(vc, animated: true)
        }
        else {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "ContentSettingVC") as! ContentSettingVC
            vc.name = listSetting[indexPath.item].text
            vc.content = listSetting[indexPath.item].content
            vc.modalTransitionStyle = .crossDissolve
            vc.modalPresentationStyle = .overCurrentContext
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func actionShare() {
        let text = [ "https://apps.apple.com/us/app/id" + appid ]
        let activityViewController = UIActivityViewController(activityItems: text , applicationActivities: nil)
        if isIPad {
            if activityViewController.responds(to: #selector(getter: UIViewController.popoverPresentationController)) {
                activityViewController.popoverPresentationController?.sourceView = collectionViewMain.cellForItem(at: IndexPath(item: 2, section: 0))
            }
        }
        activityViewController.hidesBottomBarWhenPushed = true
        self.present(activityViewController, animated: true, completion: nil)
    }
}
extension SettingViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return listSetting.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionViewMain.dequeueReusableCell(withReuseIdentifier: "AlbumItem", for: indexPath) as! AlbumItem
        
        cell.label.text = listSetting[indexPath.item].text
        cell.images.image = listSetting[indexPath.item].image
        cell.btnEdit.isHidden = true
        cell.layer.cornerRadius = 10
        return cell
    }
}

extension SettingViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 50)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 20
    }
    
}




