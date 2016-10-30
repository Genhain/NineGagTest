
import Foundation
import UIKit

class CellContentDataProvider
{
    var contents: [ContentModel]
    var dataSource: UICollectionViewDataSource
    var delegate: UICollectionViewDelegate
    var layout: UICollectionViewLayout
    
    init(contents: [ContentModel],
         dataSource: UICollectionViewDataSource,
         delegate: UICollectionViewDelegate,
         layout: UICollectionViewLayout) {
        self.contents = contents
        self.dataSource = dataSource
        self.delegate = delegate
        self.layout = layout
    }
}
