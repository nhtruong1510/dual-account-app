//
//  DualAppManager.swift
//  DualAccount
//
//  Created by Phung Anh Dung on 09/08/2021.
//

import Foundation
import CoreData

class DualAppManager {
    static let sharedInstance = DualAppManager()

    var arrSearch: [DualAppObj] = []

    init() { }

    func getAllDual() -> [DualAppObj] {
        var fetchedResults: Array<DualApp> = Array<DualApp>()
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "DualApp")
        do {
            fetchedResults = try mainContextInstance.fetch(fetchRequest) as? [DualApp] ?? []
        } catch let fetchError as NSError {
            print("retrieveById error: \(fetchError.localizedDescription)")
            fetchedResults = Array<DualApp>()
        }
        var result: [DualAppObj] = []
        for fetch in fetchedResults {
            let obj: DualAppObj = DualAppObj(fetch)
            result.append(obj)
        }
        return result.sorted(by: { (obj1, obj2) -> Bool in
            obj1.ids > obj2.ids
        })
    }
}
