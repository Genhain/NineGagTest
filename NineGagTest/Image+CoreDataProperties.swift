//
//  Image+CoreDataProperties.swift
//  NineGagTest
//
//  Created by Ben Fowler on 20/11/2016.
//  Copyright © 2016 BF. All rights reserved.
//

import Foundation
import CoreData

extension Image {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Image> {
        return NSFetchRequest<Image>(entityName: "Image");
    }

    @NSManaged public var image: NSObject?
    @NSManaged public var url: String?
    @NSManaged public var toPost: Post?

}
