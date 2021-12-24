//
//  BaseView.swift
//  BaseProject
//
//  Created by user.name on 7/17/20.
//  Copyright © 2020 user.name. All rights reserved.
//

import UIKit
import RxSwift

class BaseView: UIView {
    var bag = DisposeBag()
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        setupData()
    }

    private func commonInit() {
        guard let content = Bundle.main.loadNibNamed(className, owner: self, options: nil)?.first as? UIView else {
            return
        }
        content.frame = bounds
        content.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        addSubview(content)
        setupUI()
    }

    internal func setupUI() { }
    internal func setupData() { }

    deinit {
        debugPrint("\(String(describing: type(of: self))) \(#function)")
    }
}
