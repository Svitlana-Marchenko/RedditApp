//
//  CommentDetails.swift
//  HW6_Marchenko
//
//  Created by Svitlana on 24.03.2024.
//

import SwiftUI

struct CommentDetails: View {
    
    let comment: Comment
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                HStack {
                    Text("/ios")
                        .fontWeight(.semibold)
                    Text(comment.username)
                        .fontWeight(.semibold)
                    Spacer()
                    Text(comment.time)
                        .foregroundColor(.gray)
                }
                
                Text(comment.text)
                    .multilineTextAlignment(.leading)
                
                HStack {
                    Text("Rating: ")
                    Text("\(comment.rating)")
                    Spacer()
                }
                .fontWeight(.semibold)
                .foregroundColor(Color("icon"))
            }
            ShareLink(item: URL(string: comment.url)!) {
                Label("Share", systemImage: "paperplane")
                    .frame(maxWidth: .infinity, minHeight: 45)
                    .background(Color("background"))
                    .foregroundColor(Color("icon"))
                    .cornerRadius(8)
            }
        }
        .padding()
        .navigationTitle(comment.username)
        .navigationBarTitleDisplayMode(.inline)
        .frame(maxWidth: .infinity, alignment: .leading)
        
    }
}

#Preview {
    CommentDetails(comment: Comment.test)
}
