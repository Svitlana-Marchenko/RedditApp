//
//  PostDetailsViewController.swift
//  RedditApp
//
//  Created by Svitlana on 20.02.2024.
//

import Foundation
import UIKit
import SwiftUI

class PostDetailsViewController : UIViewController {
    
    @IBOutlet private weak var postView: PostView!
    
    @IBOutlet weak var commentListView: UIView!
    
    weak var delegat : CurentPostDelegat?
    
    func configure(with post: Post?){
        if let postToConfig = post {
            self.postView.configure(post: postToConfig)
        } else{
            print("Error while getting post")
            return
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        postView.delegate = self
        configure(with: delegat?.post)
        configureCommentList(for: delegat?.post)
    }
    
    
    private func configureCommentList(for postData: Post?) {
        
        guard let post = postData else {
            print("Error while getting post for comment")
            return
        }
        
        let commentData = CommentListModel(subreddit: "ios", postId: post.id)
        
        let commentListViewController: UIViewController = UIHostingController(rootView: CommentList(
            commentData: commentData,
            navigateToDetails: showCommentDetailsView(comment:)
        ))

        let commentListView: UIView = commentListViewController.view
        
        self.commentListView.addSubview(commentListView)
        
        commentListView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            commentListView.topAnchor.constraint(equalTo: self.commentListView.topAnchor),
            commentListView.trailingAnchor.constraint(equalTo: self.commentListView.trailingAnchor),
            commentListView.bottomAnchor.constraint(equalTo: self.commentListView.bottomAnchor),
            commentListView.leadingAnchor.constraint(equalTo: self.commentListView.leadingAnchor)
        ])
        commentListViewController.didMove(toParent: self)
    }
    
    private func showCommentDetailsView(comment: Comment) {
        let commentDetailsController = UIHostingController(rootView: CommentDetails(comment: comment))
        self.navigationController?.pushViewController(commentDetailsController, animated: true)
    }
}

extension PostDetailsViewController : PostButtonsDelegate {
    func didTapCommentButton(post: Post) {
        print("Comment button in post details view tap")
    }
    
    
    func didTapShareButton(url:URL) {
        let activityViewController = UIActivityViewController(activityItems: [url], applicationActivities: nil)
        self.present(activityViewController, animated: true, completion: nil)
    }
    
    func didTapSaveButton(post: Post) {
        PostManager.manager.saveButtonTap(post: post)
        delegat?.didUpdateSavedPost()
    }
}
