//
//  CoreDataManager.swift
//  Picterest
//
//  Created by Mac on 2022/07/29.
//

import UIKit
import CoreData

class CoreDataManager {
    static let shared = CoreDataManager()
    
    private let appdelegate = UIApplication.shared.delegate as! AppDelegate
    private lazy var context = appdelegate.persistentContainer.viewContext
    
    func saveData(_ randomPhoto: RandomPhoto, _ memo: String, _ size: [Int]) {
        let filePath = PhotoFileManager.shared.configFileManager(randomPhoto.id)
        let newPhoto = Photo(context: self.context)
        newPhoto.memo = memo
        newPhoto.id = randomPhoto.id
        newPhoto.imagesize = size
        newPhoto.filepath = filePath
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
            return photos
        } catch let error {
            print(error.localizedDescription)
            return []
        }
    }
    
    func deleteCoreData(_ object: Photo) {
        context.delete(object)
        
        do {
            try context.save()
        } catch let error {
            print(error.localizedDescription)
        }
    }
}
