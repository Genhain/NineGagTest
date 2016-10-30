
import Foundation
import UIKit

class MenuBarItem: NSObject
{
    var iconView: UIView!
    
    public func setupIconView(parentView: UIView) {}
    public func selected(){}
    public func deselected(){}
}

class MenuBarTextItem: MenuBarItem
{
    private let defaultTextColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
    private let selectedTextColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
    
    public init(_ titleText: String) {
        super.init()
        
        let textLabel = UILabel(frame: .zero)
        
        textLabel.text = titleText
        textLabel.textAlignment = .center
        textLabel.textColor = defaultTextColor
        
        self.iconView = textLabel
    }
    
    override func setupIconView(parentView: UIView) {
        iconView.frame = .init(x: 0, y: 0, width: parentView.frame.width, height: parentView.frame.height)
    }
    
    public override func selected(){
        let textLabel = iconView as! UILabel
        
        textLabel.textColor = selectedTextColor
    }
    
    override func deselected() {
        let textLabel = iconView as! UILabel
        
        textLabel.textColor = defaultTextColor
    }
}

//class MenuBarImageItem: MenuBarItem
//{
//    public init(_ image: UIImage) {
//        super.init()
//        self.iconView = UIImageView(image: image)
//    }
//    
//    override func setupIconView(parentView: UIView) {
//        self.iconView.translatesAutoresizingMaskIntoConstraints = false
//        
//        NSLayoutConstraint.activate([
//            iconView.centerXAnchor.constraint(equalTo: parentView.centerXAnchor, constant: 0),
//            iconView.centerYAnchor.constraint(equalTo: parentView.centerYAnchor, constant: 0)
//            ])
//    }
//    public func selected(){}
//}
