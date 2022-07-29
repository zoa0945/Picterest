//
//  SceneViewModel.swift
//  Picterest
//
//  Created by Mac on 2022/07/26.
//

import UIKit
import CoreData

class ImagesViewModel {
    private let networkService = UnsplashAPI()
    
    private let appdelegate = UIApplication.shared.delegate as! AppDelegate
    private lazy var context = appdelegate.persistentContainer.viewContext
    
    func getImageURLs(_ page: Int, _ completion: @escaping (Result<[RandomPhoto], APIError>) -> Void) {
        return networkService.getPhoto(page, completion)
    }
    
    func saveFileManagerData(_ randomPhoto: RandomPhoto) {
        PhotoFileManager.shared.saveFileManagerData(randomPhoto)
    }
    
    func saveCoreData(_ randomPhoto: RandomPhoto, _ memo: String, _ size: [Int]) {
        CoreDataManager.shared.saveData(randomPhoto, memo, size)
    }
}
