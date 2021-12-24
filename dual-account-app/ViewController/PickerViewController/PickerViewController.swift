//
//  DatePickerViewController.swift
//  Dreamdays
//
//  Created by user.name on 12/01/2021.
//  Copyright © 2021 Hoang Thai. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import PanModal

final class PickerViewController: BaseViewController, PanModalPresentable {
    @IBOutlet weak var dismissView: UIView!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var typeDateLabel: UILabel!
    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var wheelPickerView: WheelPickerView!
    
    // MARK: - Pan Modal Presentable
    var panScrollable: UIScrollView? {
        return nil
    }
    var panModalBackgroundColor: UIColor {
        return UIColor.black.withAlphaComponent(0.4)
    }
    
    var showDragIndicator: Bool {
        return false
    }
    
    var datePickerMode: UIDatePicker.Mode = .date
    
    var handleDate: ((Date) -> ())?
    var handleRepeatType: ((RepeatType) -> ())?
    var date: Date = Date()
    var repeatType: RepeatType?
    
//    init(datePickerMode: UIDatePicker.Mode, date: Date, repeatType: RepeatType?) {
//        self.datePickerMode = datePickerMode
//        self.date = date
//        self.repeatType = repeatType
//        super.init(nibName: nil, bundle: nil)
//    }
//    
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        doneButton.circle()
    }
    
    override func setupUI() {
        containerView.cornerRadius = 20
        
        typeDateLabel.text = datePickerMode == .time ? ReminderType.hour.title : ReminderType.time.title
        datePicker.setDate(date, animated: false)
        datePicker.locale = Locale(identifier: datePickerMode == .time
                                    ? "en_GB"
                                    : Locale.current.languageCode ?? "en_GB")
        datePicker.datePickerMode = datePickerMode
        datePicker.timeZone = TimeZone.current
        
        if #available(iOS 14, *) { // Added condition for iOS 14
            datePicker.preferredDatePickerStyle = .wheels
            datePicker.sizeToFit()
        }
        datePicker.isHidden = repeatType.isNotNil
        wheelPickerView.isHidden = repeatType.isNil
    }
    
    override func bindRxOutlets() {
        dismissView.rx.tapGesture()
            .mapToVoid()
            .subscribe(onNext: { [unowned self] in
                self.dismiss(animated: true)
            })
            .disposed(by: rx.disposeBag)
        
        doneButton.rx.tap
            .subscribe(onNext: { [unowned self] in
                self.dismiss(animated: true, completion: {
                    if repeatType.isNotNil {
                        handleRepeatType?(RepeatType(rawValue: wheelPickerView.dataSelected) ?? .justOneTime)
                    } else {
                        handleDate?(datePicker.date.zeroSeconds ?? Date())
                    }
                })
            })
            .disposed(by: rx.disposeBag)
    }
    
    override func setupData() {
        if let repeatType = repeatType {
            wheelPickerView.initData(arrayData: RepeatType.allCases.filter({$0 != .never}).map({ $0.rawValue }),
                                     dataSelected: repeatType.rawValue)
        }
    }
}
