//
//  Observable.swift
//  BaseProject
//
//  Created by user.name on 7/17/20.
//  Copyright © 2020 user.name. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

extension ObservableType where Element == Bool {
    /// Boolean toggle operator
    public func toggle() -> Observable<Bool> {
        return self.map(!)
    }

}

extension SharedSequenceConvertibleType {
    func mapToVoid() -> SharedSequence<SharingStrategy, Void> {
        return map { _ in }
    }
    
    func unwrap<T>() -> SharedSequence<SharingStrategy, T> where Element == T? {
        return self.filter { $0 != nil }.map { $0! } // swiftlint:disable:this force_unwrapping
    }
}

extension ObservableType {

    func catchErrorJustComplete() -> Observable<Element> {
        return catchError { _ in
            return Observable.empty()
        }
    }

    func asDriverOnErrorJustComplete() -> Driver<Element> {
        return asDriver { _ in
            return Driver.empty()
        }
    }

    func mapToVoid() -> Observable<Void> {
        return map { _ in }
    }
}
