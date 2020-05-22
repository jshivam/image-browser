//
//  ControllerDismissable.swift
//  image-browser
//
//  Created by Shivam Jaiswal on 22/05/20.
//  Copyright © 2020 Shivam Jaiswal. All rights reserved.
//

import UIKit

@objc protocol ControllerDismissable: NSObjectProtocol {
    func dismissController()
}

extension ControllerDismissable where Self: UIViewController {
    func addDismissButton() {
        let button = UIBarButtonItem.init(barButtonSystemItem: .cancel, target: self, action: #selector(dismissController))
        navigationItem.leftBarButtonItem = button
    }
}
