//
//  RxSwift+UITextField.swift
//  BaseProject
//
//  Created by user.name on 7/17/20.
//  Copyright © 2020 user.name. All rights reserved.
//

import RxSwift
import UIKit

extension Reactive where Base: UITextField {
    var textChanged: Observable<String?> {
        return Observable.merge(self.base.rx.observe(String.self, "text"),
                                self.base.rx.controlEvent(.editingChanged).withLatestFrom(self.base.rx.text))
    }
}
