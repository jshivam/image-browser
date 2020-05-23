//
//  ImagePreviewViewModelTests.swift
//  image-browserTests
//
//  Created by Shivam Jaiswal on 23/05/20.
//  Copyright © 2020 Shivam Jaiswal. All rights reserved.
//

import XCTest
@testable import image_browser

class ImagePreviewViewModelTests: XCTestCase {
    var viewModel: ImagePreviewViewModelProtocol!
    override func setUpWithError() throws {
        viewModel = ImagePreviewViewModel.init(images: dummyItems, initialIndexPath: IndexPath(row: 1, section: 0))
    }

    override func tearDownWithError() throws {
        viewModel = nil
    }

    func testnumberOfItems() {
        XCTAssertEqual(viewModel.numberOfItems(inSection: 0), 2)
    }

    func testItemAtIndexPath() {
        var path = IndexPath(row: 1, section: 0)
        XCTAssertEqual(viewModel.item(at: path).id, 2)

        path = IndexPath(row: 0, section: 0)
        XCTAssertEqual(viewModel.item(at: path).id, 11)
    }

    var dummyItems: [ImageItem] {
        return [ImageItem.init(id: 11,
                               previewURL: URL.init(string: "https://www.google.co.in/")!,
                               largeImageURL: URL.init(string: "https://www.google.co.in/")!),
                ImageItem.init(id: 2,
                               previewURL: URL.init(string: "https://www.hackingwithswift.com/100/swiftui")!,
                               largeImageURL: URL.init(string: "https://www.hackingwithswift.com/100/swiftui")!)]
    }
}
