//
//  UICollectionViewCell+Extensions.swift
//  image-browser
//
//  Created by Shivam Jaiswal on 22/05/20.
//  Copyright © 2020 Shivam Jaiswal. All rights reserved.
//

import UIKit

extension UICollectionView {
    func register<T: UICollectionViewCell>(ofType cellType: T.Type, bundle: Bundle? = nil) {
        let cellTypeName = String(describing: cellType)
        if bundle?.path(forResource: cellTypeName, ofType: "nib") != nil {
            register(UINib(nibName: cellTypeName, bundle: .main), forCellWithReuseIdentifier: cellTypeName)
        } else {
            register(cellType, forCellWithReuseIdentifier: cellTypeName)
        }
    }

    func register<T: UICollectionViewCell>(ofTypes cellTypes: [T.Type], bundle: Bundle? = nil) {
        cellTypes.forEach { register(ofType: $0, bundle: bundle) }
    }

    func dequeueCell<Cell: UICollectionViewCell>(ofType cellType: Cell.Type, for indexPath: IndexPath) -> Cell {
        return dequeueReusableCell(withReuseIdentifier: String(describing: cellType), for: indexPath) as! Cell
    }

    func isLastCell(for indexpath: IndexPath) -> Bool {
        return (numberOfItems(inSection: indexpath.section) - 1 ) == indexpath.row
    }
}
