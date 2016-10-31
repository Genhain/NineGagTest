//
//  NineGagTestTests.swift
//  NineGagTestTests
//
//  Created by Ben Fowler on 27/10/2016.
//  Copyright © 2016 BF. All rights reserved.
//

import XCTest
import UIKit
@testable import NineGagTest

class NineGagTestTests: XCTestCase {
    
    var viewController: HomePageController!
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class
        
        let storyboard = UIStoryboard(name: "Main",
                                      bundle: Bundle.main)
        
        viewController = storyboard.instantiateInitialViewController() as! HomePageController
        
        UIApplication.shared.keyWindow!.rootViewController = viewController
        
        let _ = viewController.view
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func test_ScrollView_notNil()
    {
        XCTAssertNotNil(viewController.homePageCollectionView);
    } 
    
    func test_CategoryHeaderView_notNil()
    {
        
    }
    
}
