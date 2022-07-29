//
//  URLSession+.swift
//  Picterest
//
//  Created by Mac on 2022/07/29.
//

import Foundation

extension URLSession {
    static var dataTasks: [URLSessionTask] = []
    
    @discardableResult
    func dataTask(_ endpoint: URLRequest, handler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
        let dataTask = dataTask(with: endpoint, completionHandler: handler)
        dataTask.resume()
        return dataTask
    }
    
    static func request<T: Decodable>(_ session: URLSession = .shared, endpoint: URLRequest, completion: @escaping (Result<T, APIError>) -> Void) {
        guard dataTasks.firstIndex(where: { task in
            task.originalRequest?.url == endpoint.url
        }) == nil else { return }
        
        let dataTask = session.dataTask(endpoint) { data, response, error in
            guard error == nil else {
                completion(.failure(.requestError))
                return
            }
            
            guard let data = data else {
                completion(.failure(.noData))
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let userData = try decoder.decode(T.self, from: data)
                completion(.success(userData))
            } catch {
                completion(.failure(.parsingError))
            }
        }
        dataTasks.append(dataTask)
    }
}
