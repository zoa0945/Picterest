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
            .map { _, data -> [RandomPhoto] in
                let decoder = JSONDecoder()
                do {
                    let randomPhoto = try decoder.decode([RandomPhoto].self, from: data)
                    return randomPhoto
                } catch let error {
                    print("parsing Error: \(error.localizedDescription)")
                    return []
                }
            }
    }
}
