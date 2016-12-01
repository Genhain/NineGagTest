//
//  CategoryTests.swift
//  NineGagTest
//
//  Created by Ben Fowler on 16/11/2016.
//  Copyright © 2016 BF. All rights reserved.
//

import XCTest
import CoreData
@testable import NineGagTest

//MARK:Fake
class FakeURLSession: URLSessionProtocol
{
    private(set) var lastURL: URL?
    var testData: [Data]? {  didSet{ dataIterator = (testData?.makeIterator())! } }
    private var dataIterator: IndexingIterator<[Data]>?
    var testError: Error?
    let dataTask = FakeURLSessionDataTask()
    
    func dataTask(with url: URL, completionHandler: @escaping DataTaskResult) -> URLSessionDataTaskProtocol {
        lastURL = url
        completionHandler(dataIterator?.next(), nil, testError)
        return dataTask
    }
}

class FakeURLSessionDataTask: URLSessionDataTaskProtocol {
    private (set) var resumeWasCalled = false
    
    func resume() {
        resumeWasCalled = true
    }
}


func setUpInMemoryPersistentContainer() -> NSPersistentContainer {
    let managedObjectModel = NSManagedObjectModel.mergedModel(from: [Bundle.main])!
    let persistentContainer =  NSPersistentContainer(name: "inMemoryPersistentContainer", managedObjectModel: managedObjectModel)
    
    do {
        try persistentContainer.persistentStoreCoordinator.addPersistentStore(ofType: NSInMemoryStoreType, configurationName: nil, at: nil, options: nil)
    } catch {
        print("Adding in-memory persistent store failed")
    }
    
    
    return persistentContainer
}

class CategoryTests: XCTestCase {
    
    var inMemoryPersistentContainer: NSPersistentContainer!
    var SUT: NineGagTest.Category!
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        inMemoryPersistentContainer = setUpInMemoryPersistentContainer()
        SUT = Category(context: inMemoryPersistentContainer.viewContext)
    }
    
    override func tearDown() {
        
        inMemoryPersistentContainer = nil
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testSorted_3PostsUnordered_ArrayOldestToLatest() {
        
        let postOne = Post(context: inMemoryPersistentContainer.viewContext)
        let postTwo = Post(context: inMemoryPersistentContainer.viewContext)
        let postThree = Post(context: inMemoryPersistentContainer.viewContext)
        
        let posts = NSSet(array:
            [postThree,
             postOne,
             postTwo])
        
        SUT.addToToPost(posts)
        
        let array = SUT.sorted(byType: .orderedAscending)
        
        for(index,post) in array.enumerated() {
            
            if index == 0 {
                XCTAssertEqual(post, postOne)
            }
            
            if index == 1 {
                XCTAssertEqual(post, postTwo)
            }
            
            if index == 2 {
                XCTAssertEqual(post, postThree)
            }
        }
    }
    
    func testSorted_5PostsUnordered_ArrayLatestToOldest() {
        
        let postOne = Post(context: inMemoryPersistentContainer.viewContext)
        let postTwo = Post(context: inMemoryPersistentContainer.viewContext)
        let postThree = Post(context: inMemoryPersistentContainer.viewContext)
        let postFour = Post(context: inMemoryPersistentContainer.viewContext)
        let postFive = Post(context: inMemoryPersistentContainer.viewContext)
        
        let posts = NSSet(array:
            [postFour,
             postOne,
             postFive,
             postTwo,
             postThree])
        
        SUT.addToToPost(posts)
        
        // ACT
        let array = SUT.sorted(byType: .orderedDescending)
        
        // ASSERT
        for(index,post) in array.enumerated() {
            
            if index == 0 {
                XCTAssertEqual(post, postFive)
            }
            
            if index == 1 {
                XCTAssertEqual(post, postFour)
            }
            
            if index == 2 {
                XCTAssertEqual(post, postThree)
            }
            
            if index == 3 {
                XCTAssertEqual(post, postTwo)
            }
            
            if index == 4 {
                XCTAssertEqual(post, postOne)
            }
        }
    }
    
    func testDeserialiseJSON_2JsonEntries_shouldEqualDataOrderAscending()
    {
        // Arrange
        let data =
        ["hot":
            ["id": "1"
            ],
         "not":
            ["id": "2"
            ]
        ]
    
        // Act
        let categories:[NineGagTest.Category] = CoreDataStack.deserialise(JSON: data, inContext: inMemoryPersistentContainer.viewContext, sortById: .orderedAscending, urlSession: URLSession.shared)
        
        // Assert
        XCTAssertEqual(categories[0].title, "hot")
        XCTAssertEqual(categories[0].id, "1")
        
        XCTAssertEqual(categories[1].title, "not")
        XCTAssertEqual(categories[1].id, "2")
    }
    
    func testDeserialiseJSON_5Entries_shouldEqualDataOrderAscending()
    {
        // Arrange
        let data =
            [
                "hello":
                    ["id": "3"],
                "bye":
                    ["id": "4"],
                "from":
                    ["id": "5"],
                "to":
                    ["id": "1"],
                "other":
                    ["id": "2"]
            ]
        
        // Act
        let categories:[NineGagTest.Category] = CoreDataStack.deserialise(JSON: data, inContext: inMemoryPersistentContainer.viewContext,sortById: .orderedAscending, urlSession: URLSession.shared)
        
        // Assert
        XCTAssertEqual(categories[0].title, "to")
        XCTAssertEqual(categories[0].id, "1")
        
        XCTAssertEqual(categories[1].title, "other")
        XCTAssertEqual(categories[1].id, "2")
        
        XCTAssertEqual(categories[2].title, "hello")
        XCTAssertEqual(categories[2].id, "3")
        
        XCTAssertEqual(categories[3].title, "bye")
        XCTAssertEqual(categories[3].id, "4")
        
        XCTAssertEqual(categories[4].title, "from")
        XCTAssertEqual(categories[4].id, "5")
    }
    
    func testDeserialiseJSON_5Entries_shouldEqualDataOrderDescending()
    {
        // Arrange
        let data =
            [
                "hello":
                    ["id": "3"],
                "bye":
                    ["id": "4"],
                "from":
                    ["id": "5"],
                "to":
                    ["id": "1"],
                "other":
                    ["id": "2"]
        ]
        
        // Act
        let categories:[NineGagTest.Category] = CoreDataStack.deserialise(JSON: data, inContext: inMemoryPersistentContainer.viewContext,sortById: .orderedDescending, urlSession: URLSession.shared)
        
        // Assert
        XCTAssertEqual(categories[4].title, "to")
        XCTAssertEqual(categories[4].id, "1")
        
        XCTAssertEqual(categories[3].title, "other")
        XCTAssertEqual(categories[3].id, "2")
        
        XCTAssertEqual(categories[2].title, "hello")
        XCTAssertEqual(categories[2].id, "3")
        
        XCTAssertEqual(categories[1].title, "bye")
        XCTAssertEqual(categories[1].id, "4")
        
        XCTAssertEqual(categories[0].title, "from")
        XCTAssertEqual(categories[0].id, "5")
    }
    
    func testDeserialiseJSON_2EntriesWith1PostEach_shouldEqualDataOrderDescending()
    {
        // Arrange
        let firstDate = Date.init()
        let secondDate = Date.init()
        let data =
        [
            "hello":
                ["id": "1",
                 "posts":[
                    ["created": firstDate,
                     "titleText": "test1",
                     "id": "hello1"]]],
            "bye":
                ["id": "2",
                 "posts":[
                    ["created": secondDate,
                     "titleText": "test2",
                     "id": "bye1"]]]
        ]
        
        // Act
        let categories:[NineGagTest.Category] = CoreDataStack.deserialise(JSON: data, inContext: inMemoryPersistentContainer.viewContext,sortById: .orderedDescending, urlSession: URLSession.shared)
        
        // Assert
        let allPostsInFirstCategory = categories[0].toPost?.allObjects as! [Post]
        XCTAssertEqual(allPostsInFirstCategory[0].title, "test2")
        XCTAssertEqual(allPostsInFirstCategory[0].id, "bye1")
        
        let allPostsInSecondCategory = categories[1].toPost?.allObjects as! [Post]
        XCTAssertEqual(allPostsInSecondCategory[0].title, "test1")
        XCTAssertEqual(allPostsInSecondCategory[0].id, "hello1")
    }
    
    func testDeserialiseJSON_1EntriesWith2Posts_shouldEqualDataOrderDescending()
    {
        // Arrange
        let firstDate = Date.init()
        let secondDate = Date.init()
        let data =
            [
                "hello":
                    ["id": "1",
                     "posts":[
                        ["created": firstDate,
                         "titleText": "test1",
                         "id": "1"],
                        ["created": secondDate,
                         "titleText": "test2",
                         "id": "2"]]]
        ]
        
        // Act
        let categories:[NineGagTest.Category] = CoreDataStack.deserialise(JSON: data, inContext: inMemoryPersistentContainer.viewContext,sortById: .orderedDescending, urlSession: URLSession.shared)
        
        // Assert
        var postSortedCategories = [[Post]]()
        
        // because the posts are an array and arent guarenteed order we use the following funciton
        // to order them before asserting
        for category in categories {
            postSortedCategories.append(category.sorted(byType: .orderedAscending))
        }
        
        let allPostsInFirstCategory = postSortedCategories.first!
        XCTAssertEqual(allPostsInFirstCategory[0].title, "test1")
        XCTAssertEqual(allPostsInFirstCategory[0].id, "1")
        
        XCTAssertEqual(allPostsInFirstCategory[1].title, "test2")
        XCTAssertEqual(allPostsInFirstCategory[1].id, "2")
    }
    
    func testDeserialiseJSON_2EntriesWith2Posts_shouldEqualDataOrderDescending()
    {
        // Arrange
        let data =
            [
                "hello":
                    ["id": "1",
                     "posts":[
                        ["titleText": "test1",
                         "id": "1"],
                        ["titleText": "test2",
                         "id": "2"]]],
                "bye":
                    ["id": "1",
                     "posts":[
                        ["titleText": "test3",
                         "id": "3"],
                        ["titleText": "test4",
                         "id": "4"]]]
        ]
        
        // Act
        let categories:[NineGagTest.Category] = CoreDataStack.deserialise(JSON: data, inContext: inMemoryPersistentContainer.viewContext,sortById: .orderedDescending, urlSession: URLSession.shared)
        
        // Assert
        var postSortedCategories = [[Post]]()
        
        // because the posts are an array and arent guarenteed order we use the following funciton
        // to order them before asserting
        for category in categories {
            postSortedCategories.append(category.sorted(byType: .orderedAscending))
        }
        
        let allPostsInFirstCategory = postSortedCategories[0]
        XCTAssertEqual(allPostsInFirstCategory[0].title, "test1")
        XCTAssertEqual(allPostsInFirstCategory[0].id, "1")
        
        XCTAssertEqual(allPostsInFirstCategory[1].title, "test2")
        XCTAssertEqual(allPostsInFirstCategory[1].id, "2")
        
        let allPostsInSecondCategory = postSortedCategories[1]
        XCTAssertEqual(allPostsInSecondCategory[0].title, "test3")
        XCTAssertEqual(allPostsInSecondCategory[0].id, "3")
        
        XCTAssertEqual(allPostsInSecondCategory[1].title, "test4")
        XCTAssertEqual(allPostsInSecondCategory[1].id, "4")
    }
    
    func testDeserialiseJSON_spy_URLSetAndResumeCalled()
    {
        let expectedImage = UIImage.testImage(size: .init(width: 1, height: 1), color: #colorLiteral(red: 0.1215686277, green: 0.01176470611, blue: 0.4235294163, alpha: 1))
        let imageData: Data = UIImagePNGRepresentation(expectedImage)!
        let expectedURL = URL.temporaryURL(forFilename: "file", withExtension: "png")
        
        do {
            try imageData.write(to: expectedURL, options: .atomic)
        } catch {
            XCTFail("unable to write imagedata: \(imageData), to URL: \(expectedURL), error: \(error)")
        }
        
        let data =
            [
                "hello":
                    ["id": "1",
                     "posts":[
                        ["contentImageName": expectedURL.absoluteString]]]
        ]
        
        // Act
        let spy = FakeURLSession()
        _ = CoreDataStack.deserialise(JSON: data, inContext: inMemoryPersistentContainer.viewContext,sortById: .orderedAscending, urlSession: spy)
        
        // Assert
        XCTAssertEqual(spy.lastURL!, expectedURL)
        XCTAssertTrue(spy.dataTask.resumeWasCalled)
    }
    
    func testDeserialise_SpyWithDataRed50by50Image_DataPassedIn()
    {
        // Arrange
        let expectedURL = URL.temporaryURL(forFilename: "file", withExtension: "png")
        
        let data =
            [
                "hello":
                    ["id": "1",
                     "posts":[
                        ["titleText": "test1",
                         "id": "1",
                         "contentImageName": expectedURL.absoluteString]
                        ]
                     ]
        ]
    
        // Act
        let spy = FakeURLSession()
        let expectedImage = UIImage.testImage(size: .init(width: 50, height: 50), color: #colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1))
        let imageData: Data = UIImagePNGRepresentation(expectedImage)!
        
        spy.testData = [imageData]
        
        let categories:[NineGagTest.Category] = CoreDataStack.deserialise(JSON: data,
                                      inContext: inMemoryPersistentContainer.viewContext,
                                      sortById: .orderedAscending,
                                      urlSession: spy)
    
        // Assert
        let allPostsInFirstCategory = categories[0].toPost?.allObjects as! [Post]
        
        guard let actualImage = allPostsInFirstCategory[0].toImage?.image as! UIImage? else { XCTFail(); return }
        XCTAssertTrue(actualImage.hasEqualData(otherImage: expectedImage))
    }
    
    func testDeserialise_SpyWithDataBlue10By10_DataPassedIn()
    {
        // Arrange
        let expectedURL = URL.temporaryURL(forFilename: "file", withExtension: "png")
        
        let data =
            [
                "hello":
                    ["id": "1",
                     "posts":[
                        ["contentImageName": expectedURL.absoluteString]]]
        ]
        
        // Act
        let spy = FakeURLSession()
        let expectedImage = UIImage.testImage(size: .init(width: 10, height: 10), color: #colorLiteral(red: 0.2196078449, green: 0.007843137719, blue: 0.8549019694, alpha: 1))
        let imageData: Data = UIImagePNGRepresentation(expectedImage)!
        
        spy.testData = [imageData]
        
        let categories:[NineGagTest.Category] = CoreDataStack.deserialise(JSON: data,
                                                                          inContext: inMemoryPersistentContainer.viewContext,
                                                                          sortById: .orderedAscending,
                                                                          urlSession: spy)
        
        // Assert
        let allPostsInFirstCategory = categories[0].toPost?.allObjects as! [Post]
        
        guard let actualImage = allPostsInFirstCategory[0].toImage?.image as! UIImage? else { XCTFail(); return }
        XCTAssertTrue(actualImage.hasEqualData(otherImage: expectedImage))
    }
    
    func testDeserialise_SpyWith2DataEntires_DataPassedIn()
    {
        // Arrange
        let firstURL = URL.temporaryURL(forFilename: "file1", withExtension: "png")
        let secondURL = URL.temporaryURL(forFilename: "file2", withExtension: "png")
        
        let data =
            [
                "hello":
                    ["id": "1",
                     "posts":[
                        ["contentImageName": firstURL.absoluteString],
                        ["contentImageName": secondURL.absoluteString]]]
        ]
        
        // Act
        let spy = FakeURLSession()
        let expectedImageOne = UIImage.testImage(size: .init(width: 10, height: 10), color: #colorLiteral(red: 0.2196078449, green: 0.007843137719, blue: 0.8549019694, alpha: 1))
        let expectedImageTwo = UIImage.testImage(size: .init(width: 5, height: 5), color: #colorLiteral(red: 0.9372549057, green: 0.3490196168, blue: 0.1921568662, alpha: 1))
        
        spy.testData = [UIImagePNGRepresentation(expectedImageOne)!, UIImagePNGRepresentation(expectedImageTwo)!]
        
        let categories:[NineGagTest.Category] = CoreDataStack.deserialise(JSON: data,
                                                                          inContext: inMemoryPersistentContainer.viewContext,
                                                                          sortById: .orderedAscending,
                                                                          urlSession: spy)
        
        // Assert
        let allPostsInFirstCategory = categories[0].toPost?.allObjects as! [Post]
        
        guard let actualImageOne = allPostsInFirstCategory[0].toImage?.image as! UIImage? else { XCTFail(); return }
        XCTAssertTrue(actualImageOne.hasEqualData(otherImage: expectedImageOne))
        
        guard let actualImageTwo = allPostsInFirstCategory[1].toImage?.image as! UIImage? else { XCTFail(); return }
        XCTAssertTrue(actualImageTwo.hasEqualData(otherImage: expectedImageTwo))
    }
    
    // MARK: Single Async request to be thorough
    func testDeserialiseJSON_AsyncActualHTML_shouldEqualImageData()
    {
        // Arrange
        let asyncExpectation = expectation(description: "image loading")
        
        let data =
            [
                "hello":
                    ["id": "1",
                     "posts":[
                        ["contentImageName": "https://i.imgur.com/rbXZcVH.jpg"]]]
        ]
        
        // Act
        let categories:[NineGagTest.Category] = CoreDataStack.deserialise(JSON: data, inContext: inMemoryPersistentContainer.viewContext,sortById: .orderedAscending)
        
        // Assert
        let allPostsInFirstCategory = categories[0].toPost?.allObjects as! [Post]
        XCTAssertNotNil(allPostsInFirstCategory[0].toImage)
        
        //assertion loop for async op
        DispatchQueue.global().async {
            
            var flag = true
            while flag {
                if let _ = allPostsInFirstCategory[0].toImage?.image {
                    flag = false
                    
                    guard let _ = allPostsInFirstCategory[0].toImage?.image as! UIImage? else {XCTFail(); return}
                    asyncExpectation.fulfill()
                }
            }
        }
        
        self.waitForExpectations(timeout: 5) { (error) in
            XCTAssertNil(error, "Something went horribly wrong")
        }
    }
}
