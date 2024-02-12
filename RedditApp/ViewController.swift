//
//  ViewController.swift
//  RedditApp
//
//  Created by Svitlana on 09.02.2024.
//

import UIKit
import SDWebImage

class ViewController: UIViewController {

    @IBOutlet private weak var postImage: UIImageView!
    @IBOutlet private weak var postUsername: UILabel!
    @IBOutlet private weak var postTitle: UILabel!
    @IBOutlet private weak var postTime: UILabel!
    @IBOutlet private weak var postDomain: UILabel!
    @IBOutlet private weak var likeButton: UIButton!
    @IBOutlet private weak var commentButton: UIButton!
    @IBOutlet private weak var shareButton: UIButton!
    @IBOutlet private weak var saveButton: UIButton!
    @IBOutlet private weak var commentLabel: UILabel!
    @IBOutlet private weak var likeLabel: UILabel!
    
    let networkRequest = NetworkRequest()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        Task {
                    let post = await networkRequest.fetchPost(subreddit: "dog", limit: 1, after: "")
                    if let post = post {
                        self.postUsername.text = post.username
                        self.postTitle.text = post.title
                        self.postTime.text = post.time
                        self.postDomain.text = post.domain
                        self.commentLabel.text = String(post.num_comments)
                        self.likeLabel.text = String(post.rating)
                        self.saveButton.setImage(post.isSaved ? UIImage.init(systemName: "bookmark"): UIImage.init(systemName: "bookmark.fill"), for: .normal)
                        self.postImage.sd_setImage(with: URL(string: post.imageURL))
                                        
                                    }
                    }
                }
    }

