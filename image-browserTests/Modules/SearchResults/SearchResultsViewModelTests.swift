//
//  SearchResultsViewModelTests.swift
//  image-browserTests
//
//  Created by Shivam Jaiswal on 23/05/20.
//  Copyright © 2020 Shivam Jaiswal. All rights reserved.
//

import XCTest
@testable import image_browser

class SearchResultsViewModelTests: XCTestCase {
    var viewModel: SearchResultsViewModelProtocol!
    var service: SearchImagesService!
    var networkManager: NetworkManager!
    let session = URLSessionMock()

    override func setUpWithError() throws {
        networkManager = NetworkManager(session: session)
        service = SearchImagesService.init(netwrok: networkManager)

        viewModel = SearchResultsViewModel(searchService: service, images: dummyItems, keyword: "hello")
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

    func testFetchImagesSuccess() {
        let fetchExpectation = expectation(description: "fetchExpectation")
        session.nextData = JSONLoader.jsonFileToData(jsonName: "search_images_valid")
        viewModel.fetchImages { (result) in
            fetchExpectation.fulfill()
            switch result {
            case .fetched:
                XCTAssert(true)
                XCTAssertEqual(self.viewModel.images.count, 22)
            default:
                XCTAssert(false)
            }
        }

        wait(for: [fetchExpectation], timeout: 5)
    }

    func testFetchImagesFail() {
        let fetchExpectation = expectation(description: "fetchExpectation")

        viewModel.fetchImages { (result) in
            fetchExpectation.fulfill()
            switch result {
            case .error:
                XCTAssert(true)
            default:
                XCTAssert(false)
            }
        }

        wait(for: [fetchExpectation], timeout: 5)
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
