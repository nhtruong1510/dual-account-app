//
//  AlbumViewController.swift
//  dual-account-app
//
//  Created by Huu Truong Nguyen on 11/18/21.
//

import UIKit

class AlbumViewController: BaseViewController {
    // MARK: - IBOutlets
    @IBOutlet weak var collectionView: UICollectionView! {
        didSet {
            collectionView.register(nibWithCellClass: AlbumItem.self)
            collectionView.register(nibWithCellClass: PlusCLVCell.self)
            collectionView.delegate = self
            collectionView.dataSource = self
        }
    }
    @IBAction func back() {
        self.navigationController?.popViewController(animated: true)
    }
    // MARK: - Properties
    var arrayData = [AlbumObj]()
    // MARK: - Life Cycle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: true)
        initData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
        collectionView.collectionViewLayout = flowLayout
    }

    @IBAction func actionAddNewAlbum(_ sender: Any) {
    }
}

extension AlbumViewController {
    func initData() {
        arrayData.removeAll()
        let obj = AlbumObj("All")
        obj.id = "-1"
        arrayData.append(obj)
        arrayData.append(contentsOf: albumManager.getAllAlbum())
        collectionView.reloadData()
    }

    func optionAlbum(obj: AlbumObj, cell: AlbumItem) {
        let ac = UIAlertController(title: "Album", message: nil, preferredStyle: .actionSheet)
        ac.addAction(UIAlertAction(title: "Rename", style: .default, handler: { _ in
            self.editAlbum(obj: obj)
        }))
        ac.addAction(UIAlertAction(title: "Delete", style: .default, handler: { _ in
            self.deleteAlbum(obj: obj)
        }))
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        showPopover(ofViewController: ac, originView: cell.contentView)
    }

    private func editAlbum(obj: AlbumObj) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "PopUpViewController") as! PopUpViewController
        vc.editWidgetType = .edit(title: "Edit Album", value: obj.name)
        vc.placeholder = "Album name"
        vc.handleSave = { [weak self] name in
            obj.name = name
            obj.updateAlbum()
            self?.initData()
        }
        vc.modalTransitionStyle = .crossDissolve
        vc.modalPresentationStyle = .overCurrentContext
        self.present(vc, animated: true)
    }

    private func deleteAlbum(obj: AlbumObj) {
        self.present(title: "Warning",
                     message: "Do you want to remove this album?",
                     actionTitles: ["Cancel", "OK"],
                     handler: { [unowned self] action in
                        switch action.title {
                        case "OK":
                            let data = galleryManager.getAllGalleryByIdAlbum(obj.id)
                            data.forEach { (model) in
                                model.deleteGallery()
                            }
                            obj.deleteAlbum()
                            self.initData()
                        default:
                            break
                        }
                     })
    }
}

extension AlbumViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrayData.count + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.item == arrayData.count {
            let item = collectionView.dequeueReusableCell(withClass: PlusCLVCell.self, for: indexPath)
            item.shadowView(alpha: 0.5, x: 2, y: 2, blur: 4)
            item.layer.cornerRadius = 10
            return item
        }
        let item = collectionView.dequeueReusableCell(withClass: AlbumItem.self, for: indexPath)
        let itemData = arrayData[indexPath.item]
        item.layer.cornerRadius = 10
        item.shadowView(alpha: 0.5, x: 2, y: 2, blur: 4)
        item.config(itemData)
        item.btnEdit.rx.tap
            .subscribe(onNext: { [unowned self] in
                self.optionAlbum(obj: itemData, cell: item)
            })
            .disposed(by: rx.disposeBag)
        return item
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if iPad {
            return CGSize(width: collectionView.frame.width/2 - 25, height: 55)
        }
        return CGSize(width: collectionView.frame.width, height: 55)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 25
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 25
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.item == arrayData.count {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "PopUpViewController") as! PopUpViewController
            vc.editWidgetType = .add(title: "Create New Album")
            vc.placeholder = "Album name"
            vc.handleSave = { [weak self] name in
                let obj = AlbumObj()
                obj.name = name
                obj.saveAlbumList(true)
                self?.initData()
            }
            vc.modalTransitionStyle = .crossDissolve
            vc.modalPresentationStyle = .overCurrentContext
            self.present(vc, animated: true)
        }
        else {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "AlbumDetailVC") as! AlbumDetailVC
            vc.objGallery = arrayData[indexPath.item]
            vc.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}


