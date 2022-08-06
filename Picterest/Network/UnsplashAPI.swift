//
//  UnsplashAPI.swift
//  Picterest
//
//  Created by Mac on 2022/07/25.
//

import UIKit
import RxSwift
import RxCocoa

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
    
    func getPhotoWithRxSwift(_ page: Int) -> Observable<[RandomPhoto]> {
        let url = EndPoint.getPhoto(page).url
        
        return Observable.from([url])
            .map { url -> URLRequest in
                var request = URLRequest(url: url)
                request.httpMethod = "GET"
                return request
            }
            .flatMap { request -> Observable<(response: HTTPURLResponse, data: Data)> in
                return URLSession.shared.rx.response(request: request)
            }
            .filter { response, _ in
                return 200..<300 ~= response.statusCode
            }
            .map { _, data -> [[String: Any]] in
                guard let json = try? JSONSerialization.jsonObject(with: data, options: []),
                      let result = json as? [[String: Any]] else {
                    return []
                }
                return result
            }
            .filter { result in
                return result.count > 0
            }
            .map { objects in
                return objects.compactMap { dic -> RandomPhoto? in
                    guard let id = dic["id"] as? String,
                          let width = dic["width"] as? Int,
                          let height = dic["height"] as? Int,
                          let urls = dic["urls"] as? PhotoURL else {
                        return nil
                    }
                    return RandomPhoto(id: id, width: width, height: height, urls: urls, isFavorite: false)
                }
            }
    }
}
