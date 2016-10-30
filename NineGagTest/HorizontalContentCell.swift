
import Foundation
import UIKit

class HorizontalContentCell: UICollectionViewCell
{
    @IBOutlet weak var contentImageView: UIImageView!
    @IBOutlet weak var contentTextLabel: UILabel!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.layer.cornerRadius = 5
    }
}
