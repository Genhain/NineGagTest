//
//  ContentSelectionManagerTests.swift
//  NineGagTest
//
//  Created by Ben Fowler on 29/10/2016.
//  Copyright © 2016 BF. All rights reserved.
//

import XCTest
@testable import NineGagTest


class ContentSelectionDelegateFake: NSObject, ContentSelectedDelegate
{
    var wasSelectContentCalled = false
    var variablePassedIn : Int = 0
    
    func selectContent(forIndex: Int) {
        wasSelectContentCalled = true
        variablePassedIn = forIndex
    }
}

class ContentSelectionManagerTests: XCTestCase
{
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testContentSelection_AtIndex1_IndexIs1()
    {
        // Arrange
        let SUT = ContentSelectionManager()
        
        let contentSelectionDelegateOne = ContentSelectionDelegateFake()
        SUT.contentSelectionDelegate(add: contentSelectionDelegateOne)
        
        // Act
        SUT.contentSelected(atIndex: 1)
        
        // Assert
        XCTAssertEqual(contentSelectionDelegateOne.variablePassedIn, 1)
    }
    
    func testContentSelection_AtIndex7_IndexIs7()
    {
        // Arrange
        let SUT = ContentSelectionManager()
        
        let contentSelectionDelegateOne = ContentSelectionDelegateFake()
        SUT.contentSelectionDelegate(add: contentSelectionDelegateOne)
        
        // Act
        SUT.contentSelected(atIndex: 7)
        
        // Assert
        XCTAssertEqual(contentSelectionDelegateOne.variablePassedIn, 7)
    }
    
    func testContentSelection_TwoContentDelegates_willCallAllDelegates()
    {
        // Arrange
        let SUT = ContentSelectionManager()
        
        let contentSelectionDelegateOne = ContentSelectionDelegateFake()
        let contentSelectionDelegateTwo = ContentSelectionDelegateFake()
        SUT.contentSelectionDelegate(add: contentSelectionDelegateOne)
        SUT.contentSelectionDelegate(add: contentSelectionDelegateTwo)
        
        // Act
        SUT.contentSelected(atIndex: 0)
        
        // Assert
        XCTAssertTrue(contentSelectionDelegateOne.wasSelectContentCalled)
        XCTAssertTrue(contentSelectionDelegateTwo.wasSelectContentCalled)
    }
    
    func testRemoveContentSelection_TwoContentDelegates_willRemoveDelegate()
    {
        // Arrange
        let SUT = ContentSelectionManager()
        
        let contentSelectionDelegateOne = ContentSelectionDelegateFake()
        let contentSelectionDelegateTwo = ContentSelectionDelegateFake()
        SUT.contentSelectionDelegate(add: contentSelectionDelegateOne)
        SUT.contentSelectionDelegate(add: contentSelectionDelegateTwo)
        SUT.contentSelectionDelegate(remove: contentSelectionDelegateTwo)
        
        // Act
        SUT.contentSelected(atIndex: 0)
        
        // Assert
        XCTAssertTrue(contentSelectionDelegateOne.wasSelectContentCalled)
        XCTAssertFalse(contentSelectionDelegateTwo.wasSelectContentCalled)
    }
    
}
