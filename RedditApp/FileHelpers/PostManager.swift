//
//  PostManager.swift
//  RedditApp
//
//  Created by Svitlana on 24.02.2024.
//

import Foundation
import UIKit

class PostManager {
    
    var listOfPost = [Post]()
    
    var savedPost = [Post]()
    var allPost = [Post]()
    
    var loadedFromNetwork : Bool = false
    
    static let manager = PostManager()
    
    var path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!.appendingPathComponent("postdata.json")
    
    
    func savePostsToFile(posts: [Post]) {
        do {
            let encoder = JSONEncoder()
            encoder.outputFormatting = .prettyPrinted
            let data = try encoder.encode(posts)
            try data.write(to: path, options: .atomic)
        } catch {
            print("Error while saving post: \(error)")
        }
    }
    
    func savePostsToFile() {
        do {
            let encoder = JSONEncoder()
            encoder.outputFormatting = .prettyPrinted
            let data = try encoder.encode(savedPost)
            try data.write(to: path, options: .atomic)
        } catch {
            print("Error while saving post: \(error)")
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
            print("Error while getting post: \(error)")
            return nil
        }
    }
    
    func saveButtonTap(post : Post){
        if(post.isSaved){
            savePostToSaved(post: post)
        } else {
            deletePostFromSaved(post: post)
        }
    }
    
    private func savePostToSaved(post : Post){
        if (!savedPost.contains { $0.id == post.id }) {
            self.allPost = self.allPost.map { p in
                var temp = p
                if(temp.id == post.id){
                    temp.isSaved = true
                }
                return temp
            }
            self.listOfPost = self.listOfPost.map { p in
                var temp = p
                if(temp.id == post.id){
                    temp.isSaved = true
                }
                return temp
            }
            var temp = post
            temp.isSaved = true
            self.savedPost.append(temp)
                }
    }
    
    private func deletePostFromSaved(post : Post){
        if (savedPost.contains { $0.id == post.id }) {
            self.allPost = self.allPost.map { p in
                var temp = p
                if(temp.id == post.id){
                    temp.isSaved = false
                }
                return temp
            }
            self.listOfPost = self.listOfPost.map { p in
                var temp = p
                if(temp.id == post.id){
                    temp.isSaved = false
                }
                return temp
            }
            self.savedPost = self.savedPost.filter {$0.id != post.id}
        }
    }
}
