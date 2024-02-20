//
//  PostCell.swift
//  RedditApp
//
//  Created by Svitlana on 19.02.2024.
//

import Foundation
import UIKit

class PostCell: UITableViewCell{
    
    
    @IBOutlet weak var postView: PostView!
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    func configure (post: Post){
        self.postView.postUsername.text = post.username
        self.postView.postTitle.text = post.title
        self.postView.postTime.text = post.time
        self.postView.postDomain.text = post.domain
        self.postView.postCommentNum.text = String(post.num_comments)
        self.postView.postLikesNum.text = String(post.rating)
        self.postView.postSaveButton.setImage(post.isSaved ? UIImage.init(systemName: "bookmark"): UIImage.init(systemName: "bookmark.fill"), for: .normal)
        
        let defaultImage = UIImage(systemName: "questionmark.circle")
        if post.imageURL != "" {
            self.postView.postImage.sd_setImage(with: URL(string: post.imageURL)) { (image, error, _, _) in
                if error != nil {
                    self.postView.postImage.image = defaultImage
                    self.postView.contentMode = .scaleAspectFit
                    print ("Error while fetching image url")
                }
            }
        } else {
            self.postView.postImage.image = defaultImage
            self.postView.contentMode = .scaleAspectFit
        }
    }
}
