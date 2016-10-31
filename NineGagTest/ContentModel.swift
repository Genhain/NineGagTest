
import Foundation


class ContentModel
{
    var contentImageName: String
    var imageWidth: Int
    var imageHeight: Int
    var titleText: String
    
    init(contentImageName: String,imageWidth: Int, imageHeight: Int, titleText: String) {
        self.contentImageName = contentImageName
        self.imageWidth = imageWidth
        self.imageHeight = imageHeight
        self.titleText = titleText
    }
}
