//
//  NoteManager.swift
//  NoteManager
//
//  Created by user.name on 10/14/20.
//  Copyright © 2019 user.name. All rights reserved.
//

import Foundation
import UIKit
import CoreData
import UserNotifications

final class NoteManager {
    static let sharedInstance = NoteManager()
    
    var arrSearch: [NoteObj] = []

    init() { }

    func getAllNote() -> [NoteObj] {
        var fetchedResults: Array<Note> = Array<Note>()
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Note")
        do {
            fetchedResults = try mainContextInstance.fetch(fetchRequest) as? [Note] ?? []
        } catch let fetchError as NSError {
            print("retrieveById error: \(fetchError.localizedDescription)")
            fetchedResults = Array<Note>()
        }
        var result: [NoteObj] = []
        for fetch in fetchedResults {
            let obj: NoteObj = NoteObj(fetch)
            result.append(obj)
        }
        return result.sorted(by: { (obj1, obj2) -> Bool in
            obj1.createDate > obj2.createDate
        })
    }
}

let noteManager = NoteManager.sharedInstance

