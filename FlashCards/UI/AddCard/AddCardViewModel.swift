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
    
    func saveCard() -> Bool {
        let request = NSFetchRequest<Question>(entityName: "Question")
        let predicate = NSPredicate(format: "question == %@", card.question)
        request.predicate = predicate
        
        var isSaved: Bool = false
        
        do {
            let results = try self.moc.fetch(request)

            var newQuestion: Question!
            if results.count == 0 {
                // add as new
                guard let entity = NSEntityDescription.entity(forEntityName: "Question", in: moc) else {
                    return false
                }
                guard let answersEntity = NSEntityDescription.entity(forEntityName: "Answer", in: moc) else {
                    return false
                }
                newQuestion = Question(entity: entity, insertInto: moc)
                newQuestion.question = card.question
                
                var newAnswers = [Answer]()
                for answer in card.answers {
                    let newAnswer = Answer(entity: answersEntity, insertInto: moc)
                    newAnswer.order = Int16(answer.order)
                    newAnswer.answer = answer.answer
                    newAnswer.isCorrect = answer.isCorrect
                    newAnswers.append(newAnswer)
                }
                newQuestion.answers = NSSet(array: newAnswers)
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
                        isSaved = true
                    } catch {
                        let nserror = error as NSError
                        fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
                    }
                } else {
                    print("question already exists")
                    print(newQuestion.question)
                    isSaved = true
                }
            }
        }
        catch { fatalError("Error saving new Fast date") }
        
        return isSaved
    }
}
