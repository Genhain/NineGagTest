//
//  Category+CoreDataClass.swift
//  
//
//  Created by Ben Fowler on 8/11/2016.
//
//

import Foundation
import CoreData


public class Category: NSManagedObject, JSONAble {
    
    internal static func create(inContext context: NSManagedObjectContext) -> Self {
        return .init(context: context)
    }
    
    func fromJSON(_ JSONObject: JSONObject, context: NSManagedObjectContext, keyPath: String = "") throws {
        try self.id = JSONObject.valueForKey("\(self.title!).id")
        
        JSONObject.enumerateObjects(atKeyPath: "\(self.title!).posts") { (keyIndex, element) in
            let post = Post(context: context)
            let jsonPostsObj = try? JSONObject.objectForKey("\(self.title!).posts")
            try? post.fromJSON(jsonPostsObj!, context: context, keyPath: "[\(keyIndex)]")
            self.addToToPost(post)
        }
    }
    
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
    
    
}
