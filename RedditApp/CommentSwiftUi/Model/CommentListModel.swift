//
//  CommentData.swift
//  HW6_Marchenko
//
//  Created by Svitlana on 25.03.2024.
//

import Foundation

class CommentListModel : ObservableObject {
    
    @Published var comments: [Comment] = []
    
    let postId : String
    let subreddit : String
    
    init(subreddit: String = "ios", postId: String = "1blwyq2"){
        self.subreddit = subreddit
        self.postId = postId
        loadComments()
    }
    
    func loadComments () {
        Task {
            let commentsArr = try await NetworkRequest().fetchComments(postId: postId)
            if let comment = commentsArr {
                DispatchQueue.main.async {
                    self.comments = comment
                }
            } else {
                print ("Error while fetching url")
            }
        }
    }
}
