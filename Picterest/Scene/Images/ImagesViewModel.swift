//
//  ImagesViewModel.swift
//  Picterest
//
//  Created by Mac on 2022/07/26.
//

import UIKit

class ImagesViewModel {
    private let networkService = UnsplashAPI()
    
    func getImageURLs(_ completion: @escaping (Result<[RandomPhoto], Error>) -> Void) {
        return networkService.getPhoto(completion)
    }
}
