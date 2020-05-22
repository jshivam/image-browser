//
//  FetchRequestStatus.swift
//  image-browser
//
//  Created by Shivam Jaiswal on 22/05/20.
//  Copyright © 2020 Shivam Jaiswal. All rights reserved.
//

import Foundation

enum FetchRequestStatus {
    case fetched
    case error(NetworkError)
}
