//
//  PostStruct.swift
//  RedditApp
//
//  Created by Svitlana on 11.02.2024.
//

import Foundation

struct Post: Codable {
    let username: String
    let domain: String
    let time: String
    let title: String
    let imageURL: String
    let rating: Int
    let isSaved: Bool
    let num_comments: Int
    
    init(from redditPostData: RedditPostData) {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let date = Date(timeIntervalSince1970: redditPostData.created_utc)
        let timeString = dateFormatter.string(from: date)
        
        let imageURL = redditPostData.preview?.images.first?.source.url.replacing("&amp;", with: "&") ?? ""
        
        self.username = redditPostData.author_fullname
        self.domain = redditPostData.domain
        self.time = timeString
        self.title = redditPostData.title
        self.imageURL = imageURL
        self.rating = redditPostData.ups - redditPostData.downs
        self.isSaved = false
        self.num_comments = redditPostData.num_comments
    }
}
