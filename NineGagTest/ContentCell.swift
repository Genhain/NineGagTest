
import Foundation
import UIKit

class ContentCell: UICollectionViewCell
{
    var contentModel: ContentModel?
    
    var contentImageView: UIImageView
    
    var titleLabel: UILabel
    
    let seperatorView: UIView = {
        let view = UIView()
        view.backgroundColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
        return view
    }()
    
    let upvoteButton: UIButton = {
       let button = UIButton()
        button.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        button.layer.cornerRadius = 2
        button.setImage(#imageLiteral(resourceName: "Vote Up"), for: .normal)
        button.imageEdgeInsets = .init(top: 2, left: 5, bottom: 2, right: 5)
        return button
    }()
    
    let downVoteButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        button.layer.cornerRadius = 2
        button.setImage(#imageLiteral(resourceName: "Vote Down"), for: .normal)
        button.imageEdgeInsets = .init(top: 2, left: 5, bottom: 2, right: 5)
        return button
    }()
    
    let discussButton: UIButton = {
        let button = UIButton()
        button.setImage(#imageLiteral(resourceName: "Speech Bubble"), for: .normal)
        button.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        button.layer.cornerRadius = 2
        button.imageEdgeInsets = .init(top: 2, left: 5, bottom: 2, right: 5)
        return button
    }()
    
    override init(frame: CGRect) {
        self.contentImageView = UIImageView()
        self.titleLabel = UILabel()
        
        super.init(frame: frame)
        
        contentImageView.translatesAutoresizingMaskIntoConstraints = false
        seperatorView.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        upvoteButton.translatesAutoresizingMaskIntoConstraints = false
        downVoteButton.translatesAutoresizingMaskIntoConstraints = false
        discussButton.translatesAutoresizingMaskIntoConstraints = false
        
        self.addSubview(contentImageView)
        self.addSubview(seperatorView)
        self.addSubview(titleLabel)
        self.addSubview(upvoteButton)
        self.addSubview(downVoteButton)
        self.addSubview(discussButton)
        
        NSLayoutConstraint.activate([
            titleLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 16),
            titleLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: 0),
            titleLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 10),
            titleLabel.heightAnchor.constraint(equalToConstant: 20)
            ])
        
        NSLayoutConstraint.activate([
            contentImageView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 0),
            contentImageView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: 0),
            contentImageView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 5),
            contentImageView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -60)
        ])
        
        NSLayoutConstraint.activate([
            seperatorView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 0),
            seperatorView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: 0),
            seperatorView.heightAnchor.constraint(equalToConstant: 1),
            seperatorView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0)
            ])
        
        NSLayoutConstraint.activate([
            upvoteButton.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 16),
            upvoteButton.widthAnchor.constraint(equalToConstant: 50),
            upvoteButton.heightAnchor.constraint(equalToConstant: 30),
            upvoteButton.topAnchor.constraint(equalTo: contentImageView.bottomAnchor, constant: 15)
            ])
        
        NSLayoutConstraint.activate([
            downVoteButton.leftAnchor.constraint(equalTo: upvoteButton.rightAnchor, constant: 16),
            downVoteButton.widthAnchor.constraint(equalToConstant: 50),
            downVoteButton.heightAnchor.constraint(equalToConstant: 30),
            downVoteButton.topAnchor.constraint(equalTo: contentImageView.bottomAnchor, constant: 15)
            ])
        
        NSLayoutConstraint.activate([
            discussButton.leftAnchor.constraint(equalTo: downVoteButton.rightAnchor, constant: 16),
            discussButton.widthAnchor.constraint(equalToConstant: 50),
            discussButton.heightAnchor.constraint(equalToConstant: 30),
            discussButton.topAnchor.constraint(equalTo: contentImageView.bottomAnchor, constant: 15)
            ])
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initialiseData(content: ContentModel) {
        self.contentModel = content
        
        if let contentImageName = self.contentModel?.contentImageName {
            DispatchQueue.global().async {
                
                let imageURL = URL(string: contentImageName)
                guard let imageData = NSData(contentsOf: imageURL! as URL) else {
                    return
                }
                
                    
                DispatchQueue.main.async {
                    self.contentImageView.image = UIImage(data: imageData as Data)
                    print("here: ", self.contentImageView.image?.size)
                    self.setNeedsLayout()
                }
                
            }
        }
        self.contentImageView.contentMode = .scaleAspectFill
        self.contentImageView.clipsToBounds = true
        
        if let titleText = self.contentModel?.titleText {
            self.titleLabel.text = titleText
        }
        self.titleLabel.font = UIFont(name: "TrebuchetMS-Bold", size: 15)
    }
}
