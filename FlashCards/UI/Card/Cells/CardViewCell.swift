//
//  CardViewCell.swift
//  FlashCards
//
//  Created by Gina Mullins on 11/13/24.
//

import UIKit

protocol CardViewCellDelegate: AnyObject {
    func delete(card: QuestionModel)
}

class CardViewCell: UICollectionViewCell {
    // MARK: Internal

    @IBOutlet var bgView: UIView!
    @IBOutlet var questionLabel: UILabel!
    @IBOutlet var option1Label: UILabel!
    @IBOutlet var option2Label: UILabel!
    @IBOutlet var option3Label: UILabel!
    @IBOutlet var option4Label: UILabel!
    @IBOutlet var answerLabel: UILabel!
    @IBOutlet var answerView: UIView!
    
    weak var delegate: CardViewCellDelegate?
    
    private var card = QuestionModel()
    
    func configure(card: QuestionModel) {
        self.card = card
        
        questionLabel.text = card.question
        
        if let answer = card.answers.filter({ $0.order == 1 }).first {
            option1Label.text = answer.answer
        }
        if let answer = card.answers.filter({ $0.order == 2 }).first {
            option2Label.text = answer.answer
        }
        if let answer = card.answers.filter({ $0.order == 3 }).first {
            option3Label.text = answer.answer
        }
        if let answer = card.answers.filter({ $0.order == 4 }).first {
            option4Label.text = answer.answer
        }
        
        showAnswer(show: false)
        if let answer = card.answers.filter({ $0.isCorrect == true }).first {
            answerLabel.text = answer.answer
        }
    }
    
    private func showAnswer(show: Bool) {
        answerView.isHidden = !show
        
        // todo: add animation later to only show answer with style
    }

    @IBAction func showTapped() {
        showAnswer(show: true)
    }
    
    @IBAction func deleteTapped() {
        delegate?.delete(card: self.card)
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        
        bgView.layer.cornerRadius = 10
        bgView.clipsToBounds = true
        bgView.layer.borderColor = UIColor.blue.cgColor
        bgView.layer.borderWidth = 1.0
        bgView.backgroundColor = UIColor.white
        
        questionLabel.layer.cornerRadius = 10
        questionLabel.layer.borderWidth = 1
        questionLabel.layer.borderColor = UIColor.blue.withAlphaComponent(0.5).cgColor
        
        answerView.layer.cornerRadius = 10
        answerView.layer.borderWidth = 1
        answerView.layer.borderColor = UIColor.blue.withAlphaComponent(0.5).cgColor
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        questionLabel.text = nil
        option1Label.text = nil
        option2Label.text = nil
        option3Label.text = nil
        option4Label.text = nil
        answerLabel.text = nil
    }
    
}
