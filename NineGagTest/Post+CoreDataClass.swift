//
//  Post+CoreDataClass.swift
//  
//
//  Created by Ben Fowler on 8/11/2016.
//
//

import Foundation
import CoreData


public class Post: NSManagedObject, JSONAble {
    
    public override func awakeFromInsert() {
        
        super.awakeFromInsert()
        
        self.created = NSDate()
    
    }

    func fromJSON(_ JSONObject: JSONObject, context: NSManagedObjectContext, keyPath: String = "") throws {
        
        self.title = try? JSONObject.valueForKey("\(keyPath).titleText")
        self.id = try? JSONObject.valueForKey("\(keyPath).id")
        
        let image = Image(context: context)
        
        try image.fromJSON(JSONObject, context: context, keyPath: "\(keyPath)")
        
        self.toImage = image
    }
}
