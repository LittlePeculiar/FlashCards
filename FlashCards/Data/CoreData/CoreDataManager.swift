//
//  CoreDataManager.swift
//  FlashCards
//
//  Created by Gina Mullins on 11/13/24.
//

import UIKit
import CoreData

class CoreDataManager: NSObject {

    static let shared = CoreDataManager()
    var moc: NSManagedObjectContext!

    private override init() {
        super.init()
        moc = CoreDataStack.shared.context
    }

    func save() {
        CoreDataStack.shared.saveContext()
    }

    func deleteAllUserData() {
        // TODO
    }
}
