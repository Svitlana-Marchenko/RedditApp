//
//  PostDetailsViewController.swift
//  RedditApp
//
//  Created by Svitlana on 20.02.2024.
//

import Foundation
import UIKit

class PostDetailsViewController : UIViewController {
    
    @IBOutlet private weak var postView: PostView!
    
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
