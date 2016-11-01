
import Foundation
import UIKit

class HomePageCollectionView: UICollectionView
{
    func setCollectionViewDataProvider<D: UICollectionViewDataSource & UICollectionViewDelegate>(cellDataProvider: D)
    {
        self.dataSource = cellDataProvider
        self.delegate = cellDataProvider
    }
}
