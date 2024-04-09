//
//  PostViewController.swift
//  RedditApp
//
//  Created by Svitlana on 13.02.2024.
//

import UIKit

class PostViewController: UIViewController {
    
    
    @IBOutlet private weak var postTime: UILabel!
    @IBOutlet private weak var postDomain: UILabel!
    @IBOutlet private weak var postUsername: UILabel!
    @IBOutlet private weak var postTitle: UILabel!
    @IBOutlet private weak var postImage: UIImageView!
    
    @IBOutlet private weak var postLikeNumber: UILabel!
    @IBOutlet private weak var postCommentNum: UILabel!
    
    @IBOutlet private weak var postLike: UIButton!
    @IBOutlet private weak var postComment: UIButton!
    @IBOutlet private weak var postSave: UIButton!
    @IBOutlet private weak var postShare: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        Task {
            let post = try await NetworkRequest().fetchPost(subreddit: "ios", after: "")
            if let post = post {
                DispatchQueue.main.async {
                    self.postUsername.text = post.username
                    self.postTitle.text = post.title
                    self.postTime.text = post.time
                    self.postDomain.text = post.domain
                    self.postCommentNum.text = String(post.num_comments)
                    self.postLikeNumber.text = String(post.rating)
                    self.postSave.setImage(post.isSaved ? UIImage.init(systemName: "bookmark"): UIImage.init(systemName: "bookmark.fill"), for: .normal)
                    
                    let defaultImage = UIImage(systemName: "questionmark.circle")
                    if post.imageURL != "" {
                        self.postImage.sd_setImage(with: URL(string: post.imageURL)) { (image, error, _, _) in
                            if error != nil {
                                self.postImage.image = defaultImage
                                print ("Error while fetching image url")
                            }
                        }
                    } else {
                        self.postImage.image = defaultImage
                    }
                    
                }
            } else {
                print ("Error while fetching url")
            }
        }
        
    }
    
}
