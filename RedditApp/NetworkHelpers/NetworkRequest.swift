//
//  NetworkRequest.swift
//  RedditApp
//
//  Created by Svitlana on 10.02.2024.
//

import Foundation

class NetworkRequest {
//    func buildURL(subreddit: String, params: [String: String]) -> URL? {
//        var components = URLComponents(string: "https://www.reddit.com/r/\(subreddit)/top.json")
//        components?.queryItems = params.map { URLQueryItem(name: $0.key, value: $0.value) }
//        return components?.url
//    }
    
    func buildURL (subreddit: String, params: [String: String]) -> URL? {
        guard let link = URL(string:"https://www.reddit.com/r/\(subreddit)/top.json") else {return nil}
        let queryItems = params.map { URLQueryItem(name: $0.key, value: $0.value) }
        return link.appending(queryItems: queryItems)
    }
    
    func fetchPost(subreddit: String, limit: Int = 1, after: String) async -> Post? {
        guard let url = buildURL(subreddit: subreddit, params: ["limit": String(limit), "after": String(after)]) else { return nil }
        
        do {
            let data = try await URLSession.shared.data(from: url)
            let redditData = try JSONDecoder().decode(RedditAPIResponse.self, from: data.0)

            guard let postAPIData = redditData.data.children.first?.data else { return nil }
            return Post(from: postAPIData)
            
        } catch {
            print("error in: \(error)")
            return nil
        }
    }
    
    
}
