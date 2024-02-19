//
//  PostView.swift
//  RedditApp
//
//  Created by Svitlana on 18.02.2024.
//

import UIKit

class PostView: UIView {
    let kCONTENT_XIB_NAME = "PostView"

    
    
    @IBOutlet var contentView: UIView!
    
    
    @IBOutlet weak var postImage: UIImageView!
    
    @IBOutlet weak var postTitle: UILabel!
    @IBOutlet weak var postTime: UILabel!
    @IBOutlet weak var postUsername: UILabel!
    
    @IBOutlet weak var postDomain: UILabel!
    @IBOutlet weak var postCommentNum: UILabel!
    @IBOutlet weak var postLikesNum: UILabel!
    
    @IBOutlet weak var postShareButton: UIButton!
    @IBOutlet weak var postCommentButton: UIButton!
    @IBOutlet weak var postSaveButton: UIButton!
    @IBOutlet weak var postLikeButton: UIButton!
    
    override init(frame: CGRect) {
            super.init(frame: frame)
            commonInit()
        }
        
        required init?(coder aDecoder: NSCoder) {
            super.init(coder: aDecoder)
            commonInit()
        }
        
        func commonInit() {
            Bundle.main.loadNibNamed(kCONTENT_XIB_NAME, owner: self, options: nil)
            contentView.fixInView(self)
        }
    }
    
extension UIView
{
    func fixInView(_ container: UIView!) -> Void{
        self.translatesAutoresizingMaskIntoConstraints = false;
        self.frame = container.frame;
        container.addSubview(self);
        NSLayoutConstraint(item: self, attribute: .leading, relatedBy: .equal, toItem: container, attribute: .leading, multiplier: 1.0, constant: 0).isActive = true
        NSLayoutConstraint(item: self, attribute: .trailing, relatedBy: .equal, toItem: container, attribute: .trailing, multiplier: 1.0, constant: 0).isActive = true
        NSLayoutConstraint(item: self, attribute: .top, relatedBy: .equal, toItem: container, attribute: .top, multiplier: 1.0, constant: 0).isActive = true
        NSLayoutConstraint(item: self, attribute: .bottom, relatedBy: .equal, toItem: container, attribute: .bottom, multiplier: 1.0, constant: 0).isActive = true
    }

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
