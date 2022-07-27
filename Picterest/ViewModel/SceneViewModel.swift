//
//  SceneViewModel.swift
//  Picterest
//
//  Created by Mac on 2022/07/26.
//

import UIKit
import CoreData

class SceneViewModel {
    private let networkService = UnsplashAPI()
    private let appdelegate = UIApplication.shared.delegate as! AppDelegate
    private lazy var context = appdelegate.persistentContainer.viewContext
    
    func getImageURLs(_ completion: @escaping (Result<[RandomPhoto], Error>) -> Void) {
        return networkService.getPhoto(completion)
    }
    
    private func configFileManager(_ indexPath: Int) -> URL {
        let docDir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let filePath = docDir.appendingPathComponent("\(indexPath).txt")
        
        return filePath
    }
    
    func saveInFileManager(_ randomPhoto: RandomPhoto, _ indexPath: Int, _ memo: String) {
        let filePath = configFileManager(indexPath)
        
        let text = randomPhoto.urls.thumb + "_" + memo
        
        do {
            try text.write(to: filePath, atomically: false, encoding: .utf8)
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    func saveInCoreData(_ randomPhoto: RandomPhoto, _ indexPath: Int, _ memo: String) {
        let newPhoto = Photo(context: self.context)
        newPhoto.memo = memo
        newPhoto.id = randomPhoto.id
        newPhoto.filepath = configFileManager(indexPath)
        newPhoto.imageurl = randomPhoto.urls.thumb
        
        do {
            try self.context.save()
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    func fetchCoreData() -> [Photo] {
        do {
            let request = Photo.fetchRequest()
            let photos = try context.fetch(request)
            print("success")
            return photos
        } catch let error {
            print(error.localizedDescription)
            return []
        }
    }
}
