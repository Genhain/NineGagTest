
import Foundation
import UIKit

class MenuBarItem: NSObject
{
    var iconView: UIView!
    
    public func clear(){}
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
        
        textLabel.adjustsFontSizeToFitWidth = true
        
        self.iconView = textLabel
    }
    
    override func clear() {
        iconView.removeFromSuperview()
        iconView = nil
    }
    
    override func setupIconView(parentView: UIView) {
        
        iconView.frame = iconView.centerView(inView: parentView, withPadding: Float(parentView.frame.width) * Float(0.1))
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

extension UIView
{
    func centerView(inView view: UIView, withPadding padding: Float) ->CGRect {
        
        var point = CGPoint(x: 0, y: 0)
        let size = CGSize(width: view.frame.width - CGFloat(padding * 2),
                          height: view.frame.height - CGFloat(padding * 2))
        
        point.x = CGFloat(padding)
        point.y = CGFloat(padding)
        
        return .init(origin: point, size: size)
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
