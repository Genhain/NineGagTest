
import Foundation
import UIKit

class HomePageCollectionView: UICollectionView
{
    func setCollectionViewDataProvider(cellDataProvider: CellContentDataProvider)
    {
        self.dataSource = cellDataProvider.dataSource
        self.delegate = cellDataProvider.delegate
    }
}
