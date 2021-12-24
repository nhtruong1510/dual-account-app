//
//  CreateNoteViewController.swift
//  dual-account-app
//
//  Created by Huu Truong Nguyen on 11/22/21.
//

import UIKit

final class CreateNoteViewController: BaseViewController, UIImagePickerControllerDelegate {
    // MARK: - IBOutlets
    @IBOutlet weak var textView: InputTextView!
    @IBOutlet weak var deleteNoteButton: UIButton!
    @IBOutlet weak var timeEditLabel: UILabel!
    @IBOutlet weak var segmentNoteView: SegmentNoteView!
    @IBOutlet weak var configureNoteView: ConfigureNoteView!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var titleNaviButton: UIButton!
    
    @IBAction func back() {
        self.navigationController?.popViewController(animated: true)
    }
    // MARK: - Properties
    var noteObj: NoteObj = NoteObj()
    
    var handleReloadData: (() -> Void)?
    
    override func setupUI() {
        
        segmentNoteView.handleSegment = { [unowned self] segmentNoteType in
            configureNoteView.setSegment(segmentNoteType)
        }
        
        titleNaviButton.setTitle(noteObj.noteName, for: .normal)
        
        textView.do {
            $0.textContainerInset = UIEdgeInsets(top: 14*heightRatio,
                                                 left: 16*heightRatio,
                                                 bottom: 14*heightRatio,
                                                 right: 16*heightRatio)
            if !noteObj.noteText.isEmpty {
                $0.text = noteObj.noteText
                $0.textColor = $0.colorText
                $0.updateLineSpacing()
            }
            else {
                $0.text = ""
            }
        }
        
        timeEditLabel.text = noteObj.createDate.toString(DateFormatter.Format.MMMMdayMonthYearHourMinutes.rawValue)
    }
    
    override func bindRxOutlets() {
        titleNaviButton.do {
            $0.rx.tap
                .subscribe(onNext: { [unowned self] in
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let vc = storyboard.instantiateViewController(withIdentifier: "PopUpViewController") as! PopUpViewController
                    vc.editWidgetType = .edit(title: "Rename Note", value: "")
                    vc.handleSave = { [unowned self] name in
                        noteObj.noteName = name
                        titleNaviButton.setTitle(noteObj.noteName, for: .normal)
                    }
                    vc.modalTransitionStyle = .crossDissolve
                    vc.modalPresentationStyle = .overCurrentContext
                    self.present(vc, animated: true)
                })
                .disposed(by: rx.disposeBag)
        }
        
        textView.didEndEditing = { [unowned self] text in
            noteObj.noteText = text
        }
        
        saveButton.rx.tap
            .subscribe(onNext: { [unowned self] in
                self.view.endEditing(true)
                if self.noteObj.id.isEmpty {
                    self.noteObj.then {
                        $0.id = Common.generateID()
                        $0.createDate = Date()
                    }.saveNote()
                } else {
                    self.noteObj.with {
                        $0.createDate = Date()
                    }.updateNote()
                }
                self.dismiss(animated: true, completion: {
                    self.handleReloadData?()
                })
            })
            .disposed(by: rx.disposeBag)
        
        deleteNoteButton.rx.tap
                .subscribe(onNext: { [unowned self] in
                    noteObj.noteText = ""
                    textView.text = ""
                    textView.becomeFirstResponder()
                })
                .disposed(by: rx.disposeBag)
        
        // MARK: - Closure ConfigureNoteView
        configureNoteView.handleOpenAddPhoto = { [unowned self] in
            segmentNoteView.setSegment(.addPhoto)
        }
        configureNoteView.handleOpenReminder = { [unowned self] in
            segmentNoteView.setSegment(.reminder)
        }
        configureNoteView.handleBackgroundColor = { [unowned self] colorType in
            noteObj.colorType = colorType
            updateConfigureNote()
        }
        configureNoteView.handleReminderDate = { [unowned self] reminderDate in
            noteObj.reminderDate = reminderDate
            updateConfigureNote()
        }
        configureNoteView.handleRepeatType = { [unowned self] repeatType in
            noteObj.repeatType = repeatType
            updateConfigureNote()
        }
        segmentNoteView.handleTickReminder = { [unowned self] in
            noteObj.repeatType = noteObj.repeatType == .never ? .justOneTime : noteObj.repeatType
            updateConfigureNote()
        }
        configureNoteView.handleAddPhoto = { [unowned self] image in
            noteObj.photos.append(ImageData(photo: image))
            updateConfigureNote()
        }
        configureNoteView.handleAddPhotoAtIndex = { [unowned self] (image, index) in
            noteObj.photos[index] = ImageData(photo: image)
            updateConfigureNote()
        }
        configureNoteView.handleRemovePhoto = { [unowned self] index in
            noteObj.photos.remove(at: index)
            updateConfigureNote()
        }
    }
    
    override func setupData() {
        updateConfigureNote()
    }
    
}

// MARK: - Private Functions
extension CreateNoteViewController {
    private func updateConfigureNote() {
        configureNoteView.setNote(noteObj)
    }
}


