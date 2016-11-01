
import Foundation
import UIKit

protocol contentScrollDelegate
{
    func contentViewDidScroll(_ contentView: UIScrollView, contentOffset: CGPoint)
}

class VerticalCVDataProvider: NSObject
{
    var data: CellContentDataProvider?
    var contentScrollDelegate: contentScrollDelegate?
    let imageCache: NSCache = NSCache<NSString, UIImage>()
}

extension VerticalCVDataProvider: UICollectionViewDataSource, UICollectionViewDelegate
{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data!.contents.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: ContentCell.self), for: indexPath) as! ContentCell
        

        cell.initialiseData(content: self.data!.contents[indexPath.item], imageCache: self.imageCache) {
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
        
        let contentModel = self.data!.contents[indexPath.item]
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
