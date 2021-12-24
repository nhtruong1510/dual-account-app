//
//  DualAppObj.swift
//  DualAccount
//
//  Created by Phung Anh Dung on 09/08/2021.
//

import Foundation
import CoreData

struct DualAppResponse: Codable {
    let login : [DualAppDataResponse]?
    enum CodingKeys: String, CodingKey {
            case login = "login"
    }
    init(from decoder: Decoder) throws {
            let values = try decoder.container(keyedBy: CodingKeys.self)
            login = try values.decodeIfPresent([DualAppDataResponse].self, forKey: .login)
    }
}

struct DualAppDataResponse: Codable {
    let icon : String?
    let title : String?
    let urls : UrlAppResponse?

    enum CodingKeys: String, CodingKey {
        case icon = "icon"
        case title = "title"
        case urls = "urls"
    }
}

struct UrlAppResponse : Codable {
    let url : String?
    let login : String?
    enum CodingKeys: String, CodingKey {
        case url = "url"
        case login = "login"
    }
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        url = try values.decodeIfPresent(String.self, forKey: .url)
        login = try values.decodeIfPresent(String.self, forKey: .login)
    }

}

class DualAppObj: NSObject {
    var name: String = ""
    var image: String = ""
    var ids: String = ""
    var url: String = ""
    var isSelected = false
    var userName: String = ""
    
    override init() {
        super.init()
    }

    init(_ obj: DualAppDataResponse) {
        self.name = obj.title ?? ""
        self.image = obj.icon ?? ""
        self.ids = obj.title ?? ""
        self.url = obj.urls?.login?.isEmpty ?? true ? obj.urls?.url ?? "" : obj.urls?.login ?? ""
        self.userName = ""
    }

    init(_ obj: DualApp) {
        self.name = obj.name ?? ""
        self.image = obj.image ?? ""
        self.ids = obj.ids ?? ""
        self.url = obj.url ?? ""
        self.userName = obj.userName ?? ""
    }

    func saveData(_ isMerge: Bool = true) {
        print("save Note name: \(self.name), \(isMerge)")
        let minionManagedObjectContextWorker: NSManagedObjectContext =
            NSManagedObjectContext.init(concurrencyType: NSManagedObjectContextConcurrencyType.privateQueueConcurrencyType)
        minionManagedObjectContextWorker.parent = mainContextInstance

        let app = NSEntityDescription.insertNewObject(forEntityName: "DualApp",
                                                         into: minionManagedObjectContextWorker) as! DualApp
        app.ids = self.ids
        app.name = self.name
        app.image = self.image
        app.userName = self.userName
        app.url = self.url

        persistenceManager.saveWorkerContext(minionManagedObjectContextWorker)
        if isMerge {
            persistenceManager.mergeWithMainContext()
        }
    }

    func updateData() {
        if let app = findNote() {
            app.ids = self.ids
            app.name = self.name
            app.image = self.image
            app.userName = self.userName
            app.url = self.url
            persistenceManager.mergeWithMainContext()
        }
    }

    func delete() {
        if let app = findNote() {
            mainContextInstance.delete(app)
            persistenceManager.mergeWithMainContext()
        }
    }
}

extension DualAppObj {
    func findNote() -> DualApp? {
        let fetchRequest =
            NSFetchRequest<NSManagedObject>(entityName: "DualApp")
        fetchRequest.returnsObjectsAsFaults = false
        fetchRequest.predicate = NSPredicate(format:"%K == %@", "ids", self.ids as CVarArg)
        var fetchedResults: Array<DualApp> = Array<DualApp>()
        do {
            fetchedResults = try  mainContextInstance.fetch(fetchRequest) as! [DualApp]
        } catch let fetchError as NSError {
            print("retrieveById error: \(fetchError.localizedDescription)")
            fetchedResults = Array<DualApp>()
        }
        if fetchedResults.count == 1 {
            return fetchedResults.first
        }
        return nil
    }
}
