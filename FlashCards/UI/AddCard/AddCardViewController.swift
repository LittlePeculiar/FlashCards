//
//  AddCardViewController.swift
//  FlashCards
//
//  Created by Gina Mullins on 11/13/24.
//

import UIKit
import CoreData

protocol AddCardDelegate: AnyObject {
    func dismissMe()
    func saved()
}

class AddCardViewController: UIViewController {
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet var question: UITextView!
    @IBOutlet var answer1: UITextView!
    @IBOutlet var answer2: UITextView!
    @IBOutlet var answer3: UITextView!
    @IBOutlet var answer4: UITextView!
    
    @IBOutlet var correct1: UISwitch!
    @IBOutlet var correct2: UISwitch!
    @IBOutlet var correct3: UISwitch!
    @IBOutlet var correct4: UISwitch!
    
    private let viewModel = AddCardViewModel()
    private var selectedTextView = UITextView()
    weak var delegate: AddCardDelegate?
    
    var isValid: Bool {
        let answerSelected = viewModel.card.answers.filter({
            $0.isCorrect == true
        }).count == 1
        
        return !viewModel.card.question.isEmpty && viewModel.card.answers.count == 4 && answerSelected
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()

        answer1.delegate = self
        answer2.delegate = self
        answer3.delegate = self
        answer4.delegate = self
        
        clear()
        setupUI()
    }
    
    private func setupUI() {
        // add observers for keyboard notification
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillHide(noti:)),
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow(noti:)),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
        
        question.layer.cornerRadius = 10
        question.layer.borderWidth = 1
        question.layer.borderColor = UIColor.red.withAlphaComponent(0.5).cgColor
        
        answer1.layer.cornerRadius = 10
        answer1.layer.borderWidth = 1
        answer1.layer.borderColor = UIColor.red.withAlphaComponent(0.5).cgColor
        
        answer2.layer.cornerRadius = 10
        answer2.layer.borderWidth = 1
        answer2.layer.borderColor = UIColor.red.withAlphaComponent(0.5).cgColor
        
        answer3.layer.cornerRadius = 10
        answer3.layer.borderWidth = 1
        answer3.layer.borderColor = UIColor.red.withAlphaComponent(0.5).cgColor
        
        answer4.layer.cornerRadius = 10
        answer4.layer.borderWidth = 1
        answer4.layer.borderColor = UIColor.red.withAlphaComponent(0.5).cgColor
    }
    
    private func createCard() {
        viewModel.card.question = ""
        viewModel.card.answers.removeAll()
        
        if let text = question.text, !text.isEmpty {
            viewModel.card.question = text
        }
        
        if let text = answer1.text, !text.isEmpty {
            let answer = AnswerModel(
                order: 1,
                answer: text,
                isCorrect: correct1.isOn
            )
            viewModel.card.answers.append(answer)
        }
        
        if let text = answer2.text, !text.isEmpty {
            let answer = AnswerModel(
                order: 2,
                answer: text,
                isCorrect: correct2.isOn
            )
            viewModel.card.answers.append(answer)
        }
        
        if let text = answer3.text, !text.isEmpty {
            let answer = AnswerModel(
                order: 3,
                answer: text,
                isCorrect: correct3.isOn
            )
            viewModel.card.answers.append(answer)
        }
        
        if let text = answer4.text, !text.isEmpty {
            let answer = AnswerModel(
                order: 4,
                answer: text,
                isCorrect: correct4.isOn
            )
            viewModel.card.answers.append(answer)
        }
        
        if isValid {
            if viewModel.saveCard() {
                delegate?.saved()
            }
        } else {
            showAlert(title: "Oops! Something went wrong",
                      message: "One or more fields are empty or answer not selected"
            )
        }
        
    }
    
    private func showAlert(title: String? = nil, message: String? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alert.addAction(cancelAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    private func clear() {
        question.text = ""
        answer1.text = ""
        answer2.text = ""
        answer3.text = ""
        answer4.text = ""
        
        correct1.isOn = false
        correct2.isOn = false
        correct3.isOn = false
        correct4.isOn = false
    }
    
    @IBAction func SaveCard(_ sender: Any) {
        createCard()
    }
    
    @IBAction func ClearCard(_ sender: Any) {
        clear()
    }
    
    @IBAction func dismissMe(_ sender: Any) {
        delegate?.dismissMe()
    }
    
    @IBAction func switchValueChange(_ sender: UISwitch) {
        // todo: fix this - bad coding
        
        if sender == correct1 {
            correct1.isOn = sender.isOn
            correct2.isOn = false
            correct3.isOn = false
            correct4.isOn = false
        }
        if sender == correct2 {
            correct2.isOn = sender.isOn
            correct1.isOn = false
            correct3.isOn = false
            correct4.isOn = false
        }
        if sender == correct3 {
            correct3.isOn = sender.isOn
            correct1.isOn = false
            correct2.isOn = false
            correct4.isOn = false
        }
        if sender == correct4 {
            correct4.isOn = sender.isOn
            correct1.isOn = false
            correct2.isOn = false
            correct3.isOn = false
        }
    }

}

extension AddCardViewController: UITextViewDelegate {
    
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        selectedTextView = textView
        return true
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        self.view.endEditing(true)
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            self.view.endEditing(true)
            return false
        }
        return true
    }
}

extension AddCardViewController {
    @objc func keyboardWillHide(noti: Notification) {
        let contentInsets = UIEdgeInsets.zero
        scrollView.contentInset = contentInsets
        scrollView.scrollIndicatorInsets = contentInsets
        scrollView.isScrollEnabled = true
        scrollView.scrollsToTop = true
    }

    @objc func keyboardWillShow(noti: Notification) {
        guard let userInfo = noti.userInfo else { return }
        guard var keyboardFrame: CGRect = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else {
            return
        }
        keyboardFrame = self.view.convert(keyboardFrame, from: nil)

        var contentInset: UIEdgeInsets = scrollView.contentInset
        contentInset.bottom = keyboardFrame.size.height
        scrollView.contentInset = contentInset
        scrollView.scrollIndicatorInsets = contentInset

        DispatchQueue.main.async {
            let height = keyboardFrame.size.height
            self.scrollView.setContentOffset(CGPoint(x: 0.0, y: 0.5*height), animated: true)
        }

        scrollView.isScrollEnabled = false
    }
}
