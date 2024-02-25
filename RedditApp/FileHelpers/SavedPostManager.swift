//
//  SavedPostManager.swift
//  RedditApp
//
//  Created by Svitlana on 24.02.2024.
//

import Foundation
import UIKit

struct SavedPostManager {
    
    var path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!.appendingPathComponent("postdata.json")
    
    
    
    func savePostsToFile(posts: [Post]) {
        do {
            let encoder = JSONEncoder()
            encoder.outputFormatting = .prettyPrinted
            let data = try encoder.encode(posts)
            try data.write(to: path, options: .atomic)
        } catch {
            print("Помилка при збереженні файлу: \(error)")
        }
    }
    
    
    func loadPostsFromFile() -> [Post]? {
        if !FileManager.default.fileExists(atPath: path.path){
            return nil
        }
        do {
            let data = try Data(contentsOf: path)
            let decoder = JSONDecoder()
            let posts = try decoder.decode([Post].self, from: data)
            return posts
        } catch {
            print("Помилка при завантаженні файлу: \(error)")
            return nil
        }
    }
    
}
//if let permalink = redditPost?.data.permalink {
//    let urlString = "https://www.reddit.com\(permalink)"
//    if let url = URL(string: urlString) {
//        let activityViewController = UIActivityViewController(activityItems: [url], applicationActivities: nil)
//        present(activityViewController, animated: true)
//    }
//}
