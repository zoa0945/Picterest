//
//  SavedViewModel.swift
//  Picterest
//
//  Created by Mac on 2022/07/29.
//

import Foundation

class SavedViewModel {
    func deleteCoreData(_ object: Photo) {
        CoreDataManager.shared.deleteCoreData(object)
    }
    
    func deleteFileManagerData(_ filePath: URL) {
        PhotoFileManager.shared.deleteFileManagerData(filePath)
    }
    
    func fetchCoreData() -> [Photo] {
        return CoreDataManager.shared.fetchCoreData()
    }
}
