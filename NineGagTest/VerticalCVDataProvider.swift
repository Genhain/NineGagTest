
import Foundation
import UIKit

class VerticalCVDataProvider: NSObject
{
    var data: CellContentDataProvider?
}

extension VerticalCVDataProvider: UICollectionViewDataSource, UICollectionViewDelegate
{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data!.contents.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: verticalCellId), for: indexPath) as! ContentCell
        
        cell.initialiseData(content: self.data!.contents[indexPath.item])
        
        return cell
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
    }
}

extension VerticalCVDataProvider: UICollectionViewDelegateFlowLayout
{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    
         let contentModel = self.data!.contents[indexPath.item]
         let imageView = UIImageView(image: UIImage(named: contentModel.contentImageName))
        
        if imageView.image == nil {
            return CGSize(width: collectionView.frame.width, height: 400)
        }
        
         let aspectHeight = (imageView.frame.height / imageView.frame.width) * collectionView.frame.width

        return CGSize(width: collectionView.frame.width, height: aspectHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}
