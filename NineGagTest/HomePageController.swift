//
//  ViewController.swift
//  NineGagTest
//
//  Created by Ben Fowler on 27/10/2016.
//  Copyright © 2016 BF. All rights reserved.
//

import UIKit

let verticalCellId = "verticalCellID"
let horizontalCellID = "HorizontalContentContainerCell"

class HomePageController: UIViewController
{
    var dataSource: [CellContentDataProvider] = []
    let verticalDataSource = VerticalCVDataProvider()
    let horizontalDataSource = HorizontalCVDataProvider()
    var horizontalDataProvider: CellContentDataProvider!
    var verticalDataProvider: CellContentDataProvider!
    
    @IBOutlet weak var menuBarView: MenuBarView!
    @IBOutlet weak var homePageCollectionView: HomePageCollectionView!
    
    private let contentDelegationManager = ContentSelectionManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        contentDelegationManager.contentSelectionDelegate(add: menuBarView)
        
        // Static Settings
        menuBarView.addItem(menuBarItem: MenuBarTextItem("HOT"))
        menuBarView.addItem(menuBarItem: MenuBarTextItem("TRENDING"))
        menuBarView.addItem(menuBarItem: MenuBarTextItem("FRESH"))
        
        // Mock data
        let first = ContentModel(contentImageName: "Rammit", titleText: "OMW LOLOLOL TROLL Face")
        let second = ContentModel(contentImageName: "Jake", titleText: "Now just need Finn the human")
        let third = ContentModel(contentImageName: "Archer", titleText: "Danger Zone")
        
       
        horizontalDataProvider = CellContentDataProvider(contents: [third,second],
                                                         dataSource: horizontalDataSource,
                                                         delegate: horizontalDataSource,
                                                         layout: UICollectionViewFlowLayout())
        
        verticalDataProvider = CellContentDataProvider(contents: [first,second,third],
                                                       dataSource: verticalDataSource,
                                                       delegate: verticalDataSource,
                                                       layout: UICollectionViewFlowLayout())
        
        dataSource.append(contentsOf: [horizontalDataProvider,verticalDataProvider])
        
        homePageCollectionView.dataSource = verticalDataProvider.dataSource
        homePageCollectionView.delegate = verticalDataProvider.delegate
        
        horizontalDataSource.data = horizontalDataProvider
        verticalDataSource.data = verticalDataProvider
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

