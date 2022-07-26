//
//  RandomPhoto.swift
//  Picterest
//
//  Created by Mac on 2022/07/25.
//

import Foundation

struct RandomPhoto: Codable {
    let width: Int
    let height: Int
    let urls: PhotoURL
}

struct PhotoURL: Codable {
    let thumb: String
}
