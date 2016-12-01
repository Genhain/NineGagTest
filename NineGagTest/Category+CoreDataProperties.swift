//
//  Category+CoreDataProperties.swift
//  NineGagTest
//
//  Created by Ben Fowler on 18/11/2016.
//  Copyright © 2016 BF. All rights reserved.
//

import Foundation
import CoreData

extension Category {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Category> {
        return NSFetchRequest<Category>(entityName: "Category");
    }

    @NSManaged public var title: String?
    @NSManaged public var id: String?
    @NSManaged public var toPost: NSSet?

}

// MARK: Generated accessors for toPost
extension Category {

    @objc(addToPostObject:)
    @NSManaged public func addToToPost(_ value: Post)

    @objc(removeToPostObject:)
    @NSManaged public func removeFromToPost(_ value: Post)

    @objc(addToPost:)
    @NSManaged public func addToToPost(_ values: NSSet)

    @objc(removeToPost:)
    @NSManaged public func removeFromToPost(_ values: NSSet)

}
