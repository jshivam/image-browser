//
//  LoaderView.swift
//  image-browser
//
//  Created by Shivam Jaiswal on 22/05/20.
//  Copyright © 2020 Shivam Jaiswal. All rights reserved.
//

import UIKit

class LoaderView: UIView {
    let loader: UIActivityIndicatorView = {
        let loader = UIActivityIndicatorView()
        loader.color = .gray
        loader.startAnimating()
        return loader
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setup() {
        addSubview(loader)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        loader.frame = self.bounds
    }

    var preferredHeight: CGFloat {
        let height = 2 * .sidePadding + loader.intrinsicContentSize.height
        return height
    }
}
