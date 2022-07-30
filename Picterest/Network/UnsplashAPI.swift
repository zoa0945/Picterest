//
//  UnsplashAPI.swift
//  Picterest
//
//  Created by Mac on 2022/07/25.
//

import UIKit

enum APIError: Error {
    case invalidURL
    case alreadyDone
    case requestError
    case responseError
    case noData
    case parsingError
}

class UnsplashAPI {
    func getPhoto(_ page: Int, _ completion: @escaping (Result<[RandomPhoto], APIError>) -> Void) {
        let request = URLRequest(url: EndPoint.getPhoto(page).url)
        URLSession.request(endpoint: request, completion: completion)
    }
}
