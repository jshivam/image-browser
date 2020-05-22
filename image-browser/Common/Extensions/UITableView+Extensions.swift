//
//  UITableView+Extensions.swift
//  image-browser
//
//  Created by Shivam Jaiswal on 23/05/20.
//  Copyright © 2020 Shivam Jaiswal. All rights reserved.
//

import UIKit

extension UITableView {
    func register<T: UITableViewCell>(ofType cellType: T.Type, bundle: Bundle? = nil) {
        let cellTypeName = String(describing: cellType)
        if bundle?.path(forResource: cellTypeName, ofType: "nib") != nil {
            register(UINib(nibName: cellTypeName, bundle: .main), forCellReuseIdentifier: cellTypeName)
        } else {
            register(cellType, forCellReuseIdentifier: cellTypeName)
        }
    }

    func register<T: UITableViewCell>(ofTypes cellTypes: [T.Type], bundle: Bundle? = nil) {
        cellTypes.forEach { register(ofType: $0, bundle: bundle) }
    }

    func dequeueCell<Cell: UITableViewCell>(ofType cellType: Cell.Type, for indexPath: IndexPath) -> Cell {
        return dequeueReusableCell(withIdentifier: String(describing: cellType), for: indexPath) as! Cell
    }
}
