//
//  RandomPhoto.swift
//  Picterest
//
//  Created by Mac on 2022/07/25.
//

import Foundation

struct RandomPhoto: Codable {
    let id: String
    let width: Int
    let height: Int
    let urls: PhotoURL
    
    var isFavorite: Bool = false
    
    enum CodingKeys: String, CodingKey {
        case id, width, height, urls
    }
}

struct PhotoURL: Codable {
    let thumb: String
}

struct SavedPhoto {
    let imageURL: String
    let memo: String
}
