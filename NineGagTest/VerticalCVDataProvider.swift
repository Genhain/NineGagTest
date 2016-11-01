
import Foundation
import UIKit

class VerticalCVDataProvider: CollectionViewDataProvider
{
    
}

extension VerticalCVDataProvider: UICollectionViewDataSource, UICollectionViewDelegate
{
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data!.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: ContentCell.self), for: indexPath) as! ContentCell
        

        cell.initialiseData(content: self.data![indexPath.item], imageCache: self.imageCache) {
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
        
        let contentModel = self.data![indexPath.item]
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
