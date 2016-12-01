
import Foundation
import UIKit

extension UIImage
{
    static func testImage(size: CGSize, color: UIColor) -> UIImage {
        
        UIGraphicsBeginImageContext(size)
        color.setFill()
        UIRectFill(.init(x: 0, y: 0, width: size.width, height: size.height))
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }
    
    func hasEqualData(otherImage: UIImage) -> Bool {
        
        let thisImgData = UIImagePNGRepresentation(self)!
        let thatImgData = UIImagePNGRepresentation(otherImage)!
        
        var retVal = false
        
        if thisImgData == thatImgData {
            retVal = true
        }
        
        return retVal
    }
}
