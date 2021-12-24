//
//  PrivateNoteViewController.swift
//  dual-account-app
//
//  Created by Huu Truong Nguyen on 11/17/21.
//

import UIKit
import WebKit

final class PrivateNoteViewController: BaseViewController {
    // MARK: - IBOutlets
    @IBOutlet weak var collectionViewNote: UICollectionView!
        
    @IBAction func back() {
        self.navigationController?.popViewController(animated: true)
    }
    // MARK: - Properties
    enum StatusView {
        case view
        case edit
    }
    enum SortType: String {
        case time
        case character
    }
    private let trashButton = UIButton(type: .system).with {
        $0.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
        $0.contentHorizontalAlignment = .trailing
        $0.setImage(#imageLiteral(resourceName: "enable-bin"), for: .normal)
    }
    private let deleteButton = UIButton(type: .system).with {
        $0.frame.size = CGSize(width: isIPad ? 120 : 90, height: 40)
        $0.contentHorizontalAlignment = .trailing
        $0.setTitle("Delete", for: .normal)
    }
    
    private let noteDisplayTypes: [NoteDisplayType] = NoteDisplayType.allCases
    private var noteDisplayTypeSelected: NoteDisplayType = NoteDisplayType(rawValue: AppSettings.noteDisplayTypeSelected) ?? .collection {
        didSet {
            updateNoteDisplayType()
        }
    }
    private var statusView: StatusView = .view {
        didSet {
            updateStatusView()
        }
    }
    private var sortType: SortType = SortType(rawValue: AppSettings.noteSortType) ?? .time {
        didSet {
            updateSortType()
        }
    }
    private var arrayNotes: [NoteObj] = []
    private var arrayNotesSearch: [NoteObj] = []
    private var arrayNotesSelected: [NoteObj] = [] {
        didSet {
            deleteButton.do {
                $0.setTitle(arrayNotesSelected.isEmpty ? "Delete" : "Delete(\(arrayNotesSelected.count))", for: .normal)
                $0.setTitleColor(arrayNotesSelected.isEmpty ? .hex_C4C4C4 : .redCustom, for: .normal)
                $0.isUserInteractionEnabled = !arrayNotesSelected.isEmpty
            }
        }
    }

    // MARK: - Life Cycle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        reloadMasterData()
    }
    
    override func setupUI() {
        configure()
    }
    
    override func bindRxOutlets() {
        trashButton.rx.tap
            .subscribe(onNext: { [unowned self] in
                statusView = statusView == .view ? .edit : .view
            })
            .disposed(by: rx.disposeBag)

        deleteButton.rx.tap
            .subscribe(onNext: { [unowned self] in
                alertRemoveNotes()
            })
            .disposed(by: rx.disposeBag)
//
//        Observable.merge(wholeViewSortContainer.rx.tapGesture().mapToVoid(),
//                         sortByTimeButton.rx.tap.mapToVoid(),
//                         sortByCharacterButton.rx.tap.mapToVoid(),
//                         trashButton.rx.tap.mapToVoid(),
//                         deleteButton.rx.tap.mapToVoid())
//            .subscribe(onNext: { [unowned self] in
//                self.hideSortContainerView()
//            })
//            .disposed(by: rx.disposeBag)
        
        NotificationCenter.default.rx
            .notification(.reloadMasterDataNote)
            .mapToVoid()
            .subscribe(onNext: { [unowned self] in
                reloadMasterData()
            })
            .disposed(by: rx.disposeBag)
    }
}

// MARK: - Private Functions
extension PrivateNoteViewController {
    private func configure() {
        
        collectionViewNote.do {
            $0.register(nibWithCellClass: NoteCLVCell.self)
            $0.register(nibWithCellClass: PlusCLVCell.self)
            $0.dataSource = self
            $0.delegate = self
        }
        
        sortType = SortType(rawValue: AppSettings.noteSortType) ?? .time
        statusView = .view
    }
    
    private func updateNoteDisplayType() {
        collectionViewNote.reloadData()
        AppSettings.noteDisplayTypeSelected = noteDisplayTypeSelected.rawValue
    }
    
    private func updateStatusView() {
        if statusView == .view {
            arrayNotesSelected.removeAll()
        }
        trashButton.tintColor = statusView == .view ? .hex_C4C4C4 : .redCustom
        deleteButton.isHidden = statusView == .view
        collectionViewNote.reloadData()
    }
    
    private func updateSortType() {
        reloadMasterData()
        AppSettings.noteSortType = sortType.rawValue
    }
    
    private func toCreateNote(noteObj: NoteObj) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "CreateNoteViewController") as! CreateNoteViewController
        vc.noteObj = (noteObj.copy() as? NoteObj)!
        vc.handleReloadData = { [unowned self] in
            reloadMasterData()
        }
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true, completion: nil)
    }
    
    private func reloadMasterData() {
        arrayNotes = noteManager.getAllNote()
        collectionViewNote.reloadData()
    }
    
    private func alertRemoveNotes() {
        present(title: "Warning",
                message: "Do you want to remove this notes?",
                actionTitles: ["Cancel", "OK"],
                handler: { [unowned self] action in
                    switch action.title {
                    case "OK":
                        var indexs: [IndexPath] = []
                        arrayNotesSelected.forEach { note in
                            note.deleteNote()
                            if let index = arrayNotesSearch.firstIndex(of: note) {
                                indexs.append(IndexPath(item: index, section: 0))
                                arrayNotesSearch.remove(at: index)
                            }
                        }
                        reloadMasterData()
                        arrayNotesSelected = []
                    default:
                        break
                    }
                })
    }
}


// MARK: - CollectionView DataSource
extension PrivateNoteViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrayNotes.count + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.item == arrayNotes.count {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PlusCLVCell", for: indexPath) as! PlusCLVCell
            cell.layer.cornerRadius = 10
            cell.shadowView(alpha: 0.5, x: 2, y: 2, blur: 4)
            return cell
        }
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "NoteCLVCell", for: indexPath) as! NoteCLVCell
        cell.labelName.text = arrayNotes[indexPath.item].noteText
        let date = arrayNotes[indexPath.item].createDate
        cell.labelDate.text = date.toString("dd-MM-yyyy")
        cell.shadowView(alpha: 0.5, x: 2, y: 2, blur: 4)
        cell.layer.cornerRadius = 10
        return cell
    }
}

// MARK: - CollectionView Delegate
extension PrivateNoteViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch statusView {
        case .view:
            if indexPath.item == arrayNotes.count {
                toCreateNote(noteObj: NoteObj())
            }
            else {
                toCreateNote(noteObj: arrayNotes[indexPath.row])
            }
        case .edit:
            if let index = arrayNotesSelected.firstIndex(of: arrayNotes[indexPath.row]) {
                arrayNotesSelected.remove(at: index)
            } else {
                arrayNotesSelected.append(arrayNotes[indexPath.row])
            }
            collectionViewNote.reloadData()
        }
       
    }
}

// MARK: - CollectionView Delegate FlowLayout
extension PrivateNoteViewController: UICollectionViewDelegateFlowLayout {
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
}
