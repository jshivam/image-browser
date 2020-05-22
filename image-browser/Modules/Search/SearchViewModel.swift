//
//  SearchViewModel.swift
//  image-browser
//
//  Created by Shivam Jaiswal on 22/05/20.
//  Copyright © 2020 Shivam Jaiswal. All rights reserved.
//

import Foundation

private struct Constants {
    static let searchHistoryLimit = 10
}

protocol SearchViewModelProtocol {
    func fetchImages(keyword: String, completionHandler: @escaping (FetchRequestStatus) -> Void)
    func keywordHistory() -> [String]
    var images: [ImageItem] { get }
}

final class SearchViewModel: SearchViewModelProtocol {
    private let searchService: SearchImagesServiceProtocol
    private let cacheManager: CacheManagerProtocol
    private (set) var images = [ImageItem]()

    init(searchService: SearchImagesServiceProtocol = SearchImagesService(),
         cacheManager: CacheManagerProtocol = CacheManager.shared ) {
        self.searchService = searchService
        self.cacheManager = cacheManager
    }

    func fetchImages(keyword: String, completionHandler: @escaping (FetchRequestStatus) -> Void) {
        searchService.fetchImages(keyword: keyword, page: 1) { [weak self] result in
            guard let `self` = self else { return }
            switch result {
            case .failure(let error):
                completionHandler(.error(error))
            case .success(let images):
                self.images = images
                self.cacheManager.append(keyword: keyword, maxSize: Constants.searchHistoryLimit)
                completionHandler(.fetched)
            }
        }
    }

    func keywordHistory() -> [String] {
        cacheManager.stringArray(for: .keywords).reversed()
    }
}
