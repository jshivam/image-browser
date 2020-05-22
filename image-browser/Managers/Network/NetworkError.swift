//
//  NetworkError.swift
//  image-browser
//
//  Created by Shivam Jaiswal on 22/05/20.
//  Copyright © 2020 Shivam Jaiswal. All rights reserved.
//

import Foundation

enum NetworkError: Error {
    case invlaidURL(String)
    case standardError
    case parsingError(Error)
    case error(Error)
    case zeroItems(String)
}

extension NetworkError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .invlaidURL(let url):
            return "Invalid URL: \(url)"
        case .standardError:
            return "Oops! Somthing went wrong !!"
        case .parsingError(let error), .error(let error):
            return error.localizedDescription
        case .zeroItems(let keyword):
            return "We don't have any \(keyword) to show now!"
        }
    }
}
