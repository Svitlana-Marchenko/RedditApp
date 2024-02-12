//
//  APIStruct.swift
//  RedditApp
//
//  Created by Svitlana on 11.02.2024.
//

import Foundation

struct RedditListing: Codable {
    let data: RedditListingData
}

struct RedditListingData: Codable {
    let children: [RedditPostContainer]
}

struct RedditPostContainer: Codable {
    let data: RedditPostData
}

struct RedditPostData: Codable {
    let title: String
    let author_fullname: String
    let domain: String
    let created_utc: Double
    let ups: Int
    let downs: Int
    let num_comments: Int
    let preview: Preview?
}

struct Preview: Codable {
    let images: [Image]
}

struct Image: Codable {
    let source: Source
}

struct Source: Codable {
    let url: String
}


//{
//                "data": {
//                    "author_fullname": "t2_2llnenyz",
//                    "title": "Apple, please add",
//                    "downs": 0,
//                    "domain": "i.redd.it",
//                    "ups": 1087,
//                    "created_utc": 1707561224,
//                    "preview": {
//                        "images": [
//                            {
//                                "source": {
//                                    "url": "https://preview.redd.it/4c3ktvkljqhc1.png?auto=webp&amp;s=01caf635ab0638b9c2f4cd554a26f12632d52497"
//                                },
//                    },
//                }
//            }
//        ],
//    }
//}
