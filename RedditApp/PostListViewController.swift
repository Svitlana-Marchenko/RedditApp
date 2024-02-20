//
//  PostListViewController.swift
//  RedditApp
//
//  Created by Svitlana on 19.02.2024.
//

import UIKit

class PostListViewController: UIViewController {
    
    // MARK: - Const
    struct Const {
        static let cellIdentifier = "post_cell"
        static let postDetailsSegueID = "post_details"
    }
    
    private var listOfPost = [Post]()
    private var selectedPost: Post?
    
    private let subreddit="ios"
    private let limit=10
    
    private let pToDeload = 600
    
    private var after:String? = ""
    private var isLoadingMore = false
    
    
    @IBOutlet weak var postSubreddit: UILabel!
    @IBOutlet weak var postTable: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.postTable.estimatedRowHeight = 310
        self.postTable.rowHeight = 310
        
        self.postSubreddit.text=self.subreddit
        
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
    
    override func prepare(
        for segue: UIStoryboardSegue,
        sender: Any?
    ) {
        switch segue.identifier {
        case Const.postDetailsSegueID:
            let nextVc = segue.destination as! PostDetailsViewController
            DispatchQueue.main.async {
                if let post = self.selectedPost {
                    nextVc.configure(post: post)
                }
            }
        default: break
        }
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
        let cell = tableView.dequeueReusableCell(withIdentifier: Const.cellIdentifier, for: indexPath) as! PostCell
        let rowData = listOfPost[indexPath.row]
        cell.configure(post: rowData)
        return cell
        
    }
    
    func tableView(
        _ tableView: UITableView,
        didSelectRowAt indexPath: IndexPath
    ) {
        self.selectedPost = self.listOfPost[indexPath.row]
        self.performSegue(
            withIdentifier: Const.postDetailsSegueID,
            sender: nil
        )
    }
    
   func scrollViewDidScroll(_ scrollView: UIScrollView) {
       
       let offsetY = scrollView.contentOffset.y
       let contentHeight = scrollView.contentSize.height
       let screenHeight = scrollView.frame.size.height

       if !isLoadingMore && offsetY > contentHeight - screenHeight - CGFloat(pToDeload)  {
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

