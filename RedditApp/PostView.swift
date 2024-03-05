//
//  PostView.swift
//  RedditApp
//
//  Created by Svitlana on 18.02.2024.
//

import UIKit

class PostView: UIView {
    let kCONTENT_XIB_NAME = "PostView"
    
    weak var delegate: PostButtonsDelegate?

    @IBOutlet private var contentView: UIView!
    
    @IBOutlet private weak var postImage: UIImageView!
    
    @IBOutlet private weak var postTitle: UILabel!
    @IBOutlet private weak var postTime: UILabel!
    @IBOutlet private weak var postUsername: UILabel!
    
    @IBOutlet private weak var postDomain: UILabel!
    @IBOutlet private weak var postCommentNum: UILabel!
    @IBOutlet private weak var postLikesNum: UILabel!
    
    @IBOutlet private weak var postShareButton: UIButton!
    @IBOutlet private weak var postCommentButton: UIButton!
    @IBOutlet private weak var postSaveButton: UIButton!
    @IBOutlet private weak var postLikeButton: UIButton!
    
    @IBOutlet private weak var postBookMarkViewFilled: UIView!
    
    @IBOutlet private weak var postBookMarkView: UIView!
    
    var post: Post?
    
    private var doubleTapGesture: UITapGestureRecognizer!
    
    @IBAction func commentButtonTap(_ sender: Any) {
        print("Tap comment button")
        
        if let postToDetails = post {
            delegate?.didTapCommentButton(post: postToDetails)
        } else {
            print("Error while getting post")
            return
        }
    }
    
    @IBAction func shareButtonTap(_ sender: Any) {
        print("Tap share button")
        if let postToShare = post {
            guard let url = URL(string: postToShare.url) else {return}
            delegate?.didTapShareButton(url: url)
        } else {
            print("Error while getting post")
            return
        }
    }
    
    @IBAction func saveButtonTap(_ sender: Any) {
        print("Tap save button")
        if let postToSave = post {
            self.postSaveButton.setImage(!postToSave.isSaved ? UIImage.init(systemName: "bookmark.fill"): UIImage.init(systemName: "bookmark"), for: .normal)
                var temp = postToSave
            temp.isSaved.toggle()
            self.post=temp
            self.delegate?.didTapSaveButton(post: temp)
        } else {
            print("Error while getting post")
            return
        }
    }
    
    @objc func didDoubleTap() {
        print("Double tap recognised")
        if let postToSave = post {
            saveButtonTap(postSaveButton as Any)
           
            UIView.transition(
                with: self,
                duration: 0.5,
                options: .transitionCrossDissolve,
                animations: {
                    if(postToSave.isSaved){
                        self.postBookMarkView.isHidden = false
                    } else{
                        self.postBookMarkViewFilled.isHidden = false
                    }
                },
                completion: { _ in
                    UIView.transition(
                        with: self,
                        duration: 0.5,
                        options: .transitionCrossDissolve,
                        animations: {
                            if(postToSave.isSaved){
                                self.postBookMarkView.isHidden = true
                            } else{
                                self.postBookMarkViewFilled.isHidden = true
                            }
                        }
                    )
                }
            )
        } else {
            print("Error while getting post")
            return
        }
    }
    
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
    
    func configure (post: Post){
        self.post=post
        self.postUsername.text = post.username
        self.postTitle.text = post.title
        self.postTime.text = post.time
        self.postDomain.text = post.domain
        self.postCommentNum.text = String(post.num_comments)
        self.postLikesNum.text = String(post.rating)
        self.postSaveButton.setImage(post.isSaved ? UIImage.init(systemName: "bookmark.fill"): UIImage.init(systemName: "bookmark"), for: .normal)
        
        let defaultImage = UIImage(systemName: "questionmark.circle")

        if post.imageURL != "" {
            self.postImage.contentMode = .scaleAspectFill
            self.postImage.sd_setImage(with: URL(string: post.imageURL)) { (image, error, _, _) in
                if error != nil {
                    self.postImage.contentMode = .scaleAspectFit
                    self.postImage.image = defaultImage
                    print ("Error while fetching image url")
                }
            }
        } else {
            self.postImage.contentMode = .scaleAspectFit
            self.postImage.image = defaultImage
        }
        self.postBookMarkView.backgroundColor = UIColor.clear
        self.postBookMarkViewFilled.backgroundColor = UIColor.clear
        self.postBookMarkView.isHidden = true
        self.postBookMarkViewFilled.isHidden = true
        
        self.doubleTapGesture = UITapGestureRecognizer.init()
        self.doubleTapGesture.addTarget(self, action: #selector(didDoubleTap))
        self.doubleTapGesture.numberOfTapsRequired=2
        self.doubleTapGesture.delaysTouchesBegan=true
        
        self.contentView.gestureRecognizers?.forEach {self.contentView.removeGestureRecognizer($0)}
        self.contentView.addGestureRecognizer(self.doubleTapGesture)
        
        DispatchQueue.main.async {
            self.drawBookMark(in: self.postBookMarkView, filled: false)
            self.drawBookMark(in: self.postBookMarkViewFilled, filled: true)
        }
    }
        
  
    func prepareForCellReuse(){
        self.postImage.contentMode = .scaleAspectFill
        self.postImage.image=nil
    }

    private func drawBookMark(in view: UIView, filled: Bool){
        let width: CGFloat = CGFloat(Int(view.bounds.width/8))
        let height: CGFloat = CGFloat(Int(view.bounds.height/3))

        view.layer.sublayers?.forEach { $0.removeFromSuperlayer() }
        
        let path = UIBezierPath()

        path.move(to: CGPoint(x: view.bounds.midX - width/2,
                                  y: view.bounds.midY - height/2))
            path.addLine(to: CGPoint(x: view.bounds.midX + width/2,
                                     y: view.bounds.midY - height/2))
            path.addLine(to: CGPoint(x: view.bounds.midX + width/2,
                                     y: view.bounds.midY + height/2))
            path.addLine(to: CGPoint(x: view.bounds.midX,
                                     y: view.bounds.midY))
            path.addLine(to: CGPoint(x: view.bounds.midX - width/2,
                                     y: view.bounds.midY + height/2))
            path.close()

        let shapeLayer = CAShapeLayer()
        shapeLayer.path = path.cgPath
        shapeLayer.strokeColor = UIColor(named: "icon")?.cgColor ?? UIColor.black.cgColor
        
        shapeLayer.fillColor = filled ? (UIColor(named: "background")?.cgColor ?? UIColor.black.cgColor) : UIColor.clear.cgColor
        

        shapeLayer.lineWidth = 5

        view.layer.addSublayer(shapeLayer)
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
