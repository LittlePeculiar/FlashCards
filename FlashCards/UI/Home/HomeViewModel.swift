//
//  HomeViewModel.swift
//  FlashCards
//
//  Created by Gina Mullins on 11/13/24.
//

import Foundation
import Combine
import CoreData

class HomeViewModel {
    @Published var cards: [QuestionModel] = []
    @Published var isLoading: Bool = false
    @Published var showError: Bool = false
    
    var moc: NSManagedObjectContext!
    var isShuffled: Bool = false
    
    init() {
        self.moc = CoreDataManager.shared.moc
    }
    
    // fetch from Core Data
    @MainActor func fetch() async {
        guard !isLoading else { return }
        
        isLoading = true
        var questions = [QuestionModel]()
        let request = NSFetchRequest<Question>(entityName: "Question")

        do {
            let results = try moc.fetch(request)
            for result in results {
                let model = QuestionModel(entity: result)
                questions.append(model)
            }
        }
        catch { fatalError("Error fetching Fast Dates") }
        cards = isShuffled ? questions : questions.shuffled()
        isLoading = false
        isShuffled = true
    }
    
    // fetch from Core Data
    @MainActor func delete(card: QuestionModel) async {
        let request = NSFetchRequest<Question>(entityName: "Question")
        let predicate = NSPredicate(format: "question == %@", card.question)
        request.predicate = predicate
        
        do {
            let results = try self.moc.fetch(request)

            if results.count == 1 {
                for entity in results {
                    self.moc.delete(entity)
                }
                await fetch()
            }
        }
        catch { fatalError("Error saving new Fast date") }
    }

}
