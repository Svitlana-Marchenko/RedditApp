//
//  NetworkRequest.swift
//  RedditApp
//
//  Created by Svitlana on 10.02.2024.
//

import Foundation

struct NetworkRequest {
    
    func buildURL (subreddit: String, params: [String: String]) throws-> URL {
        guard let link = URL(string:"https://www.reddit.com/r/\(subreddit)/top.json") else {throw URLError(message: "error with url")}
        let queryItems = params.map { URLQueryItem(name: $0.key, value: $0.value) }
        return link.appending(queryItems: queryItems)
    }
    
    
    func fetchPost(subreddit: String, after: String = "") async throws -> Post? {
        do {
            let url = try buildURL(subreddit: subreddit, params: ["limit": String(1), "after": String(after)])
            let data = try await URLSession.shared.data(from: url)
            let redditData = try JSONDecoder().decode(RedditAPIResponse.self, from: data.0)

            guard let postAPIData = redditData.data.children.first?.data else { return nil }
            return Post(from: postAPIData)
            
        } catch {
            print("error in: \(error)")
            throw error
        }
    }
    
    func fetchPosts(subreddit: String, limit: Int = 1, after: String = "") async throws -> ([Post]?, String?) {
        do {
            let url = try buildURL(subreddit: subreddit, params: ["limit": String(limit), "after": String(after)])
           
            let (data, _) = try await URLSession.shared.data(from: url)

            let redditData = try JSONDecoder().decode(RedditAPIResponse.self, from: data)
            var posts: [Post] = []
            
            for child in redditData.data.children {
                let postData = child.data
                let post = Post(from: postData)
                posts.append(post)
                }
            
            return (posts, redditData.data.after)
            
        } catch {
            print("error in: \(error)")
            throw error
        }
    }
}

struct URLError: Error {
    let message: String
}
