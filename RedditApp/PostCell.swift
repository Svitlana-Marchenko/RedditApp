//
//  PostCell.swift
//  RedditApp
//
//  Created by Svitlana on 19.02.2024.
//

import Foundation
import UIKit

class PostCell: UITableViewCell{
    
    
    @IBOutlet private weak var postView: PostView!
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.postView.prepareForCellReuse()
    }
    
    func configure (post: Post){
        self.postView.configure(post: post)
    }
    
}
