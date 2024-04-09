//
//  CommentCell.swift
//  HW6_Marchenko
//
//  Created by Svitlana on 24.03.2024.
//

import SwiftUI

struct CommentCell: View {
    
    let comment: Comment
    
    var body: some View {
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
                .lineLimit(1)
                
            HStack {
                Image(systemName: "heart")
                Text("\(comment.rating)")
                Spacer()
            }
            .foregroundColor(Color("icon"))
        }
        
        .padding()
        .foregroundColor(.primary)
        .frame(maxWidth: .infinity, alignment: .leading)
        .frame(height: 100)
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(Color("icon"), lineWidth: 1)
        )
    }
    
    
}

#Preview {
    CommentCell(comment: Comment.test)
}


