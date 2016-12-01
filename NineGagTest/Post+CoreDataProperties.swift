//
//  Post+CoreDataProperties.swift
//  
//
//  Created by Ben Fowler on 16/11/2016.
//
//

import Foundation
import CoreData

extension Post {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Post> {
        return NSFetchRequest<Post>(entityName: "Post");
    }

    @NSManaged public var created: NSDate?
    @NSManaged public var title: String?
    @NSManaged public var id: String?
    @NSManaged public var toCategory: Category?
    @NSManaged public var toImage: Image?

}
