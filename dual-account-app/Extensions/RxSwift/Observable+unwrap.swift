//
//  Observable+unwrap.swift
//  BaseProject
//
//  Created by user.name on 7/17/20.
//  Copyright © 2020 user.name. All rights reserved.
//

import RxSwift

extension ObservableType {
    public func unwrap<T>() -> Observable<T> where Element == T? {
        return self.filter { $0 != nil }.map { $0! } // swiftlint:disable:this force_unwrapping
    }
}
