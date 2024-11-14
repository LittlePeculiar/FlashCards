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
    
    init() {
        self.moc = CoreDataManager.shared.moc
    }
    
    // fetch from Core Data
    @MainActor func fetch() async {
        guard !isLoading else { return }
        
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
        cards = questions
    }

}
