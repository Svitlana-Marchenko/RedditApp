//
//  CommentList.swift
//  RedditApp
//
//  Created by Svitlana on 08.04.2024.
//

import SwiftUI

struct CommentList: View {
    
    @ObservedObject private var commentData: CommentData
    
    init(commentData: CommentData, navigateToDetails: @escaping (Comment) -> Void) {
        self.commentData = commentData
        self.navigateToDetails = navigateToDetails
    }
    
    let navigateToDetails: (Comment) -> Void

    var body: some View {
        NavigationStack {
            List(commentData.comments) { comment in
                Button(action: {
                    navigateToDetails(comment)
                }) {
                    CommentCell(comment: comment)
                }
            }
        }
    }
}

struct CommentList_Previews: PreviewProvider {
    static var previews: some View {
        CommentList(
            commentData: CommentData(postId: "1blwyq2"),
            navigateToDetails: {comment in print("Comment details tap")})
    }
}
