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
        self.postView.configure(post: post)
    }    
}
