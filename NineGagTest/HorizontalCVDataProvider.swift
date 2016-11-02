
import Foundation
import UIKit


class HorizontalCVDataProvider: CollectionViewDataProvider
{
    
}

extension HorizontalCVDataProvider: UICollectionViewDataSource, UICollectionViewDelegate
{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data![section].count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: HorizontalContentCell.self), for: indexPath) as! HorizontalContentCell
        
        cell.contentImageView.image = UIImage(named: data![indexPath.section][indexPath.item].contentImageName)
        cell.contentImageView.contentMode = .scaleAspectFill
        cell.contentImageView.layer.masksToBounds = true
        
        cell.contentTextLabel.text = data![indexPath.section][indexPath.item].titleText
        
        
        return cell
    }
}

extension HorizontalCVDataProvider: UICollectionViewDelegateFlowLayout
{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: 200, height: 200)
    }
}
    
