//
//  UnsplashAPI.swift
//  Picterest
//
//  Created by Mac on 2022/07/25.
//

import UIKit

class UnsplashAPI {
    private let accessKey = "iUtJris3bhWBn5KTyhNeOg7oOREEm8aWVkIS4jH9tVg"
    
    func getPhoto(_ completion: @escaping (Result<[RandomPhoto], Error>) -> Void) {
        guard let url = URL(string: "https://api.unsplash.com/photos/random?client_id=\(accessKey)&count=15") else {
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
    }
}
