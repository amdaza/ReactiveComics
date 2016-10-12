//
//  TemporaryPersistentContainer.swift
//  ComicList
//
//  Created by Home on 9/10/16.
//  Copyright © 2016 Guillermo Gonzalez. All rights reserved.
//

import Foundation
import CoreData

// Necessary to save in temporary directory
internal final class TemporaryPersistentContainer: NSPersistentContainer {
    
    // Necessary to save in temporary directory
    override class func defaultDirectoryURL() -> URL {
        return URL(fileURLWithPath: NSTemporaryDirectory())
    }
    
    // UUID string -> unique ID
    init(managedObjectModel model: NSManagedObjectModel) {
        super.init(name: UUID().uuidString, managedObjectModel: model)
    }
}
