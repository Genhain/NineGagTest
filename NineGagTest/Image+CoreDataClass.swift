//
//  Image+CoreDataClass.swift
//  
//
//  Created by Ben Fowler on 8/11/2016.
//
//

import Foundation
import CoreData


final public class Image: NSManagedObject, JSONAble
{
    static func initJSONAble(context: NSManagedObjectContext) -> Image {
        return Image(context: context)
    }

    func fromJSON(_ JSONObject: JSONObject, context: NSManagedObjectContext, keyPath: String) throws {
        
        self.url = try JSONObject.valueForKey("\(keyPath).contentImageName")
    }

}
