//
//  CacheManager.swift
//  image-browser
//
//  Created by Shivam Jaiswal on 23/05/20.
//  Copyright © 2020 Shivam Jaiswal. All rights reserved.
//

import Foundation

protocol CacheManagerProtocol {
    func append(keyword: String, maxSize: Int)
    func stringArray(for key: UserDefaults.Key) -> [String]
}

class CacheManager: CacheManagerProtocol {
    static let shared = CacheManager()
    private let userDefaults: UserDefaultsProtocol

    init(userDefaults: UserDefaultsProtocol = UserDefaults.standard) {
        self.userDefaults = userDefaults
    }

    func append(keyword: String, maxSize: Int) {
        var history = stringArray(for: UserDefaults.Key.keywords)
        guard !history.contains(keyword) else { return }
        history.append(keyword)
        if history.count > maxSize { history.remove(at: 0) }
        userDefaults.set(history, forKey: UserDefaults.Key.keywords.rawValue)
    }

    func stringArray(for key: UserDefaults.Key) -> [String] {
        return userDefaults.stringArray(forKey: key.rawValue) ?? []
    }
}

extension UserDefaults {
    enum Key: String {
        case keywords
    }
}

protocol UserDefaultsProtocol {
    func set(_ value: Any?, forKey defaultName: String)
    func stringArray(forKey: String) -> [String]?
}

extension UserDefaults: UserDefaultsProtocol {}
