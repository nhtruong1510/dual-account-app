//
//  AlbumDetailVC.swift
//  dual-account-app
//
//  Created by Huu Truong Nguyen on 11/23/21.
//

import UIKit
import Gallery
import Photos
import KRProgressHUD

class AlbumDetailVC: BaseViewController {
    @IBOutlet weak var selectAllButton: UIButton!
    @IBOutlet weak var trashButton: UIButton!
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var collectionView: UICollectionView! {
        didSet {
            collectionView.register(nibWithCellClass: GalleryItem.self)
            collectionView.delegate = self
            collectionView.dataSource = self
            let lpgr : UILongPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress))
            lpgr.minimumPressDuration = 0.3
            lpgr.delegate = self
            lpgr.delaysTouchesBegan = true
            collectionView.addGestureRecognizer(lpgr)
        }
    }
//
//    private let selectAllButton = UIButton(type: .system).with {
//        $0.frame.size = CGSize(width: isIPad ? 120 : 90, height: 40)
//        $0.contentHorizontalAlignment = .leading
//        $0.setTitle("Select All", for: .normal)
//        $0.setTitleColor(.hex_12518E, for: .normal)
//        $0.isUserInteractionEnabled = true
//    }
    @IBAction func back() {
        self.navigationController?.popViewController(animated: true)
    }
    private var arrData = [GalleryObj]()
    private var gallery: GalleryController!
    private let editor: VideoEditing = VideoEditor()
    private var isMultiSelect = false
   // private var locationSevice = LocationService()
    private var currentLocation: CLLocation?
    private var isSelectAll = false

    var objGallery = AlbumObj()

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
//        configNavi(title: objGallery.name,
//                   leftButton: .back,
//                   rightButton: .none,
//                   leftCompletion:  {
//                    self.navigationController?.popViewController(animated: true)
//                   })
        initUI()
        initData()
//        locationSevice.requestLocationAuthorization()
//        locationSevice.getLocation()
//        locationSevice.newLocation = { [weak self] result in
//            switch result {
//            case .success(let location):
//                self?.currentLocation = location
//            case .failure(let error):
//                print(error)
//            }
//        }
    }

    @IBAction func actionAddPhoto(_ sender: UIButton) {
        addPhoto(sender)
    }

}

extension AlbumDetailVC {
    func initUI() {
        trashButton.rx.tap
            .subscribe(onNext: { [unowned self] in
                selected()
            })
            .disposed(by: rx.disposeBag)

        deleteButton.rx.tap
            .subscribe(onNext: { [unowned self] in
                alertRemoveImage()
            })
            .disposed(by: rx.disposeBag)
        selectAllButton.rx.tap
            .subscribe(onNext: { [unowned self] in
                selectAllImage()
            })
            .disposed(by: rx.disposeBag)
        
//        trashButton.tintColor = .redCustom
        deleteButton.isHidden = true
        selectAllButton.isHidden = true
    }

    func initData() {
        self.arrData.removeAll()
        self.arrData = self.objGallery.id == "-1" ? galleryManager.getAllGallery() : galleryManager.getAllGalleryByIdAlbum(self.objGallery.id)
        collectionView.reloadData()
    }

    func cameraRoll(){
        if UIImagePickerController.isSourceTypeAvailable(.camera){
            let myPickerController = UIImagePickerController()
            myPickerController.delegate = self
            myPickerController.sourceType = .camera
            myPickerController.mediaTypes = ["public.movie"]//"public.image",
            self.present(myPickerController, animated: true, completion: nil)
        }
    }

    @objc func handleLongPress(gestureRecognizer : UILongPressGestureRecognizer){
        if (gestureRecognizer.state != .ended){
            return
        }
        let p = gestureRecognizer.location(in: self.collectionView)
        if let _ : IndexPath = self.collectionView.indexPathForItem(at: p) {
            self.selected()
        }
    }

    func selected() {
        isMultiSelect = !isMultiSelect
        deleteButton.isHidden = !isMultiSelect
        selectAllButton.isHidden = !isMultiSelect
        isSelectAll = true
        selectAllImage()
    }

    func selectImage(indexPath: IndexPath, isSelect: Bool) {
        arrData[indexPath.item].isSelected = !isSelect
        collectionView.reloadItems(at: [indexPath])
        updateUIDelete()
    }

    private func updateUIDelete() {
        let countSelect = arrData.filter({$0.isSelected}).count
        deleteButton.do {
            $0.setTitle(countSelect == 0 ? "Delete" : "Delete(\(countSelect))", for: .normal)
            $0.setTitleColor(countSelect == 0 ? .hex_C4C4C4 : .purple, for: .normal)
            $0.isUserInteractionEnabled = countSelect != 0
        }
    }

    private func alertRemoveImage() {
        present(title: "Warning",
                message: "Do you want to remove this image?",
                actionTitles: ["Cancel", "OK"],
                handler: { [unowned self] action in
                    switch action.title {
                    case "OK":
                        for obj in self.arrData.filter({$0.isSelected}) {
                            let url = FilePaths.filePaths.path+obj.fileName
                            self.deleteFile(url: URL(fileURLWithPath: url))
                            obj.deleteGallery()
                        }
                        self.initData()
                        self.selected()
                    default:
                        break
                    }
                })
    }

    private func deleteFile(url: URL) {
        let fileManager = FileManager.default
        do {
            try fileManager.removeItem(at: url)
            print("Delete")
        }
        catch let error as NSError {
            print("Ooops! Something went wrong: \(error)")
        }
    }

    func addPhoto(_ button: UIButton?) {
        self.gallery = GalleryController()
        Config.Camera.recordLocation = true
        self.gallery.delegate = self
        gallery.modalPresentationStyle = .fullScreen
        let alert = UIAlertController(title: "Select Media", message: "Please Select an Option", preferredStyle: .actionSheet)

        alert.addAction(UIAlertAction(title: "Camera Roll", style: .default , handler:{ (UIAlertAction)in
            print("User click Approve button")
            self.cameraRoll()
        }))

        alert.addAction(UIAlertAction(title: "Select Video in Library", style: .default , handler:{ (UIAlertAction)in
            print("User click Edit button")
            Config.tabsToShow = [.imageTab,  .cameraTab, .videoTab]
            self.present(self.gallery, animated: true, completion: nil)
        }))

        alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler:{ (UIAlertAction)in
            print("User click Dismiss button")
        }))

        if let popoverPresentationController = alert.popoverPresentationController {
            if let button = button {
                popoverPresentationController.sourceView = button
                popoverPresentationController.sourceRect = CGRect(x: button.bounds.midX, y: button.bounds.midY, width: 5, height: 5)
            }else{
                popoverPresentationController.sourceView = self.view
                popoverPresentationController.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 10, height: 10)
            }
            popoverPresentationController.permittedArrowDirections = []
        }
        self.present(alert, animated: true, completion: {
            print("completion block")
        })
    }

    private func selectAllImage() {
        arrData = arrData.map({ objGallery in
            let obj = objGallery
            obj.isSelected = !isSelectAll
            return obj
        })
        isSelectAll = !isSelectAll
        if isSelectAll {
            selectAllButton.setImage(#imageLiteral(resourceName: "tick (1)"), for: .normal)
        }
        else {
            selectAllButton.setImage(#imageLiteral(resourceName: "tick"), for: .normal)
        }
        collectionView.reloadData()
        updateUIDelete()
    }
}

extension AlbumDetailVC: GalleryControllerDelegate {
    func galleryController(_ controller: GalleryController, didSelectImages images: [Image]) {
        controller.dismiss(animated: true) {
            KRProgressHUD.show()
            Image.resolve(images: images, completion: { (images) in
                for img in images {
                    if let imgs = img {
                        GalleryManagerDic.saveImageInDocsDir(self.objGallery.id,
                                                             imgs, lat: self.currentLocation?.coordinate.latitude ?? -1, long: self.currentLocation?.coordinate.longitude ?? -1)
                    }
                }
                self.initData()
                self.gallery = nil
                KRProgressHUD.dismiss()
            })
        }
    }

    func galleryController(_ controller: GalleryController, didSelectVideo video: Video) {
        controller.dismiss(animated: true) {
            self.gallery = nil
            KRProgressHUD.show()
            self.editor.edit(video: video) { [weak self] (editedVideo, tempPath) in
                guard let self = self else { return }
                DispatchQueue.main.async {
                    if let tempPath = tempPath {
                        tempPath.saveVideo(idAlbum: self.objGallery.id,
                                           duration: video.asset.duration,
                                           lat: video.asset.location?.coordinate.latitude ?? -1,
                                           long: video.asset.location?.coordinate.longitude ?? -1,
                                           success: { (status, url) in
                                            if status {
                                                self.initData()
                                            }
                                            self.gallery = nil
                                            KRProgressHUD.dismiss()
                                           })
                    }
                }
            }
        }
    }

    func galleryController(_ controller: GalleryController, requestLightbox images: [Image]) {
        controller.dismiss(animated: true) {
        }
    }

    func galleryControllerDidCancel(_ controller: GalleryController) {
        controller.dismiss(animated: true) {

        }
    }
}

extension AlbumDetailVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let videoUrl = info[.mediaURL] as! URL
        let asset = AVURLAsset(url: videoUrl)
        let durationInSeconds = asset.duration.seconds
        videoUrl.saveVideo(idAlbum: self.objGallery.id,
                           duration: durationInSeconds,
                           lat: currentLocation?.coordinate.latitude ?? -1,
                           long: currentLocation?.coordinate.longitude ?? -1,
                           success: { (status, url) in
                            if status {
                                self.initData()
                            }
                           })
        dismiss(animated: true, completion: nil)
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}

extension AlbumDetailVC: UIGestureRecognizerDelegate {

}

extension AlbumDetailVC: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrData.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let item = collectionView.dequeueReusableCell(withClass: GalleryItem.self, for: indexPath)
        item.config(arrData[indexPath.item], isMultiSelect: isMultiSelect)
        item.handleSelect = { [weak self] isSelect in
            self?.selectImage(indexPath: indexPath, isSelect: isSelect)
        }
        return item
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = isIPad ? (collectionView.bounds.size.width / 6) - 10 : (collectionView.bounds.size.width / 3) - 7.5
        return CGSize(width: width, height: width)
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "PreviewViewController") as! PreviewViewController
        vc.albums = arrData
        vc.index = indexPath.item
        vc.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

extension URL {
    func saveVideo(idAlbum: String,
                   duration: Double,
                   lat: Double = -1,
                   long: Double = -1,
                   success:@escaping (Bool,URL?)->()){
        let dataPath = FilePaths.filePaths.path
        let fileManager = FileManager.default
        if !fileManager.fileExists(atPath: dataPath) {
            try? fileManager.createDirectory(atPath: dataPath, withIntermediateDirectories: true, attributes: nil) //Create folder if not
        }
        let uuid = UUID().uuidString
        let fileName = uuid+".mp4"
        let fileURL = URL(fileURLWithPath:dataPath).appendingPathComponent(fileName)//Your image name
        print(fileURL)
        do {
            try fileManager.moveItem(atPath: self.path, toPath: fileURL.path)
            print("Coppy:\(fileURL.path)")
            let obj = GalleryObj()
            obj.id = uuid
            obj.fileName = fileName
            obj.isVideo = true
            obj.idAlbum = idAlbum
            obj.duration = duration
            obj.lat = lat
            obj.long = long
            obj.saveGalleryList(true)
            success(true,fileURL)
        }
        catch let error as NSError {
            success(false,fileURL)
            print("Ooops! Something went wrong: \(error)")
        }
    }
}

class GalleryManagerDic: NSObject {
    func saveImageInDocsDir(_ idAlbum: String,_ asset: PHAsset, _ isNotes: Bool = false) {
        let image: UIImage? = getUIImage(asset: asset)//Here set your image
        if !(image == nil) {
            let dataPath = FilePaths.filePaths.path
            if !FileManager.default.fileExists(atPath: dataPath) {
                try? FileManager.default.createDirectory(atPath: dataPath, withIntermediateDirectories: true, attributes: nil) //Create folder if not
            }
            let uuid = UUID().uuidString
            let fileName = uuid+".jpg"
            let fileURL = URL(fileURLWithPath:dataPath).appendingPathComponent(fileName)//Your image name
            print(fileURL)
            // get your UIImage jpeg data representation
            let data = image?.jpegData(compressionQuality: 1)//Set image quality here
            do {
                // writes the image data to disk
                try data?.write(to: fileURL, options: .atomic)
                let obj = GalleryObj()
                obj.id = uuid
                obj.fileName = fileName
                obj.idAlbum = idAlbum
                obj.isNotes = isNotes
                obj.saveGalleryList(true)
            } catch {
                print("error:", error)
            }
        }
    }

    static func saveImageInDocsDir(_ idAlbum: String,_ image: UIImage?, _ isNotes: Bool = false, lat: Double = -1, long: Double = -1) {
        //        let image: UIImage? = getUIImage(asset: asset)//Here set your image
        if !(image == nil) {
            let dataPath = FilePaths.filePaths.path
            if !FileManager.default.fileExists(atPath: dataPath) {
                try? FileManager.default.createDirectory(atPath: dataPath, withIntermediateDirectories: true, attributes: nil) //Create folder if not
            }
            let uuid = UUID().uuidString
            let fileName = uuid+".jpg"
            let fileURL = URL(fileURLWithPath:dataPath).appendingPathComponent(fileName)//Your image name
            print(fileURL)
            // get your UIImage jpeg data representation
            let data = image?.jpegData(compressionQuality: 1)//Set image quality here
            do {
                // writes the image data to disk
                try data?.write(to: fileURL, options: .atomic)
                let obj = GalleryObj()
                obj.id = uuid
                obj.fileName = fileName
                obj.idAlbum = idAlbum
                obj.isNotes = isNotes
                obj.lat = lat
                obj.long = long
                obj.saveGalleryList(true)
            } catch {
                print("error:", error)
            }
        }
    }

    func getUIImage(asset: PHAsset) -> UIImage? {
        var img: UIImage?
        let manager = PHImageManager.default()
        let options = PHImageRequestOptions()
        options.version = .original
        options.isSynchronous = true
        manager.requestImageData(for: asset, options: options) { data, _, _, _ in
            if let data = data {
                img = UIImage(data: data)
            }
        }
        return img
    }

    func getThumbnailFrom(path: URL) -> UIImage? {
        do {
            let asset = AVURLAsset(url: path , options: nil)
            let imgGenerator = AVAssetImageGenerator(asset: asset)
            imgGenerator.appliesPreferredTrackTransform = true
            let cgImage = try imgGenerator.copyCGImage(at: CMTimeMake(value: 0, timescale: 1), actualTime: nil)
            let thumbnail = UIImage(cgImage: cgImage)
            return thumbnail
        } catch let error {
            print("*** Error generating thumbnail: \(error.localizedDescription)")
            return nil
        }
    }

    func deleteFile(url: URL) {
        let fileManager = FileManager.default
        do {
            try fileManager.removeItem(at: url)
            print("Delete")
        }
        catch let error as NSError {
            print("Ooops! Something went wrong: \(error)")
        }
    }
}
