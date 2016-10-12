//
//  VolumeEntry.swift
//  ComicList
//
//  Created by Home on 8/10/16.
//  Copyright © 2016 Guillermo Gonzalez. All rights reserved.
//

import Foundation
import CoreData

internal class VolumeEntry: NSManagedObject {
    
    @NSManaged var identifier: Int
    @NSManaged var title: String
    @NSManaged var publisher: String?
    
    var coverURL: URL? {
        get {
            return imageURL.flatMap {
                URL(string: $0)
            }
        }
        
        set {
            imageURL = newValue?.absoluteString
        }
    }
    
    @NSManaged private var imageURL: String?
    // Private for write
    @NSManaged private(set) var insertionDate: Date

    override func awakeFromInsert() {
        super.awakeFromInsert()
        
        self.insertionDate = Date()
    }
}

extension VolumeEntry {
    static func defaultFetchRequest() -> NSFetchRequest<VolumeEntry> {
        
        let result = NSFetchRequest<VolumeEntry>(entityName: "VolumeEntry")
    
        result.sortDescriptors = [
            NSSortDescriptor(key: "insertionDate", ascending: true)
        ]
        
        return result
    }
    
    static func fetchRequest(forVolumeWithIdentifier identifier: Int)
        -> NSFetchRequest<VolumeEntry> {
        
            let fetchRequest = NSFetchRequest<VolumeEntry>(entityName: "VolumeEntry")
            
            fetchRequest.predicate = NSPredicate(format: "identifier == %d", identifier)
            fetchRequest.fetchLimit = 1
            
            return fetchRequest
    }
    
    convenience init(volume: Volume, context: NSManagedObjectContext) {
        
        self.init(context: context)
        
        identifier = volume.identifier
        title = volume.title
        coverURL = volume.coverURL
        publisher = volume.publisherName
    }
}






