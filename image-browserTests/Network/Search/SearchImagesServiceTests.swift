//
//  SearchImagesServiceTests.swift
//  image-browserTests
//
//  Created by Shivam Jaiswal on 23/05/20.
//  Copyright © 2020 Shivam Jaiswal. All rights reserved.
//

import XCTest
@testable import image_browser

class SearchImagesServiceTests: XCTestCase {
    var service: SearchImagesService!
    var networkManager: NetworkManager!
    let session = URLSessionMock()

    override func setUpWithError() throws {
        networkManager = NetworkManager(session: session)
        service = SearchImagesService.init(netwrok: networkManager)
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func test_get_should_return_data() {
        let fetchExpectation = expectation(description: "fetchExpectation")
        session.nextData = JSONLoader.jsonFileToData(jsonName: "search_images_valid")
        service.fetchImages(keyword: "abc", page: 1) { (result) in
            fetchExpectation.fulfill()
            switch result {
            case .success(let items):
                XCTAssertEqual(items.count, 20)
            case .failure:
                XCTAssert(false)
            }
        }
        wait(for: [fetchExpectation], timeout: 5)
    }

    func testInvalidRespone() {
        let fetchExpectation = expectation(description: "fetchExpectation")
        session.nextData = "{}".data(using: .utf8)
        service.fetchImages(keyword: "abc", page: 1) { (result) in
            fetchExpectation.fulfill()
            switch result {
            case .success:
                XCTAssert(false)
            case .failure:
                XCTAssert(true)
            }
        }
        wait(for: [fetchExpectation], timeout: 5)
    }
}
