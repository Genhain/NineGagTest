//
//  JSONObjectTests.swift
//  NineGagTest
//
//  Created by Ben Fowler on 29/11/2016.
//  Copyright © 2016 BF. All rights reserved.
//

import XCTest
import CoreData
@testable import NineGagTest

class JSONObjectTests: XCTestCase {
    
    var inMemoryPersistentContainer: NSPersistentContainer!
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        inMemoryPersistentContainer = setUpInMemoryPersistentContainer()
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testJSONValue_array1CountIntoDictionary_ShouldEqualData()
    {
        // Arrange
        let data =
            [
                ["id": "1",
                 "posts":[
                    ["titleText": "test1",
                     "id": "1"],
                    ["titleText": "test2",
                     "id": "2"]]]
        ]
        
        class JSONAbleTester: JSONAble
        {
            private(set) var id: String?
            private(set) var posts: [[String: AnyObject]]?
            
            func fromJSON(_ JSONObject: JSONObject, context: NSManagedObjectContext, keyPath: String = "[0]") throws {
                self.id = try JSONObject.valueForKey("\(keyPath).id")
                self.posts = try JSONObject.valueForKey("\(keyPath).posts")
            }
        }
        
        // Act
        let spy = JSONAbleTester()
        
        let jsonObj = JSONObject(collection: data)
        
        try? spy.fromJSON(jsonObj, context: inMemoryPersistentContainer.viewContext)
        
        // Assert
        XCTAssertEqual(spy.id, "1")
        XCTAssertEqual(spy.posts?[0]["titleText"] as! String, "test1")
        XCTAssertEqual(spy.posts?[0]["id"] as! String, "1")
        XCTAssertEqual(spy.posts?[1]["titleText"] as! String, "test2")
        XCTAssertEqual(spy.posts?[1]["id"] as! String, "2")
    }
    
    func testJSONValue_array2CountIntoDictionary_ShouldEqualData()
    {
        // Arrange
        let data =
            [
                ["id": "1",
                 "posts":[
                    ["titleText": "test1",
                     "id": "1"],
                    ["titleText": "test2",
                     "id": "2"]]],
                ["id": "2",
                 "posts":[
                    ["titleText": "test3",
                     "id": "3"],
                    ["titleText": "test4",
                     "id": "4"]]]
        ]
        
        class JSONAbleTester: JSONAble
        {
            private(set) var id: String?
            private(set) var posts: [[String: AnyObject]]?
            
            func fromJSON(_ JSONObject: JSONObject, context: NSManagedObjectContext, keyPath: String = "") throws {
                self.id = try JSONObject.valueForKey("\(keyPath).id")
                self.posts = try JSONObject.valueForKey("\(keyPath).posts")
            }
        }
        
        // Act
        let spy = JSONAbleTester()
        
        let jsonObj = JSONObject(collection: data)
        
        try? spy.fromJSON(jsonObj, context: inMemoryPersistentContainer.viewContext, keyPath: "[0]")
        
        // Assert
        XCTAssertEqual(spy.id, "1")
        XCTAssertEqual(spy.posts?[0]["titleText"] as! String, "test1")
        XCTAssertEqual(spy.posts?[0]["id"] as! String, "1")
        XCTAssertEqual(spy.posts?[1]["titleText"] as! String, "test2")
        XCTAssertEqual(spy.posts?[1]["id"] as! String, "2")
        
        try? spy.fromJSON(jsonObj, context: inMemoryPersistentContainer.viewContext, keyPath: "[1]")
        
        XCTAssertEqual(spy.id, "2")
        XCTAssertEqual(spy.posts?[0]["titleText"] as! String, "test3")
        XCTAssertEqual(spy.posts?[0]["id"] as! String, "3")
        XCTAssertEqual(spy.posts?[1]["titleText"] as! String, "test4")
        XCTAssertEqual(spy.posts?[1]["id"] as! String, "4")
    }
    
    func testEnumerateObjects_array5Count_ShouldEqualData()
    {
        // Arrange
        let data =
        [
            "1",
            "2",
            "3",
            "4",
            "5"
        ]
        
        // Act
        let SUT = JSONObject(collection: data)
        
        // Assert
        var index = 0
        SUT.enumerateObjects(atKeyPath: "") { (keyIndex, element) in
            XCTAssertEqual(Int(keyIndex)!, index)
            XCTAssertEqual(data[index], String(describing: element))
            index += 1
        }
        
        XCTAssertEqual(5, index)
    }
    
    func testEnumerateObjects_array8Count_ShouldEqualData()
    {
        // Arrange
        let data =
            [
                "1",
                "2",
                "3",
                "4",
                "5",
                "6",
                "7",
                "8"
        ]
        
        // Act
        let SUT = JSONObject(collection: data)
        
        // Assert
        var index = 0
        SUT.enumerateObjects(atKeyPath: "") { (keyIndex, element) in
            XCTAssertEqual(Int(keyIndex)!, index)
            XCTAssertEqual(data[index], String(describing: element))
            index += 1
        }
        
        XCTAssertEqual(8, index)
    }
    
    func testEnumerateObjects_array3Dictionaries_ShouldEqualData()
    {
        // Arrange
        let data =
        [
            ["value": "1"],
            ["value": "2"],
            ["value": "3"]
        ]
        
        // Act
        let SUT = JSONObject(collection: data)
        
        // Assert
        var index = 0
        SUT.enumerateObjects(atKeyPath: "") { (keyIndex, element) in
            XCTAssertEqual("\(index)", keyIndex)
            
            XCTAssertEqual(data[index], element as! [String : String])
            index += 1
        }
        
        XCTAssertEqual(3, index)
    }
    
    func testEnumerateObjects_dictionary3Count_ShouldEqualData()
    {
        // Arrange
        let data =
        [
            "1": "1",
            "2": "2",
            "3": "3"
        ]
        
        // Act
        let SUT = JSONObject(collection: data)
        
        // Assert
        var index = 0
        SUT.enumerateObjects(atKeyPath: "") { (keyIndex, element) in
            XCTAssertEqual(data[keyIndex], String(describing: element) )
            index += 1
        }
        
        XCTAssertEqual(3, index)
    }
    
    func testEnumerateObjects_arrayInDictionary3CountIntoDictionary_ShouldEqualData()
    {
        // Arrange
        let data =
        [
            "one": ["1","2","3"]
        ]
        
        // Act
        let SUT = JSONObject(collection: data)
        
        // Assert
        var index = 0
        SUT.enumerateObjects(atKeyPath: "one") { (keyIndex, element) in
            XCTAssertEqual(data["one"]?[index], String(describing: element) )
            index += 1
        }
        
        XCTAssertEqual(3, index)
    }
    
    func testEnumerateObjects_array4CountInDictionary_ShouldEqualData()
    {
        // Arrange
        let data =
        [
            "two": ["3", "4", "5", "6"]
        ]
        
        // Act
        let SUT = JSONObject(collection: data)
        
        // Assert
        var index = 0
        SUT.enumerateObjects(atKeyPath: "two") { (keyIndex, element) in
            XCTAssertEqual(data["two"]?[index], String(describing: element) )
            index += 1
        }
        
        XCTAssertEqual(4, index)
    }
    
    func testEnumerateObjects_nestedExample_ShouldEqualData()
    {
        // Arrange
        let data =
        [
            "a": ["one", "two", "three"],
            "two": [4, 5, 6, 7],
            "tres": ["three": ["8": 8, "9": 9]]
        ] as [String : Any]
        
        
        let SUT = JSONObject(collection: data)
        
        
        // Act
        var index = 0
        SUT.enumerateObjects(atKeyPath: "a") { (keyIndex, element) in
            let array = data["a"] as? [String]
            // Assert
            XCTAssertEqual(array?[index], String(describing: element) )
            index += 1
        }
        
        XCTAssertEqual(3, index)
        
        index = 0
        SUT.enumerateObjects(atKeyPath: "two") { (keyIndex, element) in
            let array = data["two"] as? [Int]
            // Assert
            XCTAssertEqual(array?[index], element as? Int)
            index += 1
        }
        
        XCTAssertEqual(4, index)
        
        index = 0
        SUT.enumerateObjects(atKeyPath: "tres.three") { (keyIndex, element) in
            guard let dict = data["tres"] as? [String: Any] else { XCTFail(); return }
            guard let innerDict = dict["three"] as? [String: Int] else { XCTFail(); return }
            // Assert
            XCTAssertEqual(innerDict[keyIndex], element as? Int)
            index += 1
        }
        
        XCTAssertEqual(2, index)
    }
    
//    func testEnumerateJSONConvertible_PostObject_isStuff()
//    {
//        // Arrange
//        let data =
//        [
//            "category":
//                ["id": "1",
//                 "posts":[
//                    ["titleText": "test1",
//                     "id": "1"],
//                    ["titleText": "test2",
//                     "id": "2"]]]
//        ]
//        
//        let SUT = JSONObject(collection: data)
//    
//        // Act
//        SUT.enumerateObjects(ofType: Post.self, forKeyPath: "category.posts") { (keyIndex, element) in
//            
//        }
//        
//        // Assert
//    }
}
