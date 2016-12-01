//
//  ViewController.swift
//  NineGagTest
//
//  Created by Ben Fowler on 27/10/2016.
//  Copyright © 2016 BF. All rights reserved.
//

import UIKit
import CoreData

let verticalCellId = "verticalCellID"
let horizontalCellID = "HorizontalContentContainerCell"
let demoJSONURLString = "https://api.myjson.com/bins/2razy"

class HomePageController: UIViewController, ContentSelectedDelegate
{
    private var frc: NSFetchedResultsController<Category>!
    // Collections
    var contentData: [Category] = []
    private var hasLoadedContent = false
    
    var categoryCVDataProvider: CategoryCVDataProvider!
    var horizontalCVDataProvider: HorizontalCVDataProvider!
    
    @IBOutlet weak var menuBarView: MenuBarView!
    @IBOutlet weak var verticalCollectionView: HomePageCollectionView!
    @IBOutlet weak var horizontalCollectionView: HomePageCollectionView!
    @IBOutlet weak var horizontalCollectionViewHeightConstraint: NSLayoutConstraint!
    
    internal let contentDelegationManager = ContentSelectionManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        contentDelegationManager.contentSelectionDelegate(add: menuBarView)
        contentDelegationManager.contentSelectionDelegate(add: self)
        menuBarView.setContentDelegationManager(self.contentDelegationManager)
        
        self.categoryCVDataProvider = CategoryCVDataProvider(collectionView: self.verticalCollectionView)
        self.horizontalCVDataProvider = HorizontalCVDataProvider(collectionView: self.horizontalCollectionView)

        
        self.attempFetch()
        
        self.setUpCategories()
        
        self.fetchJSON {
            
            DispatchQueue.main.async {
                
            self.setUpCategories()
            
            self.categoryCVDataProvider.contentScrollDelegate = self
            
            self.horizontalCVDataProvider.data = []
            self.categoryCVDataProvider.data = self.contentData
            
            self.verticalCollectionView.setCollectionViewDataProvider(cellDataProvider: self.categoryCVDataProvider)
            self.horizontalCollectionView.setCollectionViewDataProvider(cellDataProvider: self.horizontalCVDataProvider)
            
            
                self.hasLoadedContent = true
                self.verticalCollectionView.reloadData()
                self.horizontalCollectionView.reloadData()
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setUpCategories()  {
        guard let categories = self.frc.fetchedObjects else { return }
        
        for category in categories {
            if let categoryTitle = category.title {
                
                self.menuBarView.addItem(menuBarItem: MenuBarTextItem(categoryTitle.uppercased()))
            }
        }
    }
    
    private func fetchJSON(completion: @escaping () -> Void)
    {
 
//        URLSession.shared.dataTask(with:  URL(string: demoJSONURLString)!) { (data, response, error) in
//            
//            if error != nil {
//                print(error)
//                return
//            }
//            
//            do {
//                let json = try JSONSerialization.jsonObject(with: data!, options: [.mutableContainers])
//                
//                self.parseJSON(json: json as! [String: [String: AnyObject]],completion: completion)
//                
//            } catch let jsonError {
//                print(jsonError)
//            }
//            
//        }.resume()
    }
    
    private func parseJSON(json: [String: [String: AnyObject]], completion: () -> Void) {
        
        _ = json.sorted { (A: (key: String, value: [String : AnyObject]), B: (key: String, value: [String : AnyObject])) -> Bool in
            
            if A.key == "id" && B.key == "id" {
                
            }
            
            return true
        }
            
        
        
//        for category in json {
//            
//            var categoryObject: Category?
//            
//            if !self.persistentContainerContainsObject(Category.self, forIdentifier: category.key, forAttribute: "title", sortKey: "title") {
//                categoryObject = Category(context: coreDataStack.persistentContainer.viewContext)
//                categoryObject!.title = category.key
//            }
//            
//            
//            var categoryContent: [Category] = []
//            
//            for dictionary in category.value {
//                
//                let id = dictionary["id"] as? String
//                let contentURL = dictionary["contentImageName"] as? String
//                let text = dictionary["titleText"] as? String
//                
//                if self.persistentContainerContainsObject(Post.self, forIdentifier: id!, forAttribute: "id", sortKey: "created") {continue}
//                
//                let image = Image(context: coreDataStack.persistentContainer.viewContext)
//                self.loadImage(fromURL: URL.init(string: contentURL!)!, completion: { (loadedImage) in
//                    
//                    image.image = loadedImage
//                    self.verticalCollectionView.reloadData()
//                })
//                
//                let postObject = Post(context: coreDataStack.persistentContainer.viewContext)
//                postObject.toImage = image
//                postObject.title = text
//                postObject.id = id
//                
//                guard let categoryEntity = categoryObject else {continue}
//                
//                categoryEntity.addToToPost(postObject)
//                categoryContent.append(categoryEntity)
//            }
//            contentData = categoryContent
//        }
//        
//        coreDataStack.saveContext()
//        
//        completion()
    }
    
    private func persistentContainerContainsObject<T:NSManagedObject>(_: T.Type, forIdentifier identifier: String, forAttribute attribute: String, sortKey: String) -> Bool {
        
        let fetch = T.fetchRequest() as! NSFetchRequest<T>
        fetch.sortDescriptors = [NSSortDescriptor(key: sortKey, ascending: true)]
        
        fetch.predicate = NSPredicate(format: "%K = %@", attribute, identifier)
        
        let controller = NSFetchedResultsController(fetchRequest: fetch, managedObjectContext: coreDataStack.persistentContainer.viewContext, sectionNameKeyPath: nil, cacheName: nil)
        
        do {
            try controller.performFetch()
        } catch  {
            print(error.localizedDescription)
        }
        
        if let fetchedObjects = controller.fetchedObjects,
            fetchedObjects.count == 0 { return false }
        
        return true
    }
    
    func attempFetch() {
        
        let fetch: NSFetchRequest<Category> = Category.fetchRequest()
        let dateSort = NSSortDescriptor(key: "title", ascending: false)
        fetch.sortDescriptors = [dateSort]
        
        let controller = NSFetchedResultsController(fetchRequest: fetch, managedObjectContext: coreDataStack.persistentContainer.viewContext, sectionNameKeyPath: nil, cacheName: nil)
        controller.delegate = self.categoryCVDataProvider
        
        
        do {
            try controller.performFetch()
        } catch  {
            let error = error as NSError
            print("\(error)")
        }
        
        self.frc = controller
        self.categoryCVDataProvider.frc = controller
    }
    
    func deleteAll() {
        let fetchRequest:NSFetchRequest<Category> = Category.fetchRequest()
        
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest as! NSFetchRequest<NSFetchRequestResult>)
        
        let persistCor:NSPersistentStoreCoordinator = coreDataStack.persistentContainer.persistentStoreCoordinator
        do {
            try persistCor.execute(deleteRequest, with: coreDataStack.persistentContainer.viewContext)
            try coreDataStack.persistentContainer.viewContext.save()
        }
        catch {
            print(error)
        }
        
        coreDataStack.saveContext()
    }
    
    func loadImage(fromURL URL: URL, completion: @escaping (_ image: UIImage) -> Void) {
        
        DispatchQueue.global().async {
            
            if let imageData = try? Data.init( contentsOf: URL) {
                
                let image = UIImage(data: imageData as Data)
                
                DispatchQueue.main.async {
                    completion(image!)
                }
            }
        }
    }
    
    func selectContent(forIndex: Int) {
        
        if hasLoadedContent {
            verticalCollectionView.scrollToItem(at: .init(item: forIndex, section: 0), at: .left, animated: true)
        }
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
            contentView.contentOffset = CGPoint(x: contentOffset.x, y: 0)
        }
       
        menuBarView.horizontalBarLeftAnchorConstraint?.constant = contentOffset.x / CGFloat(menuBarView.itemCount())
        horizontalCollectionViewHeightConstraint.constant = CGFloat(contentYOffsetDelta)
        self.verticalCollectionView.collectionViewLayout.invalidateLayout()
    }
    
    func contentDidEndDecelerating(_ contentView: UIScrollView) {
        
        var menuNumber = Int(round(contentView.contentOffset.x / menuBarView.frame.size.width))
        menuNumber = min(menuBarView.itemCount(), menuNumber)
        menuNumber = max(0, menuNumber)
        
        menuBarView.selectContent(forIndex: menuNumber)
    }
}

