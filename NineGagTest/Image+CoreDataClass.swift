//
//  Image+CoreDataClass.swift
//  
//
//  Created by Ben Fowler on 8/11/2016.
//
//

import Foundation
import CoreData


public class Image: NSManagedObject, JSONAble
{
    internal static func create(inContext context: NSManagedObjectContext) -> Self {
        return .init(context: context)
    }

    func fromJSON(_ JSONObject: JSONObject, context: NSManagedObjectContext, keyPath: String) throws {
        
        self.url = try JSONObject.valueForKey("\(keyPath).contentImageName")
    }

}
