

import Foundation
import UIKit
import Dispatch

class MenuBarView: UIView, ContentSelectedDelegate
{
    let collectionView : UICollectionView
    fileprivate var menuBarItems : [MenuBarItem] = []
    let cellId = "menuBarCell"
    
    
    //MARK: Startup
    init(collectionView: UICollectionView, frame: CGRect) {
        self.collectionView = collectionView
        super.init(frame: frame)
        
        self.setupCollectionView()
        self.setupHorizontalSelectionBar()
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        super.init(coder: aDecoder)
        
        self.setupCollectionView()
        self.setupHorizontalSelectionBar()
    }
    
    private func setupCollectionView() {
        collectionView.register(MenuItemCell.self, forCellWithReuseIdentifier: cellId)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        
        self.addSubview(collectionView)
        
        NSLayoutConstraint.activate([
            collectionView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 0),
            collectionView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: 0),
            collectionView.topAnchor.constraint(equalTo: self.topAnchor, constant: 0),
            collectionView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0)
            ])
    }
    var horizontalBarLeftAnchorConstraint: NSLayoutConstraint?
    
    private func setupHorizontalSelectionBar() {
        let horizontalSelectionBarView = UIView()
        horizontalSelectionBarView.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        horizontalSelectionBarView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(horizontalSelectionBarView)
        
        horizontalBarLeftAnchorConstraint = horizontalSelectionBarView.leftAnchor.constraint(equalTo: self.leftAnchor)
        NSLayoutConstraint.activate([
            horizontalBarLeftAnchorConstraint!,
            horizontalSelectionBarView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            horizontalSelectionBarView.heightAnchor.constraint(equalToConstant: 8),
            horizontalSelectionBarView.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier:CGFloat(1/max(1, itemCount())))
        ])
    }
    
    var contentSelectionManager: ContentSelectionManager!
    func setContentDelegationManager(_ contentSelectionManager: ContentSelectionManager) {
        self.contentSelectionManager = contentSelectionManager
    }
    
    //MARK: Functionality
    public func addItem(menuBarItem: MenuBarItem) {
        menuBarItems.append(menuBarItem)
        
        self.collectionView.collectionViewLayout.invalidateLayout()
        self.collectionView.reloadData()
        
        // Auto Select First item
        if self.menuBarItems.count == 1 {
            self.selectDefaultItem()
        }
        
    }
    
    public func addItems(newMenuBarItems: [MenuBarItem]) {
        
        var isAddingToEmpty = false
        if self.itemCount() == 0 {
            isAddingToEmpty = true
        }
        
        menuBarItems.append(contentsOf: newMenuBarItems)
        
        self.collectionView.collectionViewLayout.invalidateLayout()
        self.collectionView.reloadData()
        
        if isAddingToEmpty {
            self.selectDefaultItem()
        }
    }
    
    private func selectDefaultItem() {
        
        DispatchQueue.main.async{
            self.collectionView(self.collectionView,
                                didSelectItemAt: IndexPath(item: 0, section: 0))
        }
    }
    
    public func removeItem(itemIndex: Int) {
        menuBarItems.remove(at: itemIndex)
    }
    
    public func removeAllItems() {
        menuBarItems.removeAll()
    }
    
    public func itemCount() -> Int {
        return menuBarItems.count
    }
    
    public  func item(atIndex: Int) -> MenuBarItem {
        return menuBarItems[atIndex]
    }
    
    //MARK: ContenSelectedDelegate
    func selectContent(forIndex: Int) {
        
        for menuItem in self.menuBarItems {
            menuItem.deselected()
        }
        let menuItem = self.menuBarItems[forIndex]
        
        menuItem.selected()
    }
    
}

extension MenuBarView: UICollectionViewDataSource
{
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.itemCount()
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! MenuItemCell
        
        cell.clear()
        
        cell.setup(menuItem: self.menuBarItems[indexPath.item])
        
        return cell
    }
}

extension MenuBarView: UICollectionViewDelegate
{
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        contentSelectionManager.contentSelected(atIndex: indexPath.item)
    }
}

extension MenuBarView: UICollectionViewDelegateFlowLayout
{
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.frame.width/CGFloat(self.itemCount()), height: self.frame.height)
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}

class MenuItemCell: UICollectionViewCell
{
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.contentView.autoresizingMask.insert(.flexibleWidth)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func clear() {
        
    }
    
    override func prepareForReuse() {
        for subview in self.contentView.subviews {
            subview.removeFromSuperview()
        }
    }
    
    public func setup(menuItem: MenuBarItem) {
    
        self.contentView.addSubview(menuItem.iconView)
        menuItem.setupIconView(parentView: self.contentView)
    }
}
