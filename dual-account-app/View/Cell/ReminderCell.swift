//
//  ReminderCell.swift
//  DualAccount
//
//  Created by user.name on 25/07/2021.
//

import UIKit

class ReminderCell: UITableViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var contentButton: UIButton!
    
    var handleReminder: (() -> Void)?
    override func awakeFromNib() {
        super.awakeFromNib()
        //contentButton.titleLabel?.font = .roboto(weight: .regular, size: 12).autoResize()
        
        contentButton.rx.tap
            .subscribe(onNext: { [unowned self] in
                handleReminder?()
            })
            .disposed(by: rx.disposeBag)
    }
    
    func bind(type: ReminderType, noteObj: NoteObj) {
        titleLabel.text = type.title
        
        UIView.performWithoutAnimation { [unowned self] in
            switch type {
            case .time:
                contentButton.setTitle(noteObj.reminderDate.toString(DateFormatter.Format.MMMMdayMonthYear.rawValue), for: .normal)
            case .hour:
                contentButton.setTitle(noteObj.reminderDate.toString(DateFormatter.Format.hourAndMinutes.rawValue), for: .normal)
            case .repeat:
                contentButton.setTitle((noteObj.repeatType != .never ? noteObj.repeatType : .justOneTime).rawValue, for: .normal)
            }
            contentButton.layoutIfNeeded()
        }
    }
}
