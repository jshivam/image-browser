//
//  SearchResultsController.swift
//  image-browser
//
//  Created by Shivam Jaiswal on 22/05/20.
//  Copyright © 2020 Shivam Jaiswal. All rights reserved.
//

import UIKit
import Stevia

private struct Constants {
    static let cellPerRow = 3
    static let cellInBetweenPadding: CGFloat = 10
    static let cellVerticalPadding: CGFloat = 10
    static let cellSidePadding: CGFloat = 10
    static let sectionInset: UIEdgeInsets = UIEdgeInsets(top: 0, left: cellSidePadding, bottom: 0, right: cellSidePadding)
}

final class SearchResultsController: BaseController {
    private let collectionView: UICollectionView = {
        let layout = SJColumnFlowLayout(cellsPerRow: Constants.cellPerRow,
                                        minimumInteritemSpacing: Constants.cellInBetweenPadding,
                                        minimumLineSpacing: Constants.cellVerticalPadding,
                                        sectionInset: Constants.sectionInset)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        return collectionView
    }()

    private let viewModel: SearchResultsViewModelProtocol

    init(viewModel: SearchResultsViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = viewModel.viewTitle
        addSubViews()
        adjustSubViews()
        setupConstraints()
    }

    private func addSubViews() {
        view.subviews(collectionView)
    }

    private func adjustSubViews() {
        collectionView.style {
            $0.backgroundColor = .white
            $0.delegate = self
            $0.dataSource = self
            $0.contentInsetAdjustmentBehavior = .always
            $0.register(ofType: ImageCell.self)
        }
    }

    private func setupConstraints() {
        collectionView.fillContainer()
    }

    private func fetchNextImages() {
        viewModel.fetchImages { [weak self] status in
            guard let `self` = self else { return }
            switch status {
            case .error(let error):
                print(error)
            case .fetched:
                self.collectionView.reloadData()
            }
        }
    }
}

extension SearchResultsController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    // MARK: collectionView
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.numberOfItems(inSection: section)
    }

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueCell(ofType: ImageCell.self, for: indexPath)
        cell.configure(url: viewModel.item(at: indexPath).previewURL)
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        viewModel.lastVisibileIndexPath = indexPath
        viewModel.fetchNextDataHandler = { [weak self] in self?.fetchNextImages() }
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        pushImagePreviewController(images: viewModel.images, indexPath: indexPath)
    }

    private func pushImagePreviewController(images: [ImageItem], indexPath: IndexPath) {
        let viewModel = ImagePreviewViewModel(images: images, initialIndexPath: indexPath)
        let controller = ImagePreviewController(viewModel: viewModel)
        let navigation = UINavigationController(rootViewController: controller)
        present(navigation, animated: true, completion: nil)
    }
}
