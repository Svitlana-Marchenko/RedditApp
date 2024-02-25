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
    
    func configure(post: Post){
//        self.postView.post = post
        self.postView.configure(post: post)
    } 
    
    override func viewDidLoad() {
            super.viewDidLoad()
            postView.delegate = self
        }
}

extension PostDetailsViewController : ShareButtonDelegate {
    
    func didTapShareButton(url:URL) {
        print("ttttt")
       // guard let url = URL(string: "https://example.com") else { return }
        let activityViewController = UIActivityViewController(activityItems: [url], applicationActivities: nil)
                self.present(activityViewController, animated: true, completion: nil)
    }
    
    
}

