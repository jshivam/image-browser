//
//  SearchResult.swift
//  image-browser
//
//  Created by Shivam Jaiswal on 22/05/20.
//  Copyright © 2020 Shivam Jaiswal. All rights reserved.
//

import Foundation

struct SearchResults: Codable {
    let hits: [ImageItem]
}

struct ImageItem: Codable {
    let id: Int
    let previewURL: URL
    let largeImageURL: URL
}
