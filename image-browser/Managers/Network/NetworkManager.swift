//
//  NetworkManager.swift
//  image-browser
//
//  Created by Shivam Jaiswal on 22/05/20.
//  Copyright © 2020 Shivam Jaiswal. All rights reserved.
//

import Foundation

protocol NetworkManagerProtocol {
    typealias completeClosure = ( _ data: Data?, _ error: NetworkError?)->Void
    func get(endpoint: String, parameters: [String : String], callback: @escaping completeClosure)
}

class NetworkManager: NetworkManagerProtocol {
    static let shared = NetworkManager()
    private let session: URLSessionProtocol
    private let baseURL: String

    init(session: URLSessionProtocol = URLSession.shared,
         baseURL: String = EndPoint.baseURL) {
        self.session = session
        self.baseURL = baseURL
    }

    func get(endpoint: String, parameters: [String : String], callback: @escaping completeClosure ) {
        let urlString = endpoint.hasPrefix(baseURL) ? endpoint : baseURL + endpoint

        guard var components = URLComponents(string: urlString) else { callback(nil, .invlaidURL(endpoint)); return }
        components.queryItems = parameters.map { URLQueryItem(name: $0.key, value: $0.value) }
        components.percentEncodedQuery = components.percentEncodedQuery?.replacingOccurrences(of: "+", with: "%2B")

        guard let url = components.url else { callback(nil, .invlaidURL(endpoint)); return }

        let request = URLRequest(url: url)
        let task = session.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                if let error = error {
                    callback(nil, .error(error))
                } else if let data = data {
                    callback(data, nil)
                } else {
                    callback(nil, .standardError)
                }
            }
        }
        task.resume()
    }
}

// Protocol for MOCK/Real
protocol URLSessionProtocol {
    typealias DataTaskResult = (Data?, URLResponse?, Error?) -> Void
    func dataTask(with request: URLRequest, completionHandler: @escaping DataTaskResult) -> URLSessionDataTaskProtocol
}

protocol URLSessionDataTaskProtocol {
    func resume()
}

//MARK: Conform the protocol
extension URLSession: URLSessionProtocol {
    func dataTask(with request: URLRequest, completionHandler: @escaping URLSessionProtocol.DataTaskResult) -> URLSessionDataTaskProtocol {
        return dataTask(with: request, completionHandler: completionHandler) as URLSessionDataTask
    }
}

extension URLSessionDataTask: URLSessionDataTaskProtocol {}
