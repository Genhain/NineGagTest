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
let demoJSONURLString = "https://api.myjson.com/bins/3uaoq"

class HomePageController: UIViewController
{
    var contentData: [ContentModel] = []
    var dataSource: [CellContentDataProvider] = []
    let verticalDataSource = VerticalCVDataProvider()
    let horizontalDataSource = HorizontalCVDataProvider()
    var horizontalDataProvider: CellContentDataProvider!
    var verticalDataProvider: CellContentDataProvider!
    
    @IBOutlet weak var menuBarView: MenuBarView!
    @IBOutlet weak var homePageCollectionView: HomePageCollectionView!
    @IBOutlet weak var horizontalCollectionView: HomePageCollectionView!
    @IBOutlet weak var horizontalCollectionViewHeightConstraint: NSLayoutConstraint!
    
    private let contentDelegationManager = ContentSelectionManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        contentDelegationManager.contentSelectionDelegate(add: menuBarView)
        
        // Static Settings
        menuBarView.addItem(menuBarItem: MenuBarTextItem("HOT"))
        menuBarView.addItem(menuBarItem: MenuBarTextItem("TRENDING"))
        menuBarView.addItem(menuBarItem: MenuBarTextItem("FRESH"))
        
        // Mock data
        
        let first = ContentModel(contentImageName: "Rammit", imageWidth: 600, imageHeight: 596, titleText: "OMW LOLOLOL TROLL Face")
        let second = ContentModel(contentImageName: "Jake", imageWidth: 1280, imageHeight: 1810, titleText: "Muh-muh-muh Money")
        let third = ContentModel(contentImageName: "Archer", imageWidth: 2448, imageHeight: 3264, titleText: "Danger Zone")
        
        self.fetchJSON {
            
            self.horizontalDataProvider = CellContentDataProvider(contents: [third,second,first],
                                                             dataSource: self.horizontalDataSource,
                                                             delegate: self.horizontalDataSource,
                                                             layout: UICollectionViewFlowLayout())
            
            self.verticalDataSource.contentScrollDelegate = self
            self.verticalDataProvider = CellContentDataProvider(contents: self.contentData,
                                                           dataSource: self.verticalDataSource,
                                                           delegate: self.verticalDataSource,
                                                           layout: UICollectionViewFlowLayout())
            
            self.homePageCollectionView.setCollectionViewDataProvider(cellDataProvider: self.verticalDataProvider)
            
            self.horizontalCollectionView.setCollectionViewDataProvider(cellDataProvider: self.horizontalDataProvider)
            
            self.horizontalDataSource.data = self.horizontalDataProvider
            self.verticalDataSource.data = self.verticalDataProvider
            
            self.dataSource.append(contentsOf: [self.horizontalDataProvider,self.verticalDataProvider])
            
            DispatchQueue.main.async {
                self.homePageCollectionView.reloadData()
                self.horizontalCollectionView.reloadData()
            }
            
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func fetchJSON(completion: @escaping () -> Void)
    {
        URLSession.shared.dataTask(with: (with: URL(string: demoJSONURLString)!)) { (data, response, error) in
            
            if error != nil {
                print(error)
                return
            }
            
            do {
                let json = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers)
                
                self.parseJSON(json: json as! [[String : AnyObject]],completion: completion)
                
            } catch let jsonError {
                print(jsonError)
            }
            
        }.resume()
    }
    
    private func parseJSON(json: [[String: AnyObject]], completion: () -> Void) {
        for dictionary in json {
            
            let contentURL = dictionary["contentImageName"] as? String
            let text = dictionary["titleText"] as? String
            let dimensions = dictionary["dimensions"] as? [String: String]
            let widthString = dimensions?["width"]
            let heightString = dimensions?["height"]
            let content = ContentModel(contentImageName: contentURL!, imageWidth: Int(widthString!)!, imageHeight: Int(heightString!)!, titleText: text!)
            
            
            contentData.append(content)
        }
        
        completion()
    }
}

private var contentYOffsetDelta: CGFloat = 0
extension HomePageController: contentScrollDelegate
{
    func contentViewDidScroll(_ contentView: UIScrollView, contentOffset: CGPoint) {
        
        contentYOffsetDelta += -contentOffset.y
        
        contentYOffsetDelta = min(contentYOffsetDelta, 0)
        contentYOffsetDelta = max(contentYOffsetDelta, -200)
        
        if contentYOffsetDelta > -200 {
            contentView.contentOffset = .zero
        }
       
        horizontalCollectionViewHeightConstraint.constant = CGFloat(contentYOffsetDelta)
    }
}

