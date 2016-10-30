
import Foundation
import UIKit

class HorizontalContentCollectionView: UICollectionView
{
    
}

extension HorizontalContentCollectionView: UICollectionViewDataSource
{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HorizontalContentCell", for: indexPath)
        
        return cell
    }
}

extension HorizontalContentCollectionView: UICollectionViewDelegate
{
    
}
