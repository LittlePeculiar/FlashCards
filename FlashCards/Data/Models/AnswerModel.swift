//
//  AnswerModel.swift
//  FlashCards
//
//  Created by Gina Mullins on 11/14/24.
//

import Foundation

class AnswerModel: NSObject {
    var order: Int
    var answer: String
    var isCorrect: Bool
    
    init(order: Int = 0, answer: String = "", isCorrect: Bool = false) {
        self.order = order
        self.answer = answer
        self.isCorrect = isCorrect
    }
    
    convenience init(entity: Answer) {
        let order = Int(entity.order)
        let answer = entity.answer ?? ""
        let isCorrect = entity.isCorrect
        
        self.init(order: order, answer: answer, isCorrect: isCorrect)
    }
}
