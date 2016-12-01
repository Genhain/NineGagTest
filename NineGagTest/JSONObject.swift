//
//  JSONHandler.swift
//  NineGagTest
//
//  Created by Ben Fowler on 23/11/2016.
//  Copyright © 2016 BF. All rights reserved.
//

import Foundation
import UIKit
import CoreData

enum JSONError : Error {
    case NoValueForKey(String)
    case IndexOutOfRange
    case TypeMismatch
    case InvalidString
}

protocol JSONAble {
    func fromJSON(_ JSONObject: JSONObject, context: NSManagedObjectContext, keyPath: String) throws
}

class JSONObject
{
    private var array: [Any]?
    private var dictionary: [String: Any]?
    
    init<T: Any>(collection: T) where T: Collection {
        
        self.array = nil
        self.dictionary = nil
        
        if let dictionary = collection as? [String: Any] {
            
            self.dictionary = dictionary
        }
        else if let array = collection as? [Any] {
            
            self.array = array
        }
    }
    
    func valueForKey<A: Any>(_ key: String) throws -> A {
        
        let valueAtPath = try? self.valueAtPath(key)
        
        if let value = valueAtPath as? A {
            return value
        }
        
        throw JSONError.TypeMismatch
    }
    
    func countForRelationship(_ key: String) -> Int {
        
        let valueAtPath = try? self.valueAtPath(key)
        
        if let value = valueAtPath as? Dictionary<String, Any> {
            return Int(value.count)
        }
        else if let value = valueAtPath as? Array<Any> {
            return Int(value.count)
        }
        
        return 0
        
       
    }
    
    func enumerateObjects(atKeyPath keypath: String, enumerationClosure: ( _ indexKey: String, _ element: AnyObject) -> Void)  {
        
        let value = try? self.valueAtPath(keypath)
        
        if let array = value as? [Any] {
            for(index, element) in array.enumerated() {
                enumerationClosure("\(index)", element as AnyObject)
            }
        }
        else if let dictionary = value as? [String: Any] {
            for(index, element) in dictionary {
                enumerationClosure(index, element as AnyObject)
            }
        }
    }

    private func iterate<T: Any>(collection: T, forKey key: String) -> Any where T: Collection {
        
        var retVal: Any?
        
        for(_,element) in collection.enumerated() {
            retVal = element
            
            if let dictionaryEntry = element as? Dictionary<String, Any>.Element {
                if key == dictionaryEntry.key {
                    retVal = dictionaryEntry.value
                }
            }
            else {
                retVal = element
            }
            
        }
        
        return retVal!
    }

    private func valueAtPath(_ keyPath: String) throws -> Any
    {
        let pathComponents = keyPath.components(separatedBy:".")
    
        var valueAtPath: Any?
        
        if let array = self.array {
            valueAtPath = array
        }
        
        if let dictionary = self.dictionary {
            valueAtPath = dictionary
        }
        
        for component in pathComponents {
            
            var charset = CharacterSet()
            charset.insert("[")
            charset.insert("]")
            let innerComponents = component.components(separatedBy: charset)
            
            if innerComponents.count > 1, innerComponents.count < 3 { throw JSONError.InvalidString }
            
            let key = innerComponents.first
            
            if let array = valueAtPath as? [AnyObject] {
                if innerComponents.count > 1 {
                    guard let index = Int(innerComponents[1]),
                        innerComponents.count > index
                           else {
                        throw JSONError.IndexOutOfRange
                    }
                    
                    valueAtPath = array[index]
                }
                else {
                    valueAtPath = array
                }
                
                continue
            }
            
            
            if let dict = valueAtPath as? [String:AnyObject] {
                if let value = dict[key!] {
                    valueAtPath = value
                    continue
                }
            }
        }
        
        return valueAtPath!
    }
    
    func objectForKey(_ key: String) throws -> JSONObject {
        
        var retVal: JSONObject?
        
        if let dict: [String: AnyObject] = try? valueForKey(key) {
            retVal = JSONObject(collection: dict)
        }
        
        if let array: [AnyObject] = try? valueForKey(key) {
            retVal = JSONObject(collection: array)
        }
        
        return retVal!
    }
}
