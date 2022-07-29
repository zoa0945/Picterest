//
//  EndPoint.swift
//  Picterest
//
//  Created by Mac on 2022/07/29.
//

import Foundation

enum EndPoint {
    case getPhoto(Int)
}

extension EndPoint {
    static let accessKey = "iUtJris3bhWBn5KTyhNeOg7oOREEm8aWVkIS4jH9tVg"
    
    var url: URL {
        switch self {
        case .getPhoto(let page):
            return .makeEndPoint("?client_id=\(EndPoint.accessKey)&page=\(page)&per_page=15")
        }
    }
}

extension URL {
    static let baseURL = "https://api.unsplash.com/photos"
    
    static func makeEndPoint(_ endpoint: String) -> URL {
        return URL(string: baseURL + endpoint)!
    }
}
