//
//  UserDefautlsMock.swift
//  image-browserTests
//
//  Created by Shivam Jaiswal on 23/05/20.
//  Copyright © 2020 Shivam Jaiswal. All rights reserved.
//

import Foundation
@testable import image_browser

class UserDefaultsMock: UserDefaultsProtocol {
    var storage: [String : Any] = [:]

    func set(_ value: Any?, forKey defaultName: String) {
        storage[defaultName] = value
    }

    func stringArray(forKey: String) -> [String]? {
        return storage[forKey] as? [String]
    }
}
