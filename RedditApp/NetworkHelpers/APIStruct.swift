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
    let children: [RedditAPIResponseChildren]
    let after: String?
}

struct RedditAPIResponseChildren: Codable {
    let data: RedditAPIPostData
}

struct RedditAPIPostData: Codable {
    let title: String
    let author_fullname: String
    let domain: String
    let created_utc: Double
    let ups: Int
    let downs: Int
    let num_comments: Int
    let preview: RedditAPIPreview?
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


//{
//    "data": {
//        "children": [
//            {
//                "data": {
//                    "author_fullname": "t2_2llnenyz",
//                    "title": "Apple, please add gradually increasing volume for Alarms. There is no excuse to not have such a simple feature in 2024!",
//                    "downs": 0,
//                    "ups": 1087,
//                    "preview": {
//                        "images": [
//                            {
//                                "source": {
//                                    "url": "https://preview.redd.it/4c3ktvkljqhc1.png?auto=webp&amp;s=01caf635ab0638b9c2f4cd554a26f12632d52497",
//                                },
//                            }
//                        ],
//                    },
//                }
//            }
//        ],
//    }
//}
