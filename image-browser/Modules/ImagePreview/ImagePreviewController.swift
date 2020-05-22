//
//  ImagePreviewController.swift
//  image-browser
//
//  Created by Shivam Jaiswal on 22/05/20.
//  Copyright © 2020 Shivam Jaiswal. All rights reserved.
//

import UIKit
import Stevia

private struct Constants {
    static let cellPerRow = 1
}

final class ImagePreviewController: BaseController {
    private let collectionView: UICollectionView = {
        let layout = SJColumnFlowLayout(cellsPerRow: 1)
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        return collectionView
    }()

    private let viewModel: ImagePreviewViewModel

    init(viewModel: ImagePreviewViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

   override func viewDidLoad() {
        super.viewDidLoad()
        addSubViews()
        adjustSubViews()
        setupConstraints()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        DispatchQueue.main.async {
            self.collectionView.scrollToItem(at: self.viewModel.initialIndexPath, at: .centeredHorizontally, animated: false)
        }
    }

    private func addSubViews() {
        view.subviews(collectionView)
    }

    private func adjustSubViews() {
        addDismissButton()
        collectionView.style {
            $0.backgroundColor = .white
            $0.delegate = self
            $0.dataSource = self
            $0.isPagingEnabled = true
            $0.contentInsetAdjustmentBehavior = .always
            $0.register(ofType: ImageCell.self)
        }
    }

    private func setupConstraints() {
        collectionView.fillContainer()
    }
}

extension ImagePreviewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    // MARK: collectionView
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.numberOfItems(inSection: section)
    }

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueCell(ofType: ImageCell.self, for: indexPath)
        cell.contentView.backgroundColor = .white
        cell.imageView.contentMode = .scaleAspectFit
        cell.configure(url: viewModel.item(at: indexPath).largeImageURL)
        return cell
    }
}

extension ImagePreviewController: ControllerDismissable {
    func dismissController() {
        dismiss(animated: true, completion: nil)
    }
}
