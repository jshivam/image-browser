//
//  SearchViewModel.swift
//  image-browser
//
//  Created by Shivam Jaiswal on 22/05/20.
//  Copyright © 2020 Shivam Jaiswal. All rights reserved.
//

import Foundation

protocol SearchViewModelProtocol {
    func fetchImages(keyword: String, completionHandler: @escaping (FetchRequestStatus) -> Void)
    var images: [ImageItem] { get }
}

final class SearchViewModel: SearchViewModelProtocol {
    private let searchService: SearchImagesServiceProtocol
    private (set) var images = [ImageItem]()

    init(searchService: SearchImagesServiceProtocol = SearchImagesService()) {
        self.searchService = searchService
    }

    func fetchImages(keyword: String, completionHandler: @escaping (FetchRequestStatus) -> Void) {
        searchService.fetchImages(keyword: keyword, page: 1) { [weak self] result in
            guard let `self` = self else { return }
            switch result {
            case .failure(let error):
                completionHandler(.error(error))
            case .success(let images):
                self.images = images
                completionHandler(.fetched)
            }
        }
    }
}
