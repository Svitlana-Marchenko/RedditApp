//
//  PostListViewController.swift
//  RedditApp
//
//  Created by Svitlana on 19.02.2024.
//

import UIKit

class PostListViewController: UIViewController {
    
    
    private var listOfPost = [Post]()
    
    private let cellIdentifier = "post_cell"
    private let subreddit="ios"
    private let limit=10
    var after:String? = ""
    var isLoadingMore = false
    
    
    @IBOutlet weak var postTable: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        postTable.estimatedRowHeight = 310
        postTable.rowHeight = 310
        
        self.isLoadingMore = true
        
        Task {
            let af = after ?? ""
            let (post, after) = try await NetworkRequest().fetchPosts(subreddit: "ios", limit: limit, after: af)
            if let posts = post {
                DispatchQueue.main.async {
                    self.listOfPost.append(contentsOf:  posts)
                    self.postTable.reloadData()
                    self.after=after
                }
            } else{
                print ("Error while fetching url")
            }
            self.isLoadingMore = false
        }
        
        self.postTable.delegate = self
        self.postTable.dataSource=self
    }
}

extension PostListViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
     return 1
    }
    
    func tableView(
        _ tableView: UITableView,
        numberOfRowsInSection section: Int
    ) -> Int {
        listOfPost.count
    }
    
    func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! PostCell
        let rowData = listOfPost[indexPath.row]
        cell.configure(post: rowData)
        return cell
        
    }
    
    //    func tableView(
    //        _ tableView: UITableView,
    //        didSelectRowAt indexPath: IndexPath
    //    ) {
    //
    //    }
    //
   func scrollViewDidScroll(_ scrollView: UIScrollView) {
       
       let offsetY = scrollView.contentOffset.y
       let contentHeight = scrollView.contentSize.height
       let screenHeight = scrollView.frame.size.height

       if !isLoadingMore && offsetY > contentHeight - screenHeight - 600  {
           self.isLoadingMore = true
           Task {
               
               guard let af = after else {print("No more posts"); return}
               
               let (post, after) = try await NetworkRequest().fetchPosts(subreddit: "ios", limit: limit, after: af)
               if let posts = post {
                   DispatchQueue.main.async {
                       self.listOfPost.append(contentsOf:  posts)
                       self.after=after
                       self.postTable.reloadData()
                   }
               } else{
                   print ("Error while fetching url")
               }
               self.isLoadingMore = false
               
           }
       }
       
    }
}

