//
//  HomeViewController.swift
//  FlashCards
//
//  Created by Gina Mullins on 11/13/24.
//

import UIKit
import Combine

class HomeViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var questionIndexLabel: UILabel!
    @IBOutlet weak var questionsCountLabel: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    private let viewModel = HomeViewModel()
    private var disposeBag = [AnyCancellable]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        registerCells()
        setupBinding()
        setupUI()

        Task {
            await viewModel.fetch()
        }
    }
    
    private func setupBinding() {
        viewModel.$cards
            .receive(on: DispatchQueue.main)
            .sink { [weak self] cards in
                guard let self = self else { return }
                self.questionsCountLabel.text = "\(cards.count)"
                self.collectionView.reloadData()
            }
            .store(in: &disposeBag)
        
        viewModel.$isLoading
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isLoading in
                self?.refreshActivityIndicator(isLoading: isLoading)
            }
            .store(in: &disposeBag)
    }
    
    private func setupUI() {
        self.title = "Flash Cards"
        self.view.backgroundColor = UIColor.red
        
        let add = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addCard))
        navigationItem.rightBarButtonItems = [add]
    }
    
    private func refreshActivityIndicator(isLoading: Bool) {
        view.bringSubviewToFront(activityIndicator)
        if isLoading {
            activityIndicator.startAnimating()
        } else {
            activityIndicator.stopAnimating()
        }
    }
    
    private func showAlert(title: String? = nil, message: String? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alert.addAction(cancelAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    private func deleteAlert(card: QuestionModel) {
        let title = "Are you sure?"
        let alert = UIAlertController(title: title, message: nil, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        let deleteAction = UIAlertAction(title: "Delete", style: .default, handler: { [weak self] (alert) in
            guard let self = self else { return }
            Task {
                await self.viewModel.delete(card: card)
            }
        })
        
        alert.addAction(cancelAction)
        alert.addAction(deleteAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func addCard(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let vc = storyboard.instantiateViewController(withIdentifier: "AddCardViewController") as? AddCardViewController else { return }
        vc.delegate = self
        navigationController?.present(vc, animated: true)
    }
    
    private func registerCells() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.contentInsetAdjustmentBehavior = .always
        
        let layout = CarouselFlowLayout()
        layout.itemSize = CGSizeMake(400, 600)
        layout.scrollDirection = .horizontal
        collectionView.collectionViewLayout = layout

        let customCellNib = UINib(nibName: "CardViewCell", bundle: .main)
        collectionView.register(customCellNib, forCellWithReuseIdentifier: "CardViewCell")
    }

}

extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_: UICollectionView, numberOfItemsInSection _: Int) -> Int {
        viewModel.cards.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CardViewCell", for: indexPath) as? CardViewCell else {
            return UICollectionViewCell()
        }

        // Configure the cell
        questionIndexLabel.text = "\(indexPath.row + 1) of"
        let card = viewModel.cards[indexPath.row]
        cell.configure(card: card)
        cell.delegate = self
        
        return cell
    }
}

// MARK: CardViewCellDelegate

extension HomeViewController: CardViewCellDelegate {
    func delete(card: QuestionModel) {
        deleteAlert(card: card)
    }
}

// MARK: AddCardDelegate

extension HomeViewController: AddCardDelegate {
    func dismissMe() {
        navigationController?.dismiss(animated: true)
    }
    
    func saved() {
        Task {
            await viewModel.fetch()
            dismissMe()
        }
    }
}
