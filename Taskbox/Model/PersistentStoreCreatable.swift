//
//  PersistentStoreCreatable.swift
//  Taskbox
//
//  Created by Hamon Riazy on 05/08/2018.
//  Copyright © 2018 Hamon Riazy. All rights reserved.
//

import Foundation
import CoreData

protocol PersistentStoreCreatable {
    static func entityDescription(for context: NSManagedObjectContext) -> NSEntityDescription?
    static func newObject(for context: NSManagedObjectContext) throws -> Self
}

extension PersistentStoreCreatable {
    
    static func entityDescription(for context: NSManagedObjectContext) -> NSEntityDescription? {
        return NSEntityDescription.entity(forEntityName: String(describing: self), in: context)
    }
    
    static func newObject(for context: NSManagedObjectContext) throws -> Self {
        guard let entity = entityDescription(for: context),
            let newObject = NSManagedObject(entity: entity, insertInto: context) as? Self else {
                throw PersistenceError.CreateNewMOError
        }
        return newObject
    }
    
}
