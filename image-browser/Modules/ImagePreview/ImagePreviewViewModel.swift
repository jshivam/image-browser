//
//  ImagePreviewViewModel.swift
//  image-browser
//
//  Created by Shivam Jaiswal on 22/05/20.
//  Copyright © 2020 Shivam Jaiswal. All rights reserved.
//

import Foundation

protocol ImagePreviewViewModelProtocol {
    func numberOfItems(inSection section: Int) -> Int
    func item(at indexPath: IndexPath) -> ImageItem

    var images: [ImageItem] { get }
    var initialIndexPath: IndexPath { get }
}

class ImagePreviewViewModel: ImagePreviewViewModelProtocol {
    private(set) var images = [ImageItem]()
    let initialIndexPath: IndexPath

    init(images: [ImageItem], initialIndexPath: IndexPath) {
        self.images = images
        self.initialIndexPath = initialIndexPath
    }
}

extension ImagePreviewViewModel {
    func numberOfItems(inSection section: Int) -> Int {
        return images.count
    }

    func item(at indexPath: IndexPath) -> ImageItem {
        return images[indexPath.row]
    }
}
