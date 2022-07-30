//
//  Photo+CoreDataProperties.swift
//  Picterest
//
//  Created by Mac on 2022/07/27.
//
//

import Foundation
import CoreData


extension Photo {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Photo> {
        return NSFetchRequest<Photo>(entityName: "Photo")
    }

    @NSManaged public var imagesize: [Int]?
    @NSManaged public var filepath: URL?
    @NSManaged public var id: String?
    @NSManaged public var imageurl: String?
    @NSManaged public var memo: String?

}

extension Photo : Identifiable {

}
