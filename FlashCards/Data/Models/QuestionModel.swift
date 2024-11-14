//
//  QuestionModel.swift
//  FlashCards
//
//  Created by Gina Mullins on 11/14/24.
//

import Foundation

class QuestionModel: NSObject {
    var question: String
    var answers: [AnswerModel]
    
    init(question: String = "", answers: [AnswerModel] = []) {
        self.question = question
        self.answers = answers
    }
    
    convenience init(entity: Question) {
        let question = entity.question ?? ""
        var answers: [AnswerModel] = []
        
        if let all = entity.answers {
            for item in all {
                if let answer = item as? Answer {
                    let new = AnswerModel(entity: answer)
                    answers.append(new)
                }
            }
        }
        self.init(question: question, answers: answers)
    }
}
