//
//  UnsplashAPI.swift
//  Picterest
//
//  Created by Mac on 2022/07/25.
//

import UIKit

class UnsplashAPI {
    private let accessKey = "iUtJris3bhWBn5KTyhNeOg7oOREEm8aWVkIS4jH9tVg"
    private var dataTasks: [URLSessionTask] = []
    
    func getPhoto(_ page: Int, _ completion: @escaping (Result<[RandomPhoto], Error>) -> Void) {
        guard let url = URL(string: "https://api.unsplash.com/photos?page=\(page)&client_id=\(accessKey)&per_page=15"),
              dataTasks.firstIndex(
                where: { task in
                  task.originalRequest?.url == url
                }
              ) == nil else {
            return
        }
        
        let request = URLRequest(url: url)
        
        let dataTask = URLSession.shared.dataTask(with: request) { data, response, error in
            guard error == nil,
                  let data = data else {
                return
            }
            
            let decoder = JSONDecoder()
            do {
                let photo = try decoder.decode([RandomPhoto].self, from: data)
                completion(.success(photo))
            } catch {
                
            }
        }
        dataTask.resume()
        dataTasks.append(dataTask)
    }
}
