
import Foundation
import UIKit

class HomePageCollectionView: UICollectionView
{
    var cellDataProviders: [CellContentDataProvider]
    
    required init?(coder aDecoder: NSCoder) {
        cellDataProviders = []
        super.init(coder: aDecoder)
    }
    
    func setHorizontalCollectionViewDataProvider(cellDataProvider: CellContentDataProvider)
    {
        self.dataSource = cellDataProvider.dataSource
        self.delegate = cellDataProvider.delegate
    }
}

