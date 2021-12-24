//
//  CallObj.swift
//  PCM
//
//  Created by Anh Dũng on 11/13/19.
//  Copyright © 2019 Anh Dũng. All rights reserved.
//

import UIKit
import CoreData

class GalleryObj: NSObject {
    var id: String = ""
    var fileName: String = ""
    var isVideo: Bool = false
    var idAlbum: String = ""
    var isNotes: Bool = false
    var duration: Double = 0
    var lat: Double = -1
    var long: Double = -1

    var isSelected = false

    override init() {
        super.init()
        id = UUID().uuidString
    }
    
    init(_ fileName: String = "", _ isVideo: Bool = false, idAlbum: String = "", isNotes: Bool = false) {
        self.fileName = fileName
        self.isVideo = isVideo
        self.idAlbum = idAlbum
        self.isNotes = isNotes
    }
    
    init(_ obj: Gallery) {
        self.id = obj.id ?? ""
        self.fileName = obj.fileName ?? ""
        self.isVideo = obj.isVideo
        self.idAlbum = obj.idAlbum ?? ""
        self.isNotes = obj.isNotes
        self.duration = obj.duration
        self.lat = obj.lat
        self.long = obj.long
    }
}

extension GalleryObj {
    func saveGalleryList(_ isMerge: Bool = false) {
        print("save Gallery list, \(self.fileName), \(isMerge)")
        
        let minionManagedObjectContextWorker: NSManagedObjectContext =
            NSManagedObjectContext.init(concurrencyType: NSManagedObjectContextConcurrencyType.privateQueueConcurrencyType)
        minionManagedObjectContextWorker.parent = mainContextInstance
        
        let gallery = NSEntityDescription.insertNewObject(forEntityName: "Gallery",
                                                          into: minionManagedObjectContextWorker) as! Gallery
        gallery.id = self.id
        gallery.fileName = self.fileName
        gallery.isVideo = self.isVideo
        gallery.idAlbum = self.idAlbum
        gallery.isNotes = self.isNotes
        gallery.duration = self.duration
        gallery.lat = self.lat
        gallery.long = self.long
        
        persistenceManager.saveWorkerContext(minionManagedObjectContextWorker)
        if isMerge {
            persistenceManager.mergeWithMainContext()
        }
    }
    
    func updateGallery() {
        if let gallery = findGallery() {
            gallery.fileName = self.fileName
            gallery.isVideo = self.isVideo
            gallery.idAlbum = self.idAlbum
            gallery.isNotes = self.isNotes
            gallery.duration = self.duration
            gallery.lat = self.lat
            gallery.long = self.long
            persistenceManager.mergeWithMainContext()
        }else{
            print("Don't find item")
        }
    }
    
    func deleteGallery() {
        if let gallery = findGallery() {
            mainContextInstance.delete(gallery)
            persistenceManager.mergeWithMainContext()
        }else{
            print("Don't find item")
        }
    }
    
    func findGallery() -> Gallery? {
        let fetchRequest =
            NSFetchRequest<NSManagedObject>(entityName: "Gallery")
        fetchRequest.returnsObjectsAsFaults = false
        fetchRequest.predicate = NSPredicate(format:"%K == %@", "id", self.id as CVarArg)
        
        var fetchedResults: Array<Gallery> = Array<Gallery>()
        
        do {
            fetchedResults = try  mainContextInstance.fetch(fetchRequest) as! [Gallery]
        } catch let fetchError as NSError {
            print("retrieveById error: \(fetchError.localizedDescription)")
            fetchedResults = Array<Gallery>()
        }
        if fetchedResults.count == 1 {
            return fetchedResults[0]
        }
        return nil
    }
}

