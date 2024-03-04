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
    
    weak var delegat : UpdateTableDelegat?
    
    func configure(post: Post){
        self.postView.configure(post: post)
    }
    
    override func viewDidLoad() {
            super.viewDidLoad()
            postView.delegate = self
        }
}

extension PostDetailsViewController : PostButtonsDelegate {
    
    func didTapShareButton(url:URL) {
        let activityViewController = UIActivityViewController(activityItems: [url], applicationActivities: nil)
                self.present(activityViewController, animated: true, completion: nil)
    }
    
    func didTapSaveButton(post: Post) {
        PostManager.manager.saveButtonTap(post: post)
        delegat?.didUpdateSavedPost()
    }
}
