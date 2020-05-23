//
//  Network.swift
//  image-browserTests
//
//  Created by Shivam Jaiswal on 23/05/20.
//  Copyright © 2020 Shivam Jaiswal. All rights reserved.
//

import XCTest
@testable import image_browser

class NetworkManagerTests: XCTestCase {
    var httpClient: NetworkManager!
    let session = URLSessionMock()

    override func setUpWithError() throws {
        httpClient = NetworkManager(session: session)
    }

    override func tearDownWithError() throws {
        httpClient = nil
    }

    func testResumecalled() {
        let fetchExpectation = expectation(description: "fetchExpectation")
        let dataTask = URLSessionDataTaskMock()
        session.nextDataTask = dataTask
        guard let _ = URL(string: "https://mockurl") else { fatalError("URL can't be empty") }
        httpClient.get(endpoint: "", parameters: [:]) { (_, _) in
            fetchExpectation.fulfill()
        }
        XCTAssert(dataTask.resumeWasCalled)
        wait(for: [fetchExpectation], timeout: 5)
    }

    func testErrorResponse() {
        let fetchExpectation = expectation(description: "fetchExpectation")
        session.nextError = NetworkError.error(NetworkError.standardError)
        httpClient.get(endpoint: "", parameters: [:]) { (data, error) in
            fetchExpectation.fulfill()
            XCTAssertNotNil(error)
            XCTAssertNil(data)
        }
        wait(for: [fetchExpectation], timeout: 5)
    }

    func testDefaultResponse() {
        let fetchExpectation = expectation(description: "fetchExpectation")
        httpClient.get(endpoint: "", parameters: [:]) { (data, error) in
            fetchExpectation.fulfill()
            XCTAssertNotNil(error)
            XCTAssertNil(data)
        }
        wait(for: [fetchExpectation], timeout: 5)
    }

    func test_get_should_return_data() {
        let fetchExpectation = expectation(description: "fetchExpectation")

        let expectedData = "{}".data(using: .utf8)
        session.nextData = expectedData
        httpClient.get(endpoint: "", parameters: [:]) { (data, _) in
            fetchExpectation.fulfill()
            XCTAssertNotNil(data)
        }
        wait(for: [fetchExpectation], timeout: 5)
    }
}
