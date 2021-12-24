//
//  SegmentView.swift
//  MeeTruckMouseAdjusters
//
//  Created by user.name on 23/02/2021.
//

import UIKit
import RxSwift

final class SegmentNoteView: BaseView {
    // MARK: - Outlets
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var backgroundButton: UIButton!
    @IBOutlet weak var reminderButton: UIButton!
    @IBOutlet weak var addPhotoButton: UIButton!
    @IBOutlet weak var stackViewSegment: UIStackView!
    
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var titleSelectionLabel: UILabel!
    @IBOutlet weak var checkMarkButton: UIButton!
    @IBOutlet weak var cancelView: UIView!
    
    // MARK: - Variables
    private var segmentNoteType: SegmentNoteType? {
        didSet {
            updateSegmentType()
        }
    }
    
    var handleSegment: ((SegmentNoteType?) -> Void)?
    var handleTickReminder: (() -> Void)?

    override func awakeFromNib() {
        super.awakeFromNib()
        segmentNoteType = .none
        
        backgroundButton.rx.tap
            .subscribe(onNext: { [unowned self] in
                segmentNoteType = .background
            })
            .disposed(by: rx.disposeBag)
        
        reminderButton.rx.tap
            .subscribe(onNext: { [unowned self] in
                segmentNoteType = .reminder
            })
            .disposed(by: rx.disposeBag)
        
        addPhotoButton.rx.tap
            .subscribe(onNext: { [unowned self] in
                segmentNoteType = .addPhoto
            })
            .disposed(by: rx.disposeBag)
        
        Observable.merge(closeButton.rx.tap.mapToVoid(),
                         titleSelectionLabel.rx.tapGesture().skip(1).mapToVoid(),
                         checkMarkButton.rx.tap.mapToVoid())
            .subscribe(onNext: { [unowned self] in
                if segmentNoteType == .reminder {
                    handleTickReminder?()
                }
                segmentNoteType = .none
            })
            .disposed(by: rx.disposeBag)
        
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
    }
    
    func setSegment(_ type: SegmentNoteType) {
        segmentNoteType = type
    }
}

// MARK: - Private Functions
extension SegmentNoteView {
    private func updateSegmentType() {
        UIView.animate(withDuration: 0.3, animations: { [unowned self] in
            stackViewSegment.isHidden = segmentNoteType != .none
            cancelView.isHidden = segmentNoteType == .none
            titleSelectionLabel.text = segmentNoteType?.title
            
            stackView.layoutIfNeeded()
        })
        
        handleSegment?(segmentNoteType)
    }
}
