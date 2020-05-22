//
//  SearchResultsViewModel.swift
//  image-browser
//
//  Created by Shivam Jaiswal on 22/05/20.
//  Copyright © 2020 Shivam Jaiswal. All rights reserved.
//

import Foundation

protocol SearchResultsViewModelProtocol: ViewModelProtocol {
    func fetchImages(completionHandler: @escaping (FetchRequestStatus) -> Void)
    func numberOfItems(inSection section: Int) -> Int
    func item(at indexPath: IndexPath) -> ImageItem

    var fetchNextDataHandler: (() -> Void)? { get set }
    var lastVisibileIndexPath: IndexPath? { get set }
    var images: [ImageItem] { get }
}

final class SearchResultsViewModel: SearchResultsViewModelProtocol {
    private let searchService: SearchImagesServiceProtocol
    private(set) var images = [ImageItem]()
    private var currentPage = 1
    private var isFetching = false
    private let keyword: String

    var fetchNextDataHandler: (() -> Void)?
    var lastVisibileIndexPath: IndexPath? = nil {
        didSet {
            guard let indexPath = self.lastVisibileIndexPath else { return }
            if shallFetchNextData(indexPath: indexPath) {
                fetchNextDataHandler?()
            }
        }
    }

    init(searchService: SearchImagesServiceProtocol = SearchImagesService(),
         images: [ImageItem],
         keyword: String) {
        self.searchService = searchService
        self.images = images
        self.keyword = keyword
    }

    func fetchImages(completionHandler: @escaping (FetchRequestStatus) -> Void) {
        isFetching = true
        searchService.fetchImages(keyword: keyword, page: currentPage) { [weak self] result in
            guard let `self` = self else { return }
            self.isFetching = false
            switch result {
            case .failure(let error):
                completionHandler(.error(error))
            case .success(let images):
                self.images += images
                self.currentPage += 1
                completionHandler(.fetched)
            }
        }
    }

    private func shallFetchNextData(indexPath: IndexPath) -> Bool {
        let shallFetch = ((numberOfItems(inSection: indexPath.section) - 1) == indexPath.row) && !isFetching
        return shallFetch
    }
}

extension SearchResultsViewModel {
    var viewTitle: String? { return keyword }
}

extension SearchResultsViewModel {
    func numberOfItems(inSection section: Int) -> Int {
        return images.count
    }

    func item(at indexPath: IndexPath) -> ImageItem {
        return images[indexPath.row]
    }
}
