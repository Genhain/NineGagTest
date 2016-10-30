import XCTest
import UIKit
@testable import NineGagTest

class MenuBarViewTests: XCTestCase {
    
    var SUT: MenuBarView!
    var defaultCollectionView: UICollectionView!
    
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        defaultCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        SUT = MenuBarView(collectionView: defaultCollectionView, frame: .zero)
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testMenuBarView_conformsToUICollectionViewProtocols()
    {
        XCTAssertTrue(MenuBarView.conforms(to: UICollectionViewDataSource.self))
        XCTAssertTrue(MenuBarView.conforms(to: UICollectionViewDelegate.self))
        XCTAssertTrue(MenuBarView.conforms(to: UICollectionViewDelegateFlowLayout.self))
    }
    
    func testMenuBarView_isDefaultDataSourceAndDelegate()
    {
        XCTAssertNotNil(defaultCollectionView.dataSource)
        XCTAssertTrue((defaultCollectionView.dataSource?.isEqual(SUT))!)
        
        XCTAssertNotNil(defaultCollectionView.delegate)
        XCTAssertTrue((defaultCollectionView.delegate?.isEqual(SUT))!)
    }
    
    func testMenuBarView_hasSubviewCollectionView()
    {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewLayout())
        let SUT = MenuBarView(collectionView: collectionView, frame: CGRect(x: 10, y: 20, width: 100, height: 200))
        
        XCTAssertTrue(SUT.subviews.contains(collectionView))
    }
    
    func  testMenuBarView_x10y20Width100Height200_isEqual()
    {
        let SUT = MenuBarView(collectionView: defaultCollectionView, frame: CGRect(x: 10, y: 20, width: 100, height: 200))
        
        XCTAssertEqual(SUT.frame.minX, 10)
        XCTAssertEqual(SUT.frame.minY, 20)
        XCTAssertEqual(SUT.frame.width,100)
        XCTAssertEqual(SUT.frame.height, 200)
    }
    
    func  testMenuBarView_x8y59Width10Height20_isEqual()
    {
        let SUT = MenuBarView(collectionView: defaultCollectionView, frame: CGRect(x: 8, y: 59, width: 10, height: 20))
        
        XCTAssertEqual(SUT.frame.minX, 8)
        XCTAssertEqual(SUT.frame.minY, 59)
        XCTAssertEqual(SUT.frame.width,10)
        XCTAssertEqual(SUT.frame.height, 20)
    }
    
    func testMenuBarViewInit_LayoutConstraints_AnchoredLeftRightTopBottom()
    {
        var hasDesiredItemConstraints = false
        var hasLeftToLeftAnchor = false
        var hasRightToRightAnchor = false
        var hasTopToTopAnchor = false
        var hasBottomToBottomAnchor = false
        
        for constraint in SUT.constraints {
            if constraint.firstItem.isEqual(defaultCollectionView) && (constraint.secondItem?.isEqual(SUT))! {
               hasDesiredItemConstraints = true
                
                if constraint.firstAttribute == NSLayoutAttribute.left && constraint.secondAttribute == NSLayoutAttribute.left {
                    hasLeftToLeftAnchor = true
                }
                
                if constraint.firstAttribute == NSLayoutAttribute.right && constraint.secondAttribute == NSLayoutAttribute.right {
                    hasRightToRightAnchor = true
                }
                
                if constraint.firstAttribute == NSLayoutAttribute.top && constraint.secondAttribute == NSLayoutAttribute.top {
                    hasTopToTopAnchor = true
                }
                
                if constraint.firstAttribute == NSLayoutAttribute.bottom && constraint.secondAttribute == NSLayoutAttribute.bottom {
                    hasBottomToBottomAnchor = true
                }
            }
        }
        
        XCTAssertTrue(hasDesiredItemConstraints)
        XCTAssertTrue(hasLeftToLeftAnchor)
        XCTAssertTrue(hasRightToRightAnchor)
        XCTAssertTrue(hasTopToTopAnchor)
        XCTAssertTrue(hasBottomToBottomAnchor)
    }
    
    func testAddItem_oneItem_countIsOne()
    {
        // Arrange
        let menuItem = MenuBarTextItem("A")
        
        // Act
        SUT.addItem(menuBarItem: menuItem)
        
        // Assert
        XCTAssertEqual(SUT.itemCount(), 1)
        XCTAssertEqual(defaultCollectionView.numberOfItems(inSection: 0), 1)
    }
    
    func testAddItem_twoItems_countIsTwo()
    {
        // Arrange
        let menuItemOne = MenuBarTextItem("A")
        let menuItemTwo = MenuBarTextItem("A")
        
        // Act
        SUT.addItem(menuBarItem: menuItemOne)
        SUT.addItem(menuBarItem: menuItemTwo)
        
        // Assert
        XCTAssertEqual(SUT.itemCount(), 2)
        XCTAssertEqual(defaultCollectionView.numberOfItems(inSection: 0), 2)
    }
    
    func testMenuBarItems_1Item_willFillViewLengthOf10()
    {
        // Arrange
        SUT.frame = .init(x: 0, y: 0, width: 10, height: 10)
        let menuItemOne = MenuBarTextItem("A")
        
        // Act
        SUT.addItem(menuBarItem: menuItemOne)
        
        // Assert
        let flowLayoutDelegate = defaultCollectionView.delegate as! UICollectionViewDelegateFlowLayout
        
        let actualSize = flowLayoutDelegate.collectionView!(defaultCollectionView, layout: defaultCollectionView.collectionViewLayout, sizeForItemAt: NSIndexPath(item: 0, section: 0) as IndexPath)
        
        XCTAssertEqual(actualSize.width, SUT.frame.width)
    }
    
    func testMenuBarItems_1Item_willFillViewLengthOf50()
    {
        // Arrange
        SUT.frame = .init(x: 0, y: 0, width: 50, height: 10)
        let menuItemOne = MenuBarTextItem("A")
        
        // Act
        SUT.addItem(menuBarItem: menuItemOne)
        
        // Assert
        let flowLayoutDelegate = defaultCollectionView.delegate as! UICollectionViewDelegateFlowLayout
        
        let actualSize = flowLayoutDelegate.collectionView!(defaultCollectionView, layout: defaultCollectionView.collectionViewLayout, sizeForItemAt: NSIndexPath(item: 0, section: 0) as IndexPath)
        
        XCTAssertEqual(actualSize.width, SUT.frame.width)
    }
    
    func testMenuBarItems_ViewSize10With2Items_willFillLengthEqually()
    {
        // Arrange
        SUT.frame = .init(x: 0, y: 0, width: 10, height: 10)
        let menuItemOne = MenuBarTextItem("A")
        let menuItemTwo = MenuBarTextItem("A")
        
        // Act
        SUT.addItem(menuBarItem: menuItemOne)
        SUT.addItem(menuBarItem: menuItemTwo)
        
        // Assert
        let flowLayoutDelegate = defaultCollectionView.delegate as! UICollectionViewDelegateFlowLayout
        
        let actualSizeItemOne = flowLayoutDelegate.collectionView!(defaultCollectionView, layout: defaultCollectionView.collectionViewLayout, sizeForItemAt: NSIndexPath(item: 0, section: 0) as IndexPath)
        
        let actualSizeItemTwo = flowLayoutDelegate.collectionView!(defaultCollectionView, layout: defaultCollectionView.collectionViewLayout, sizeForItemAt: NSIndexPath(item: 1, section: 0) as IndexPath)
        
        XCTAssertEqual(actualSizeItemOne.width, SUT.frame.width/2)
        XCTAssertEqual(actualSizeItemTwo.width, SUT.frame.width/2)
    }
    
    func testInterItemSpacing_IsDefaultZero()
    {
        // Assert
        let flowLayoutDelegate = defaultCollectionView.delegate as! UICollectionViewDelegateFlowLayout
        
        let actualInterItemSpacing = flowLayoutDelegate.collectionView!(defaultCollectionView, layout: defaultCollectionView.collectionViewLayout, minimumInteritemSpacingForSectionAt: 0)
        
        XCTAssertEqual(actualInterItemSpacing, 0)
    }
    
    // test for content Delegate Manager
    func testClass_ConformsToContentSelectionDelegate()
    {
        // Arrange
    
        // Act
    
        // Assert
        XCTAssertTrue(SUT.conforms(to: ContenSelectedDelegate.self))
    }
}
