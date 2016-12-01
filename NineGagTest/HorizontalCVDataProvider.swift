
import Foundation
import UIKit


class HorizontalCVDataProvider: CollectionViewDataProvider
{
    
}

extension HorizontalCVDataProvider: UICollectionViewDataSource, UICollectionViewDelegate
{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: HorizontalContentCell.self), for: indexPath) as! HorizontalContentCell
        
        let posts = self.data![indexPath.section].toPost!.allObjects
        let sortedPosts = posts.sorted { (A, B) -> Bool in
            
            if let postACreationDate = (A as! Post).created {
                if let postBCreationDate = (B as! Post).created {
                    
                    switch postACreationDate.compare(postBCreationDate as Date) {
                    case .orderedAscending:
                        return true
                    case .orderedDescending:
                        return false
                    case.orderedSame:
                        return false
                    }
                }
            }
            
            return false
        }
        
        let post = sortedPosts[indexPath.item] as! Post
        
        let image = post.toImage?.image as? UIImage
        
        cell.contentImageView.image = image
        cell.contentImageView.contentMode = .scaleAspectFill
        cell.contentImageView.layer.masksToBounds = true
        
//        cell.contentTextLabel.text = data![indexPath.section][indexPath.item].titleText
        
        
        return cell
    }
}

extension HorizontalCVDataProvider: UICollectionViewDelegateFlowLayout
{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: 200, height: 200)
    }
}
    
