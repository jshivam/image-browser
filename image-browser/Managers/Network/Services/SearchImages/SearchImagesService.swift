//
//  SearchImagesService.swift
//  image-browser
//
//  Created by Shivam Jaiswal on 22/05/20.
//  Copyright © 2020 Shivam Jaiswal. All rights reserved.
//

import Foundation

protocol SearchImagesServiceProtocol {
    func fetchImages(keyword: String, page: Int, completionHandler: @escaping (Result<[ImageItem], NetworkError>) -> Void)
}

class SearchImagesService: BaseService, SearchImagesServiceProtocol {
    func fetchImages(keyword: String, page: Int, completionHandler: @escaping (Result<[ImageItem], NetworkError>) -> Void) {
        let parameters = ["key" : EndPoint.apiKey, "q" : keyword, "image_type" : "photo", "page": String(page)]

        netwrok.get(endpoint: "", parameters: parameters) { [weak self] (data, error) in
            guard let `self` = self else { return }
            self.handleResponse(data: data, error: error) { (result: Result<SearchResults, NetworkError>) in
                switch result {
                case .failure(let error):
                    completionHandler(.failure(error))
                case .success(let images):
                    images.hits.isEmpty ? completionHandler(.failure(.zeroItems("Images"))) : completionHandler(.success(images.hits))
                }
            }
        }
    }
}
