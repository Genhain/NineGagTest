//
//  Category+CoreDataClass.swift
//  
//
//  Created by Ben Fowler on 8/11/2016.
//
//

import Foundation
import CoreData


final public class Category: NSManagedObject, JSONAble {
    
    func sorted(byType:ComparisonResult) -> [Post] {
        
        if let postSet: NSSet = toPost {
            let posts = postSet.allObjects as! [Post]
            return posts.sorted(by: { (A, B) -> Bool in
                
                var retVar = false
                guard let creationDateA = A.created as Date? else {return retVar}
                guard let creationDateB = B.created as Date? else {return retVar}
                
                retVar = (byType == creationDateA.compare(creationDateB))
                
                return retVar
            })
        }
        
        return []
    }
    
    static func initJSONAble(context: NSManagedObjectContext) -> Category {
        
        let category = Category(context: context)
        return category
    }
    
    func fromJSON(_ JSONObject: JSONObject, context: NSManagedObjectContext, keyPath: String = "") throws{
        
        try self.id = JSONObject.valueForKey("\(self.title!).id")
        
        JSONObject.enumerateObjects(atKeyPath: "\(self.title!).posts") { (keyIndex, element) in
            let post = Post(context: context)
            let jsonPostsObj = try? JSONObject.objectForKey("\(self.title!).posts")
            try? post.fromJSON(jsonPostsObj!, context: context, keyPath: "[\(keyIndex)]")
            self.addToToPost(post)
        }
    }
}
