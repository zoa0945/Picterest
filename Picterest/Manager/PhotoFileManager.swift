//
//  PhotoFileManager.swift
//  Picterest
//
//  Created by Mac on 2022/07/29.
//

import UIKit

class PhotoFileManager {
    static let shared = PhotoFileManager()
    
    func configFileManager(_ id: String) -> URL {
        let docDir = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
        let filePath = docDir.appendingPathComponent("\(id).png")
        
        return filePath
    }
    
    func saveFileManagerData(_ randomPhoto: RandomPhoto) {
        let filePath = configFileManager(randomPhoto.id)
        
        LoadImage().loadImage(randomPhoto.urls.thumb) { result in
            switch result {
            case .success(let image):
                if let data = image.pngData() {
                    do {
                        try data.write(to: filePath)
                    } catch {
                        print("filemanager save error: \(error.localizedDescription)")
                    }
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    func deleteFileManagerData(_ filePath: URL) {
        let fileManager = FileManager.default
        
        do {
            try fileManager.removeItem(at: filePath)
        } catch let error {
            print(error.localizedDescription)
        }
    }
}
