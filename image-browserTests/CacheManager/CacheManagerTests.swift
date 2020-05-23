//
//  CacheManagerTests.swift
//  image-browserTests
//
//  Created by Shivam Jaiswal on 23/05/20.
//  Copyright © 2020 Shivam Jaiswal. All rights reserved.
//

import XCTest
@testable import image_browser

class CacheManagerTests: XCTestCase {
    var cache: CacheManager!
    var mockUserDefaults = UserDefaultsMock()

    override func setUpWithError() throws {
        cache = CacheManager(userDefaults: mockUserDefaults)
    }

    override func tearDownWithError() throws {
        cache = nil
    }

    func testSaveAndGetKeywords() {
        for item in ["hello", "hello", "hello1", "hello3"] {
            cache.append(keyword: item, maxSize: 2)
        }
        XCTAssertTrue(cache.stringArray(for: .keywords) == ["hello1", "hello3"])
    }
}
