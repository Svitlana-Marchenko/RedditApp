//
//  CommentList.swift
//  RedditApp
//
//  Created by Svitlana on 08.04.2024.
//

import SwiftUI

struct CommentList: View {
    
    @ObservedObject private var commentData: CommentListModel
    
    init(commentData: CommentListModel, navigateToDetails: @escaping (Comment) -> Void) {
        self.commentData = commentData
        self.navigateToDetails = navigateToDetails
    }
    
    let navigateToDetails: (Comment) -> Void
    
    var body: some View {
        if (!Network.isConnectedToNetwork()) {
            Text("Comments in offline mode are not available")
                    .font(.headline)
                    .foregroundColor(Color("icon"))
                    
        } else {
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
}

struct CommentList_Previews: PreviewProvider {
    static var previews: some View {
        CommentList(
            commentData: CommentListModel(postId: "1blwyq2"),
            navigateToDetails: {comment in print("Comment details tap")})
    }
}
