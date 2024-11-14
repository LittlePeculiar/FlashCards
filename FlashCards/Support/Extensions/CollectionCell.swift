//
//  CollectionCell.swift
//  FlashCards
//
//  Created by Gina Mullins on 11/13/24.
//

import UIKit

extension UICollectionViewCell {
    static var cellIdentifier: String {
        String(describing: self)
    }

    static func registerWithCollectionView(collectionView: UICollectionView) {
        collectionView.register(UINib(nibName: cellIdentifier, bundle: nil), forCellWithReuseIdentifier: cellIdentifier)
    }
}
