
import Foundation
import UIKit

class HorizontalContentContainerCell: UICollectionViewCell
{
    @IBOutlet weak var collectionView: HorizontalContentCollectionView!
    let reuseChildCollectionViewCellIdentifier = "HorizontalContentCell"
    
    var collectionViewDataSource : UICollectionViewDataSource!
    
    var collectionViewDelegate : UICollectionViewDelegate!
}

extension HorizontalContentContainerCell
{
    var collectionViewOffset: CGFloat {
        set {
            collectionView.contentOffset.x = newValue
        }
        
        get {
            return collectionView.contentOffset.x
        }
    }
    
    func initializeCollectionViewWithDataSource<D: UICollectionViewDataSource,E: UICollectionViewDelegate>(_ dataSource: D, delegate :E, forRow row: Int) {
        
        collectionView.delegate = delegate
        collectionView.dataSource = dataSource
        collectionView.tag = row
        
        collectionView.reloadData()
    }
}

extension HorizontalContentContainerCell: UICollectionViewDataSource
{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return self.collectionView.dataSource!.collectionView(self.collectionView, numberOfItemsInSection: section)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    
        return self.collectionView.dataSource!.collectionView(self.collectionView, cellForItemAt: indexPath)
    }
}
