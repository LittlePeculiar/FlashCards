//
//  AddCardViewModel.swift
//  FlashCards
//
//  Created by Gina Mullins on 11/13/24.
//

import Foundation
import CoreData

class AddCardViewModel {
    var card = QuestionModel()
    var moc: NSManagedObjectContext!
    
    init() {
        self.moc = CoreDataManager.shared.moc
    }
    
    func saveCard() {
        let request = NSFetchRequest<Question>(entityName: "Question")
        
        do {
            let results = try self.moc.fetch(request)

            var newQuestion: Question!
            if results.count == 0 {
                // add as new
                guard let entity = NSEntityDescription.entity(forEntityName: "Question", in: moc) else { return }
                newQuestion = Question(entity: entity, insertInto: moc)
                newQuestion.question = card.question
                newQuestion.answers = NSSet(array: card.answers)
            } else {
                // overwrite
                if let result = results.first {
                    newQuestion = result
                }
            }
            if newQuestion != nil {
                if moc.hasChanges {
                    do {
                        try moc.save()
                    } catch {
                        let nserror = error as NSError
                        fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
                    }
                }
            }
        }
        catch { fatalError("Error saving new Fast date") }
    }
}
