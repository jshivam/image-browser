//
//  SearchViewModelTests.swift
//  image-browserTests
//
//  Created by Shivam Jaiswal on 23/05/20.
//  Copyright © 2020 Shivam Jaiswal. All rights reserved.
//

import XCTest
@testable import image_browser

class SearchViewModelTests: XCTestCase {
    var viewModel: SearchViewModelProtocol!
    var service: SearchImagesService!
    var networkManager: NetworkManager!
    let session = URLSessionMock()
    var cache: CacheManager!
    var mockUserDefaults = UserDefaultsMock()

    override func setUpWithError() throws {
        cache = CacheManager(userDefaults: mockUserDefaults)
        networkManager = NetworkManager(session: session)
        service = SearchImagesService.init(netwrok: networkManager)
        viewModel = SearchViewModel(searchService: service, cacheManager: cache)
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testFetchImagesSuccess() {
        let fetchExpectation = expectation(description: "fetchExpectation")
        session.nextData = JSONLoader.jsonFileToData(jsonName: "search_images_valid")
        viewModel.fetchImages(keyword: "hello") { [unowned self] (result) in
            fetchExpectation.fulfill()
            switch result {
            case .fetched:
                XCTAssert(true)
                XCTAssertEqual(self.viewModel.images.count, 20)
            case .error:
                XCTAssert(false)
            }
        }
        wait(for: [fetchExpectation], timeout: 5)
    }

    func testFetchImagesFail() {
       let fetchExpectation = expectation(description: "fetchExpectation")
       viewModel.fetchImages(keyword: "hello") { (result) in
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

    func testKeywordHistoryWhenSuccess() {
        let fetchExpectation = expectation(description: "fetchExpectation")
        let fetchExpectation2 = expectation(description: "fetchExpectation")
        session.nextData = JSONLoader.jsonFileToData(jsonName: "search_images_valid")
        viewModel.fetchImages(keyword: "hello") { (result) in
            fetchExpectation.fulfill()
            switch result {
            case .fetched:
                XCTAssert(true)
            case .error:
                XCTAssert(false)
            }
        }

        viewModel.fetchImages(keyword: "hello2") { [unowned self] (result) in
            fetchExpectation2.fulfill()
            switch result {
            case .fetched:
                XCTAssert(true)
                XCTAssertEqual(self.viewModel.keywordHistory(), ["hello2", "hello"])
            case .error:
                XCTAssert(false)
            }
        }
        wait(for: [fetchExpectation, fetchExpectation2], timeout: 5)
    }

    func testKeywordHistoryWhenFail() {
        let fetchExpectation = expectation(description: "fetchExpectation")
        let fetchExpectation2 = expectation(description: "fetchExpectation")
        viewModel.fetchImages(keyword: "hello") { (result) in
            fetchExpectation.fulfill()
            switch result {
            case .fetched:
                XCTAssert(false)
            case .error:
                XCTAssert(true)
            }
        }

        viewModel.fetchImages(keyword: "hello2") { [unowned self] (result) in
            fetchExpectation2.fulfill()
            switch result {
            case .fetched:
                XCTAssert(false)
            case .error:
                XCTAssert(true)
                XCTAssertEqual(self.viewModel.keywordHistory(), [])
            }
        }
        wait(for: [fetchExpectation, fetchExpectation2], timeout: 5)
    }
}
