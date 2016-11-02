//
//  CategoryCell.swift
//  NineGagTest
//
//  Created by Ben Fowler on 2/11/2016.
//  Copyright © 2016 BF. All rights reserved.
//

import UIKit

class CategoryCell: UICollectionViewCell {
    
    let collectionView: UICollectionView = {
       let cv = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        return cv
    }()
    
    var collectionViewDataProvider = VerticalCVDataProvider()
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        addSubview(self.collectionView)
        
        NSLayoutConstraint.activate([
            collectionView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 0),
            collectionView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: 0),
            collectionView.topAnchor.constraint(equalTo: self.topAnchor, constant: 0),
            collectionView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0)
            ])
        
        collectionView.register(ContentCell.self, forCellWithReuseIdentifier: String(describing: ContentCell.self))
        
        
        
        self.collectionView.delegate = self.collectionViewDataProvider
        self.collectionView.dataSource = self.collectionViewDataProvider
    }
    
    func setDataSource(_ dataSource: [ContentModel]) {
        
        self.collectionViewDataProvider.data = [dataSource]
    }
    
    func setContentScrollDelegate(_ scrollDelegate: contentScrollDelegate) {
        self.collectionViewDataProvider.contentScrollDelegate = scrollDelegate
    }
}

class VerticalCVDataProvider: CollectionViewDataProvider
{
    
}

extension VerticalCVDataProvider: UICollectionViewDataSource, UICollectionViewDelegate
{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: ContentCell.self), for: indexPath) as! ContentCell
        
         cell.initialiseContent(self.data![indexPath.section][indexPath.item], imageCache: self.imageCache) {
         collectionView.reloadData()
         collectionView.invalidateIntrinsicContentSize()
         collectionView.collectionViewLayout.invalidateLayout()
         }
        
        return cell
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offset = scrollView.contentOffset
        self.contentScrollDelegate?.contentViewDidScroll(scrollView,contentOffset: offset)
    }
}

extension VerticalCVDataProvider: UICollectionViewDelegateFlowLayout
{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
         let contentModel = self.data![indexPath.section][indexPath.item]
         let image = imageCache.object(forKey: contentModel.contentImageName as NSString)
         
         if image == nil {
         return CGSize(width: collectionView.frame.width, height: 400)
         }
         
         let aspectHeight = ((image?.size.height)! / (image?.size.width)!) * collectionView.frame.width
         
         return CGSize(width: collectionView.frame.width, height: aspectHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}
