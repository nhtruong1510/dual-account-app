//
//  NoteObj.swift
//  IconHomeScreen
//
//  Created by user.name on 10/26/20.
//

import UIKit
import CoreData

public struct ImageData: Codable {

    public let photo: Data

    public init(photo: UIImage) {
        self.photo = photo.pngData() ?? Data()
    }
    
    func getImage() -> UIImage {
        UIImage(data: photo) ?? UIImage()
    }
}

class NoteObj: NSObject, Codable, NSCopying {
    var id: String = ""
    var createDate: Date = Date()
    var noteText: String = ""
    var noteName: String = "Remember Note"
    var colorType: ColorType = .none
    var reminderDate: Date = Date()
    var repeatType: RepeatType = .never
    var photos: [ImageData] = []

    override init() {
        super.init()
    }
    
    init(_ obj: Note) {
        self.id = obj.id ?? ""
        self.createDate = obj.createDate ?? Date()
        self.noteText = obj.noteText ?? ""
        self.noteName = obj.noteName ?? ""
        self.colorType = ColorType(rawValue: obj.colorType ?? "") ?? .none
        self.reminderDate = obj.reminderDate ?? Date()
        self.repeatType = RepeatType(rawValue: obj.repeatType ?? "") ?? .never
        
        do {
            let decoder = JSONDecoder()
            let data = try decoder.decode([ImageData].self, from: obj.photos ?? Data())
            self.photos = data
        } catch {
            print(error)
        }
    }
    
    func copy(with zone: NSZone? = nil) -> Any {
        let copy = NoteObj().with {
            $0.id = self.id
            $0.createDate = self.createDate
            $0.noteText = self.noteText
            $0.noteName = self.noteName
            $0.colorType = self.colorType
            $0.reminderDate = self.reminderDate
            $0.repeatType = self.repeatType
            $0.photos = self.photos
        }
        return copy
    }
    
}

extension NoteObj {
    func saveNote(_ isMerge: Bool = true) {
        print("save Note name: \(self.noteName), \(isMerge)")
        let minionManagedObjectContextWorker: NSManagedObjectContext =
            NSManagedObjectContext.init(concurrencyType: NSManagedObjectContextConcurrencyType.privateQueueConcurrencyType)
        minionManagedObjectContextWorker.parent = mainContextInstance

        let note = NSEntityDescription.insertNewObject(forEntityName: "Note",
                                                         into: minionManagedObjectContextWorker) as! Note
        note.id = self.id
        note.createDate = self.createDate
        note.noteText = self.noteText
        note.noteName = self.noteName
        note.colorType = self.colorType.rawValue
        note.reminderDate = self.reminderDate
        note.repeatType = self.repeatType.rawValue
        
        do {
            let encoder = JSONEncoder()
            let data = try encoder.encode(self.photos)
            note.photos = data
        } catch {
            print(error)
        }

        persistenceManager.saveWorkerContext(minionManagedObjectContextWorker)
        if isMerge {
            persistenceManager.mergeWithMainContext()
        }
        //AppSettings.createNotification(noteObj: self)
    }

    func updateNote() {
        if let note = findNote() {
            note.id = self.id
            note.createDate = self.createDate
            note.noteText = self.noteText
            note.noteName = self.noteName
            note.colorType = self.colorType.rawValue
            note.reminderDate = self.reminderDate
            note.repeatType = self.repeatType.rawValue
            do {
                let encoder = JSONEncoder()
                let data = try encoder.encode(self.photos)
                note.photos = data
            } catch {
                print(error)
            }
            persistenceManager.mergeWithMainContext()
            AppSettings.createNotification(noteObj: self)
        }
    }

    func deleteNote() {
        if let note = findNote() {
            mainContextInstance.delete(note)
            persistenceManager.mergeWithMainContext()
            //AppSettings.removeNotification(noteObj: self)
        }
    }

    func findNote() -> Note? {
        let fetchRequest =
            NSFetchRequest<NSManagedObject>(entityName: "Note")
        fetchRequest.returnsObjectsAsFaults = false
        fetchRequest.predicate = NSPredicate(format:"%K == %@", "id", self.id as CVarArg)
        var fetchedResults: Array<Note> = Array<Note>()
        do {
            fetchedResults = try  mainContextInstance.fetch(fetchRequest) as! [Note]
        } catch let fetchError as NSError {
            print("retrieveById error: \(fetchError.localizedDescription)")
            fetchedResults = Array<Note>()
        }
        if fetchedResults.count == 1 {
            return fetchedResults[0]
        }
        return nil
    }
}


