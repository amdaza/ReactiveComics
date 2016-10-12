//
//  VolumeContainer.swift
//  ComicList
//
//  Created by Home on 8/10/16.
//  Copyright © 2016 Guillermo Gonzalez. All rights reserved.
//

import Foundation
import CoreData
import RxSwift

/// A collection of volumes persisted in disk
public protocol VolumeContainerType {
    
    
    /// Loads the corresponding container store
    func load() -> Observable<Void>
    
    /// Saves an array of volumes in the container
    func save(volumes: [Volume]) -> Observable<Void>
    
    /// Deletes the volume with a given identifier
    func delete(volumeWithIdentifier: Int) -> Observable<Void>
    
    /// Determines if the container contains a volume 
    /// with a given identifier
    func contains(volumeWithIdentifier: Int) -> Bool
    
    /// Returns all the volumes in the container
    func all() -> VolumeResultsType
}


final public class VolumeContainer {
    
    // MARK: - Properties
    
    fileprivate let container: NSPersistentContainer
    
    // MARK: - Initialization
    
    private init(container: NSPersistentContainer) {
        self.container = container
        // Necessary for propaggate changes from background to main thread
        self.container.viewContext.automaticallyMergesChangesFromParent = true
    }
    
    public convenience init(name: String){
        // Necessary because, by default, model will be searched in App bundle, 
        // not in framework bundle
        // For unit tests, check Test bundle in Model (Target Membership)
        
        // Bundle -> Represents package of application
        let bundle = Bundle(for: VolumeContainer.self)
        
        // If it receives nil, uses main application bundle
        let model = NSManagedObjectModel.mergedModel(from: [bundle])!
        
        let container = NSPersistentContainer(name: name,
                                              managedObjectModel: model)
        self.init(container: container)
    }
    
    // Static func needed, cannot be "init temporary"
    public static func temporary() -> VolumeContainer {
        let bundle = Bundle(for: VolumeContainer.self)
        
        // If it receives nil, uses main application bundle
        let model = NSManagedObjectModel.mergedModel(from: [bundle])!
        
        let container = TemporaryPersistentContainer(managedObjectModel: model)
        
        return VolumeContainer(container: container)
    }
}

extension VolumeContainer: VolumeContainerType {
    
    public func load() -> Observable<Void> {
        return Observable.create { observer in
            
            self.container.loadPersistentStores { _, error in
                if let error = error {
                    observer.onError(error)
                } else {
                    observer.onNext()
                    observer.onCompleted()
                }
            }
            
            return Disposables.create()
        }
    }
    
    public func all() -> VolumeResultsType {
        return VolumeResults(fetchRequest: VolumeEntry.defaultFetchRequest(),
                             context: container.viewContext)
    }
    
    public func contains(volumeWithIdentifier identifier: Int) -> Bool {
        let fetchRequest =
            VolumeEntry.fetchRequest(forVolumeWithIdentifier: identifier)
      
        let count =
            (try? container.viewContext.count(for: fetchRequest)) ?? 0
        
        return count > 0
    }
    
    public func delete(volumeWithIdentifier identifier: Int) -> Observable<Void> {
        return performBackgroundTask { context in
            let fetchRequest =
                VolumeEntry.fetchRequest(forVolumeWithIdentifier: identifier)
            
            let entries = try context.fetch(fetchRequest)
            
            if entries.count > 0 {
                context.delete(entries[0])
                try context.save()
            }
        }
    }
    
    public func save(volumes: [Volume]) -> Observable<Void> {
        return performBackgroundTask { context in
            let _ = volumes.map {
                VolumeEntry(volume: $0, context: context)
            }
            try context.save()
        }
    }
    
    private func performBackgroundTask(_ task:
        @escaping (NSManagedObjectContext) throws -> Void) -> Observable<Void> {
        
        // To explicitly create closure references
        // Would be necessary to avoid ciclic references
        // Example: if Observable were an attribute to class
        // return Observable.create { [weak self] observer in
        
        return Observable.create { observer in
            
            self.container.performBackgroundTask { context in
                do {
                    try task(context)
                    observer.onNext()
                    observer.onCompleted()
                } catch {
                    observer.onError(error)
                }
            }
            
            // No cancellable
            // Return a disposable which does nothing
            return Disposables.create()
        }
    }
    
}









