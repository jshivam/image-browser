//
//  ImageCell.swift
//  image-browser
//
//  Created by Shivam Jaiswal on 22/05/20.
//  Copyright © 2020 Shivam Jaiswal. All rights reserved.
//

import UIKit
import Stevia

class ImageCell: UICollectionViewCell {
    private let imageView = UIImageView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubViews()
        adjustSubViews()
        setupConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func addSubViews() {
        contentView.subviews(imageView)
    }

    private func adjustSubViews() {
        contentView.style {
            $0.backgroundColor = .lightGray
        }

        imageView.style {
            $0.contentMode = .scaleAspectFill
            $0.layer.cornerRadius = .cornerRadius
            $0.clipsToBounds = true
        }
    }

    private func setupConstraints() {
        imageView.fillContainer()
    }

    func configure(url: URL) {
        imageView.loadImage(url: url)
    }
}
