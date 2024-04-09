//
//  CommentStruct.swift
//  HW6_Marchenko
//
//  Created by Svitlana on 24.03.2024.
//

import Foundation

struct Comment: Codable, Identifiable, Hashable {
    let username: String
    let time: String
    let text: String
    let rating: Int
    let url: String
    let id: String
    
    init(from redditComment: RedditComment) {
        self.username = redditComment.author_fullname ?? "unknow"
        self.rating = (redditComment.ups ?? 0) - (redditComment.downs ?? 0)
        self.time = Comment.convertTime(from: (redditComment.created_utc ?? 0))
        self.url = "https://www.reddit.com/" + (redditComment.permalink ?? "")
        self.id = redditComment.id ?? "unknow"
        self.text = redditComment.body?.trimmingCharacters(in: .whitespacesAndNewlines) ?? "unknown"
    }
    
    init(username: String, rating: Int, time: String, url: String, id: String, text: String) {
        self.username = username
        self.rating = rating
        self.time = time
        self.url = url
        self.id = id
        self.text = text
        
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

extension Comment {
    static let test = Comment(
        username: "t2_dfghbvf",
        rating: 366,
        time: "1 day ago",
        url: "https://developer.apple.com/documentation/SwiftUI/ShareLink",
        id: "bogc5x5m",
        text: "Having switched kinda recently I must admit the smoothness of the whole OS is really good and I'm enjoying it so far"
    )
}
