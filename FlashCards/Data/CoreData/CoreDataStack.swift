//
//  CoreDataStack.swift
//  FlashCards
//
//  Created by Gina Mullins on 11/13/24.
//

import UIKit
import CoreData

class CoreDataStack: NSObject {
    
    static let shared = CoreDataStack()
    private override init() {}


    // MARK: - Core Data stack

    lazy var context: NSManagedObjectContext = {
        return CoreDataStack.shared.container.viewContext
    }()

    lazy var container: NSPersistentContainer = {

        let persistentContainer = NSPersistentContainer(name: "FlashCards")
        persistentContainer.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                print("Unable to Load Persistent Store")
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
            if let path = storeDescription.url {
                print("CoreData: \(path))")
            }
        })
        return persistentContainer
    }()


    // MARK: - Core Data Saving support

    func saveContext () {
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

}


