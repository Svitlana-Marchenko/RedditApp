//
//  NetworkRequest.swift
//  RedditApp
//
//  Created by Svitlana on 10.02.2024.
//

import Foundation


func buildURL(subreddit: String, params: [String: String]) -> URL? {
    var components = URLComponents(string: "https://www.reddit.com/r/\(subreddit)/top.json")
    components?.queryItems = params.map { URLQueryItem(name: $0.key, value: $0.value) }
    return components?.url
}

func fetchPost(subreddit: String, limit: Int, after: String) async -> Post? {
    guard let url = buildURL(subreddit: subreddit, params: ["limit": String(limit), "after": after]) else { return nil }
    print(url)
    
    do {
        let (data, _) = try await URLSession.shared.data(from: url)
        let redditData = try JSONDecoder().decode(RedditListing.self, from: data)
        
        guard let firstPostData = redditData.data.children.first?.data else { return nil }
        return Post(from: firstPostData)
    } catch {
        print("Error: \(error)")
        return nil
    }
}


