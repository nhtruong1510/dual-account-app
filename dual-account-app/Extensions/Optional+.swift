//
//  Optional+.swift
//  BaseProject
//
//  Created by user.name on 10/01/2021.
//  Copyright © 2021 user.name. All rights reserved.
//

import Foundation

protocol AnyOptional {
    var isNil: Bool { get }
    var isNotNil: Bool { get }
}

extension Optional: AnyOptional {
    var isNil: Bool { self == nil }
    var isNotNil: Bool { self != nil }
}
