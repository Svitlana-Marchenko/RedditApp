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
    var isSaved: Bool
    let num_comments: Int
    let url: String
    let id: String
    
    init(from redditPostData: RedditAPIPostData) {
        
        let imageURL = redditPostData.preview?.images.first?.source.url.replacing("&amp;", with: "&") ?? ""
        self.username = redditPostData.author_fullname ?? "unknow"
        self.domain = redditPostData.domain
        self.title = redditPostData.title
        self.imageURL = imageURL
        self.rating = redditPostData.ups - redditPostData.downs
        self.isSaved = false
        self.num_comments = redditPostData.num_comments
        self.time = Post.convertTime(from: redditPostData.created_utc)
        self.url = "https://www.reddit.com/"+redditPostData.permalink
        self.id = redditPostData.name
    }
    

    static func convertTime(from time: Double) -> String {
        let currentTime = Double(Date().timeIntervalSince1970)
        let difference = currentTime - time
        
        switch difference {
            case ..<60:
                return "Just now"
            case ..<(60*60):
                let minutesAgo = Int(difference / 60)
                return "\(minutesAgo) minute\(minutesAgo == 1 ? "" : "s") ago"
            case ..<(24 * 60 * 60):
                let hoursAgo = Int(difference / (60*60))
                return "\(hoursAgo) hour\(hoursAgo == 1 ? "" : "s") ago"
            case ..<(7 * 24 * 60 * 60):
                let daysAgo = Int(difference / (24 * 60 * 60))
                return "\(daysAgo) day\(daysAgo == 1 ? "" : "s") ago"
            case ..<(30 * 24 * 60 * 60):
                let weeksAgo = Int(difference / (7 * 24 * 60 * 60))
                return "\(weeksAgo) week\(weeksAgo == 1 ? "" : "s") ago"
            case ..<(12 * 30 * 24 * 60 * 60):
                let monthsAgo = Int(difference / (30 * 24 * 60 * 60))
                return "\(monthsAgo) month\(monthsAgo == 1 ? "" : "s") ago"
        default:
            let yearsAgo = Int(difference / (12 * 30 * 24 * 60 * 60))
            return "\(yearsAgo) year\(yearsAgo == 1 ? "" : "s") ago"
            }
    }
}
