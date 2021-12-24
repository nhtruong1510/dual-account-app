//
//  MenuViewController.swift
//  dual-account-app
//
//  Created by Huu Truong Nguyen on 11/17/21.
//

import UIKit

class MenuViewController: UIViewController {
    @IBOutlet var collectionView: UICollectionView!
    @IBOutlet var titleView: UIView!

    @IBAction func back() {
        self.navigationController?.popViewController(animated: true)
    }
    
    var listMenu: [MenuModel] = [MenuModel]()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.collectionView.register( UINib(nibName: "MenuCLVCell" , bundle: nil), forCellWithReuseIdentifier: "MenuCLVCell" )
        listMenu = MenuData.shared.menu
        // Do any additional setup after loading the view.
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

extension MenuViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return listMenu.count - 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MenuCLVCell", for: indexPath) as! MenuCLVCell
        if indexPath.item == 0 {
            cell.contentView.backgroundColor = #colorLiteral(red: 0.2337720394, green: 0.138956368, blue: 0.4281082749, alpha: 1)
        }
        else {
            cell.contentView.backgroundColor = #colorLiteral(red: 0.4259997308, green: 0.2507537603, blue: 0.7114805579, alpha: 1)
        }
        cell.labelName.text = listMenu[indexPath.item].name
        cell.imgView.image = listMenu[indexPath.item].image
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.item == 5 {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "PrivateNoteViewController") as! PrivateNoteViewController
            vc.modalPresentationStyle = .fullScreen
            self.navigationController?.pushViewController(vc, animated: true)
            //self.present(vc, animated: true)
        }
        else if indexPath.item == 1 {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "PrivateBrowserViewController") as! PrivateBrowserViewController
            vc.modalPresentationStyle = .fullScreen
            self.navigationController?.pushViewController(vc, animated: true)
            //self.present(vc, animated: true)
        }
        else if indexPath.item == 2 {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "PrivateNoteViewController") as! PrivateNoteViewController
            vc.modalPresentationStyle = .fullScreen
            self.navigationController?.pushViewController(vc, animated: true)
            //self.present(vc, animated: true)
        }
        else if indexPath.item == 3 {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "AlbumViewController") as! AlbumViewController
            vc.modalPresentationStyle = .fullScreen
            self.navigationController?.pushViewController(vc, animated: true)
            //self.present(vc, animated: true)
        }
        else if indexPath.item == 4 {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "SettingViewController") as! SettingViewController
            vc.modalPresentationStyle = .fullScreen
            self.navigationController?.pushViewController(vc, animated: true)
            //self.present(vc, animated: true)
        }
    }
}

extension MenuViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 50)
    }
}
