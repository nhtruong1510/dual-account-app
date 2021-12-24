//
//  PopUpViewController.swift
//  dual-account-app
//
//  Created by Huu Truong Nguyen on 11/18/21.
//

import UIKit
import RxSwift
import RxCocoa

class PopUpViewController: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var containerEditView: UIView!
    @IBOutlet weak var totalView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var createButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
//        cancelButton.roundCorners([.topLeft, .bottomLeft], radius: 10)
//        createButton.roundCorners([.topRight, .bottomRight], radius: 10)
        totalView.layer.cornerRadius = 20
        Observable.merge(cancelButton.rx.tap.asObservable(),
                         createButton.rx.tap.asObservable())
            .subscribe(onNext: { [unowned self] in
                self.dismiss(animated: true, completion: nil)
            })
            .disposed(by: rx.disposeBag)
        
        createButton.rx.tap
            .subscribe(onNext: { [unowned self] in
                if let name = self.nameTextField.text, !name.trimming().isEmpty {
                    self.handleSave?(name.trimming())
                }
            })
            .disposed(by: rx.disposeBag)
        view.backgroundColor = UIColor(hex: "414141").withAlphaComponent(0.5)
        nameTextField.placeholder = placeholder
        containerEditView.cornerRadius = 22
        
        switch editWidgetType {
        case .edit(let title, let name):
            nameTextField.text = name
            nameId = name
            titleLabel.text = title
        case .add(let title):
            titleLabel.text = title
        }

        createButton.disable(nameTextField.text?.trimming().isEmpty ?? false)
        nameTextField.do {
            //$0.setup(font: .roboto(weight: .regular, size: 15), textColor: .black)
            $0.delegate = self
            $0.rx.controlEvent(.editingChanged)
                .subscribe(onNext: { [unowned self] _ in
                    if nameTextField.text?.trimming().isEmpty ?? false {
                        nameTextField.text = ""
                    }
                    createButton.disable(nameTextField.text?.trimming().isEmpty ?? false)
                })
                .disposed(by: rx.disposeBag)
        }
        
//        cancelButton.setup(title: "Cancel",
//                           font: .roboto(weight: .bold, size: 12),
//                           titleColor: .init(hex: "646464"),
//                           backgroundColor: .init(hex:"CECECE"))
//        
//        titleLabel.font = .roboto(weight: .regular, size: 15)
//        createButton.setup(title: "Save",
//                           font: .roboto(weight: .bold, size: 12),
//                           titleColor: .white,
//                           backgroundColor: .hex_0076E9)
        
        containerEditView.do {
            $0.isHidden = true
            $0.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.containerEditView.isHidden = false
            UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 0.4, initialSpringVelocity: 2, options: []) {
                self.containerEditView.transform = .identity
            } completion: { (_) in

            }
        }
        // Do any additional setup after loading the view.
    }
    
    var editWidgetType: EditWidgetType = .edit(title: "", value: "")
    var nameId: String = ""

    var placeholder =  ""
    var handleSave: ((String) -> ())?
    
    enum EditWidgetType: Equatable {
        case edit(title: String, value: String)
        case add(title: String)
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
