//
//  JSONLoader.swift
//  image-browserTests
//
//  Created by Shivam Jaiswal on 23/05/20.
//  Copyright © 2020 Shivam Jaiswal. All rights reserved.
//

@testable import image_browser
import Foundation

class JSONLoader {
    class func jsonFileToDict(jsonName: String) -> [String: AnyObject]? {
        if let path = Bundle(for: JSONLoader.self).path(forResource: jsonName, ofType: "json") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                let jsonResult = try JSONSerialization.jsonObject(with: data, options: .mutableLeaves)
                if let jsonResult = jsonResult as? [String: AnyObject] {
                    return jsonResult
                }
            } catch {
                return nil
            }
        }
        return nil
    }

    class func jsonFileToData(jsonName: String) -> Data? {

        if let path = Bundle(for: JSONLoader.self).path(forResource: jsonName, ofType: "json") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                return data
            } catch {
                return nil
            }
        }
        return nil
    }
}
