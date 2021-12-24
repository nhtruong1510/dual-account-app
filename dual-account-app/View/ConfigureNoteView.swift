//
//  SegmentView.swift
//  MeeTruckMouseAdjusters
//
//  Created by user.name on 23/02/2021.
//

import UIKit
import RxSwift
import MBProgressHUD

private enum Constant {
    static let numCellInLineColor: CGFloat = isIPad ? 10 : 7
    static let spacingItemColor: CGFloat = 16*widthRatio
}

final class ConfigureNoteView: BaseView {
    // MARK: - Outlets
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var stackView: UIStackView!
    // segmentNoteType == .none
    @IBOutlet weak var containerNoneView: UIView!
    @IBOutlet weak var containerDisplayDetailReminderView: UIView!
    @IBOutlet weak var reminderTypeButton: UIButton!
    @IBOutlet weak var reminderDateLabel: UILabel!
    @IBOutlet weak var collectionViewViewPhoto: UICollectionView!
    // segmentNoteType == .background
    @IBOutlet weak var containerBackgroundView: UIView!
    @IBOutlet weak var collectionViewBackground: UICollectionView!
    // segmentNoteType == .reminder
    @IBOutlet weak var containerReminderView: UIView!
    @IBOutlet weak var tableViewReminder: UITableView!
    // segmentNoteType == .addPhoto
    @IBOutlet weak var containerAddPhotoView: UIView!
    @IBOutlet weak var addPhotoButton: UIButton!
    @IBOutlet weak var collectionViewAddPhoto: UICollectionView!
    
    // MARK: - Variables
    private var segmentNoteType: SegmentNoteType? = .background {
        didSet {
            updateSegmentType()
        }
    }
    
    private var noteObj: NoteObj = NoteObj() {
        didSet {
            updateDataNoteObj()
        }
    }
    private var colorTypes: [ColorType] = ColorType.allCases
    private var reminderTypes: [ReminderType] = ReminderType.allCases
    private var addPhotoAtIndex: Int?
    private var camera: CameraHelper?
    
    var handleOpenReminder: (() -> Void)?
    var handleOpenAddPhoto: (() -> Void)?
    var handleBackgroundColor: ((ColorType) -> Void)?
    var handleReminderDate: ((Date) -> Void)?
    var handleRepeatType: ((RepeatType) -> Void)?
    var handleAddPhoto: ((UIImage) -> Void)?
    var handleAddPhotoAtIndex: ((UIImage, Int) -> Void)?
    var handleRemovePhoto: ((Int) -> Void)?
    
    // MARK: - View LifeCycle
    override func awakeFromNib() {
        super.awakeFromNib()
        configure()
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
    }
}

// MARK: - Public Functions
extension ConfigureNoteView {
    func setSegment(_ type: SegmentNoteType?) {
        segmentNoteType = type
    }
    
    func setNote(_ noteObj: NoteObj) {
        self.noteObj = noteObj
    }
}

// MARK: - Private Functions
extension ConfigureNoteView {
    private func configure() {
        after(interval: 0, completion: { [unowned self] in
            collectionViewBackground.do {
                $0.contentInset = UIEdgeInsets(top: Constant.spacingItemColor,
                                               left: Constant.spacingItemColor,
                                               bottom: Constant.spacingItemColor,
                                               right: Constant.spacingItemColor)
                
                let layout = UICollectionViewFlowLayout()
                let width = (screenSize.width - CGFloat(2 + Constant.numCellInLineColor - 1)*Constant.spacingItemColor) / Constant.numCellInLineColor
                layout.itemSize = CGSize(width: width, height: width)
                layout.minimumLineSpacing = Constant.spacingItemColor
                layout.minimumInteritemSpacing = Constant.spacingItemColor
                layout.scrollDirection = .horizontal
                $0.collectionViewLayout = layout
                
                $0.delegate = self
                $0.dataSource = self
                $0.register(nibWithCellClass: ColorCell.self)
            }
            
            [collectionViewViewPhoto, collectionViewAddPhoto].forEach {
                $0.do {
                    $0.contentInset = UIEdgeInsets(top: 0,
                                                   left: Constant.spacingItemColor,
                                                   bottom: 0,
                                                   right: Constant.spacingItemColor)
                    
                    let layout = UICollectionViewFlowLayout()
                    let height = collectionViewAddPhoto.height - 2
                    layout.itemSize = CGSize(width: height, height: height)
                    layout.minimumLineSpacing = 0
                    layout.minimumInteritemSpacing = 0
                    layout.scrollDirection = .horizontal
                    $0.collectionViewLayout = layout
                    
                    $0.delegate = self
                    $0.dataSource = self
                    $0.register(nibWithCellClass: AddPhotoCell.self)
                }
            }
        })
        
        tableViewReminder.do {
            $0.delegate = self
            $0.dataSource = self
            $0.register(ReminderCell.self)
        }
        
        addPhotoButton.do {
            //$0.titleLabel?.font = .roboto(weight: .medium, size: 15)
            $0.contentEdgeInsets = UIEdgeInsets(top: 15*heightRatio,
                                                left: 30*heightRatio,
                                                bottom: 15*heightRatio,
                                                right: 30*heightRatio)
            $0.titleEdgeInsets.right = -15*heightRatio
            $0.imageEdgeInsets.left = -15*heightRatio
            $0.rx.tap
                .subscribe(onNext: { [unowned self] in
                    actionAddPhoto()
                })
                .disposed(by: rx.disposeBag)
        }
        
        Observable.merge(containerDisplayDetailReminderView.rx.tapGesture().skip(1).mapToVoid(),
                         reminderTypeButton.rx.tap.mapToVoid())
            .subscribe(onNext: { [unowned self] in
                handleOpenReminder?()
            })
            .disposed(by: rx.disposeBag)
        
        reminderDateLabel.setLineSpacing(alignment: .left,
                                         lineSpace: 8*heightRatio,
                                         lineBreakMode: .byTruncatingTail)
        
//        containerNoneView.isHidden = true
        containerBackgroundView.isHidden = true
        containerReminderView.isHidden = true
        containerAddPhotoView.isHidden = true
    }
    
    private func updateDataNoteObj() {
        containerDisplayDetailReminderView.isHidden = noteObj.repeatType == .never
        reminderTypeButton.setImage(noteObj.repeatType.icon, for: .normal)
        reminderDateLabel.text = noteObj.reminderDate.toString(DateFormatter.Format.MMMMdayMonthYear.rawValue) +
            "\n" +
            noteObj.reminderDate.toString(DateFormatter.Format.hourAndMinutes.rawValue)
                                                                
        if collectionViewBackground.numberOfItems() > 0 {
            collectionViewBackground.reloadData()
            if let indexColorType = colorTypes.firstIndex(of: noteObj.colorType) {
                collectionViewBackground.scrollToItem(at: IndexPath(item: indexColorType, section: 0),
                                                      at: .centeredHorizontally,
                                                      animated: true)
            }
        }
        tableViewReminder.reloadData()
        collectionViewAddPhoto.reloadData()
        collectionViewViewPhoto.reloadData()
    }
    
    private func updateSegmentType() {
//        if segmentNoteType != .none {
//            containerNoneView.isHidden = segmentNoteType != .none
//            containerBackgroundView.isHidden = segmentNoteType != .background
//            containerReminderView.isHidden = segmentNoteType != .reminder
//            containerAddPhotoView.isHidden = segmentNoteType != .addPhoto
//
//            after(interval: 0.005, completion: { [unowned self] in
//                if collectionViewBackground.numberOfItems() > 0 {
//                    if let index = colorTypes.firstIndex(where: { $0 == noteObj.colorType }) {
//                        collectionViewBackground.scrollToItem(at: IndexPath(item: index, section: 0),
//                                                              at: .centeredHorizontally,
//                                                              animated: false)
//                    }
//                }
//                if collectionViewAddPhoto.numberOfItems() > 0 {
//                    collectionViewAddPhoto.scrollToItem(at: IndexPath(item: 0, section: 0),
//                                                        at: .left,
//                                                        animated: false)
//                }
//            })
//        }
//
//        UIView.animate(withDuration: 0.3,
//                       animations: { [unowned self] in
//                        containerNoneView.alpha = segmentNoteType != .none ? 0 : 1
//                        containerBackgroundView.alpha = segmentNoteType != .background ? 0 : 1
//                        containerReminderView.alpha = segmentNoteType != .reminder ? 0 : 1
//                        containerAddPhotoView.alpha = segmentNoteType != .addPhoto ? 0 : 1
//                       }, completion: { [unowned self] _ in
//                        containerNoneView.isHidden = segmentNoteType != .none
//                        containerBackgroundView.isHidden = segmentNoteType != .background
//                        containerReminderView.isHidden = segmentNoteType != .reminder
//                        containerAddPhotoView.isHidden = segmentNoteType != .addPhoto
//                       })
        
        UIView.animate(withDuration: 0.3,
                       animations: { [unowned self] in
                        containerDisplayDetailReminderView.alpha = segmentNoteType != .none ? 0 : 1
                        collectionViewViewPhoto.alpha = segmentNoteType != .none ? 0 : 1
                        containerNoneView.isHidden = segmentNoteType != .none
                        containerBackgroundView.isHidden = segmentNoteType != .background
                        containerReminderView.isHidden = segmentNoteType != .reminder
                        containerAddPhotoView.isHidden = segmentNoteType != .addPhoto
                        stackView.layoutIfNeeded()
                       }, completion: { [unowned self] _ in
                        containerNoneView.isHidden = segmentNoteType != .none
                        containerBackgroundView.isHidden = segmentNoteType != .background
                        containerReminderView.isHidden = segmentNoteType != .reminder
                        containerAddPhotoView.isHidden = segmentNoteType != .addPhoto
                       })
    }
    
    private func actionAddPhoto() {
        endEditing(true)
        if camera == nil {
            camera = CameraHelper(delegate: self)
        }
        if let topViewController = UIApplication.topViewController() {
            let alert = UIAlertController(title: "Select from:", message: nil, preferredStyle: .actionSheet).then {
                $0.addAction(UIAlertAction(title: "Take a Photo", style: .default, handler: { [unowned self]  (_) in
                    self.camera?.getCameraOn(topViewController, canEdit: false)
                }))
                $0.addAction(UIAlertAction(title: "Camera Roll", style: .default, handler: { [unowned self]  (_) in
                    self.camera?.getPhotoLibraryOn(topViewController, canEdit: false)
                }))
                $0.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            }
            topViewController.presentAlert(alert, animated: true, completion: nil)
        }
    }
    
    private func presentPickerController(mode: UIDatePicker.Mode, repeatType: RepeatType?) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "PickerViewController") as! PickerViewController
        vc.datePickerMode = mode
        vc.date = noteObj.reminderDate
        vc.repeatType = repeatType
        vc.handleDate = { [unowned self] date in
            handleReminderDate?(date)
        }
        vc.handleRepeatType = { [unowned self] repeatType in
            handleRepeatType?(repeatType)
        }
        if let topViewController = UIApplication.topViewController() as? BaseViewController {
            topViewController.presentPanModalBase(vc: vc)
        }
    }
    
    private func notifyRemovePhoto(at index: Int) {
        let topViewController = UIApplication.topViewController()
        topViewController?.present(title: "Warning",
                                   message: "Do you want to remove this photo - (\(index + 1))?",
                                   actionTitles: ["Cancel", "OK"],
                                   handler: { [unowned self] action in
                                    switch action.title {
                                    case "OK":
                                        handleRemovePhoto?(index)
//                                        photosAdded.remove(at: index)
                                    default:
                                        break
                                    }
                                   })
    }
}

// MARK: - CollectionView DataSource
extension ConfigureNoteView: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch collectionView {
        case collectionViewBackground:
            return colorTypes.count
        case collectionViewAddPhoto, collectionViewViewPhoto:
            return noteObj.photos.count
        default:
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch collectionView {
        case collectionViewBackground:
            return collectionView.dequeueReusableCell(withClass: ColorCell.self, for: indexPath).with {
                $0.bind(type: colorTypes[indexPath.row],
                        selectedType: noteObj.colorType)
            }
        case collectionViewAddPhoto, collectionViewViewPhoto:
            return collectionView.dequeueReusableCell(withClass: AddPhotoCell.self, for: indexPath).with {
                $0.bind(image: noteObj.photos[indexPath.row].getImage(),
                        allowEdit: collectionView == collectionViewAddPhoto)
                $0.handleRemove = { [unowned self] in
                    notifyRemovePhoto(at: indexPath.row)
                }
            }
        default:
            return UICollectionViewCell()
        }
    }
}

// MARK: - CollectionView Delegate
extension ConfigureNoteView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch collectionView {
        case collectionViewBackground:
            handleBackgroundColor?(colorTypes[indexPath.row])
        case collectionViewAddPhoto:
            addPhotoAtIndex = indexPath.row
            actionAddPhoto()
        case collectionViewViewPhoto:
            handleOpenAddPhoto?()
        default:
            break
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView == collectionViewViewPhoto {
            collectionViewAddPhoto.contentOffset = collectionViewViewPhoto.contentOffset
        }
        if scrollView == collectionViewAddPhoto {
            collectionViewViewPhoto.contentOffset = collectionViewAddPhoto.contentOffset
        }
    }
}

// MARK: UITableViewDataSource
extension ConfigureNoteView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        reminderTypes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        tableView.dequeue(ReminderCell.self).with {
            $0.bind(type: reminderTypes[indexPath.row], noteObj: noteObj)
            $0.handleReminder = { [unowned self] in
                switch reminderTypes[indexPath.row] {
                case .time:
                    presentPickerController(mode: .date, repeatType: nil)
                case .hour:
                    presentPickerController(mode: .time, repeatType: nil)
                case .repeat:
                    presentPickerController(mode: .date, repeatType: noteObj.repeatType != .never ? noteObj.repeatType : .justOneTime)
                }
            }
        }
    }
}

// MARK: UITableViewDelegate
extension ConfigureNoteView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        tableView.height / CGFloat(reminderTypes.count)
    }
}

// MARK: - Camera Delegate
extension ConfigureNoteView: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let hud = MBProgressHUD.showAdded(to: self, animated: true)
        hud.offset.y = -30
        DispatchQueue.global().async {
            DispatchQueue.main.async {
                picker.dismiss(animated: true, completion: {
                    if let pickedImage = info[.originalImage] as? UIImage {
                        pickedImage.resizedTo1MB { (imageResized) in
                            if let addPhotoAtIndex = self.addPhotoAtIndex {
                                self.handleAddPhotoAtIndex?(imageResized, addPhotoAtIndex)
                                self.addPhotoAtIndex = nil
                            } else {
                                self.handleAddPhoto?(imageResized)
                            }
                            MBProgressHUD.hide(for: self, animated: true)
                        }
                    }
                })
            }
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}
