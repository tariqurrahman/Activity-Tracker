//
//  CoreDataHelper.swift
//  ActivityTracker
//
//  Created by Tariqur on 11/21/20.
//

import Foundation
import UIKit
import CoreData

struct CoreDataHelper {
    
    static func container() ->  NSPersistentContainer {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            fatalError()
        }

        return appDelegate.persistentContainer
    }
   
    static let context: NSManagedObjectContext = {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            fatalError()
        }

        let persistentContainer = appDelegate.persistentContainer
        let context = persistentContainer.viewContext

        return context
    }()
    
    static func save() throws {
        try context.save()
    }
}
