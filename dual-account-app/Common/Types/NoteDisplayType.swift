//
//  NoteDisplayType.swift
//  DualAccount
//
//  Created by user.name on 24/07/2021.
//

import Foundation

enum NoteDisplayType: String, CaseIterable {
    case collection
    case smallCollection
    case detail
    case smallDetail
    
    var title: String {
        switch self {
        case .collection:
            return "Collection"
        case .smallCollection:
            return "Small Collection"
        case .detail:
            return "Detail"
        case .smallDetail:
            return "Small Detail"
        }
    }
}
