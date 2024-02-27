//
//  APIStruct.swift
//  RedditApp
//
//  Created by Svitlana on 11.02.2024.
//

import Foundation

struct RedditAPIResponse: Codable {
    let data: RedditAPIResponseData
}

struct RedditAPIResponseData: Codable {
    let after: String?
    let children: [RedditAPIResponseChildren]
}

struct RedditAPIResponseChildren: Codable {
    let data: RedditAPIPostData
}

struct RedditAPIPostData: Codable {
    let title: String
    let author_fullname: String?
    let domain: String
    let created_utc: Double
    let ups: Int
    let downs: Int
    let num_comments: Int
    let preview: RedditAPIPreview?
    let permalink: String
    let name: String
}

struct RedditAPIPreview: Codable {
    let images: [RedditAPIImages]
}

struct RedditAPIImages: Codable {
    let source: RedditAPISourceImage
}

struct RedditAPISourceImage: Codable {
    let url: String
}
