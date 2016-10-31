

import Foundation
import UIKit
import Dispatch

class MenuBarView: UIView, ContenSelectedDelegate
{
    private let collectionView : UICollectionView
    var menuBarItems : [MenuBarItem] = []
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
            horizontalSelectionBarView.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier:1/3)
        ])
    }
    
    //MARK: Functionality
    public func addItem(menuBarItem: MenuBarItem) {
        menuBarItems.append(menuBarItem)
        
        // Auto Select First item
        if self.menuBarItems.count == 1 {
            self.collectionView.reloadData()
            DispatchQueue.main.async{
                self.collectionView(self.collectionView, didSelectItemAt: NSIndexPath(item: 0, section: 0) as IndexPath)
            }
        }
    }
    
    public func itemCount() -> Int {
        return menuBarItems.count
    }
    
    public  func item(atIndex: Int) -> MenuBarItem {
        return menuBarItems[atIndex]
    }
    
    //MARK: ContenSelectedDelegate
    func selectContent(forIndex: Int) {
        
    }
}

extension MenuBarView: UICollectionViewDataSource
{
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.itemCount()
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! MenuItemCell
        
        cell.setup(menuItem: self.menuBarItems[indexPath.item])
        
        return cell
    }
}

extension MenuBarView: UICollectionViewDelegate
{
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        for menuItem in self.menuBarItems {
            menuItem.deselected()
        }
        let menuItem = self.menuBarItems[indexPath.item]
        
        let x = CGFloat(indexPath.item) * frame.width / 3
        horizontalBarLeftAnchorConstraint?.constant = x
        
        UIView.animate(withDuration: 0.45,
                       delay: 0,
                       usingSpringWithDamping: 1,
                       initialSpringVelocity: 1,
                       options: .curveEaseInOut,
                       animations: {
            self.layoutIfNeeded()
            }, completion: nil)
        
        menuItem.selected()
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
    public func setup(menuItem: MenuBarItem) {        
        self.contentView.addSubview(menuItem.iconView)
        menuItem.setupIconView(parentView: self.contentView)
    }
}
