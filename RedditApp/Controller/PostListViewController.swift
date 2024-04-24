//
//  PostListViewController.swift
//  RedditApp
//
//  Created by Svitlana on 19.02.2024.
//

import UIKit

class PostListViewController: UIViewController {
    
    struct Const {
        static let cellIdentifier = "post_cell"
        static let postDetailsSegueID = "post_details"
    }
    
    private var selectedPost: Post?
    private var showOnlySaved = false
    
    private let subreddit="ios"
    private let limit=10
    
    private let pToDeload = 600
    
    private var after:String? = ""
    private var isLoadingMore = false
    
    @IBOutlet weak var searchField: UISearchBar!
    
    @IBOutlet weak var postSubreddit: UILabel!
    @IBOutlet weak var postTable: UITableView!
    
    @IBOutlet weak var showSavedButton: UIButton!
    
    @IBAction func showSavedButtonTap(_ sender: Any) {
        self.showOnlySaved.toggle()
        
        if self.showOnlySaved {
            self.showSavedButton.setImage(UIImage.init(systemName: "bookmark.fill"), for: .normal)
            self.searchField.isHidden = false
            PostManager.manager.listOfPost = PostManager.manager.savedPost
        }
        else {
            self.showSavedButton.setImage(UIImage.init(systemName: "bookmark"), for: .normal)
            
            self.searchField.isHidden = true
            self.searchField.resignFirstResponder()
            
            if(!PostManager.manager.loadedFromNetwork && Network.isConnectedToNetwork()){
                print("Internet connection appeared")
                self.isLoadingMore = true
                loadPosts()
            } else{
                PostManager.manager.listOfPost=PostManager.manager.allPost
            }
            self.searchField.text = ""
        }
        self.postTable.reloadData()
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.searchField.isHidden = true
        
        self.postTable.estimatedRowHeight = 310
        self.postTable.rowHeight = 310
        
        self.postSubreddit.text=self.subreddit
        
        //self.isLoadingMore = true
        
        PostManager.manager.savedPost = PostManager.manager.loadPostsFromFile() ?? []
        
        if(Network.isConnectedToNetwork()){
            self.isLoadingMore = true
            loadPosts()
        } else{
            print("No Internet connection")
            self.showSavedButtonTap(self)
            PostManager.manager.allPost.append(contentsOf: PostManager.manager.savedPost)
        }
        
        self.postTable.delegate = self
        self.postTable.dataSource = self
        self.searchField.delegate = self
    }
    
    
    private func loadPosts(){
        Task {
            let af = after ?? ""
            let (post, after) = try await NetworkRequest().fetchPosts(subreddit: subreddit, limit: limit, after: af)
            if let posts = post {
                DispatchQueue.main.async {
                    if(posts.isEmpty && PostManager.manager.allPost.isEmpty){
                        PostManager.manager.listOfPost.append(contentsOf:  PostManager.manager.savedPost)
                        PostManager.manager.allPost.append(contentsOf: PostManager.manager.savedPost)
                    } else{
                        let list = posts.map { p in
                            var temp = p
                            if PostManager.manager.savedPost.contains(where: { $0.id == temp.id }) {
                                temp.isSaved = true
                            } else {
                                temp.isSaved = false
                            }
                            return temp
                        }
                        
                        PostManager.manager.listOfPost = list
                        PostManager.manager.allPost = list
                    }
                    self.postTable.reloadData()
                    self.after=after
                    
                }
                
                PostManager.manager.loadedFromNetwork = true
            } else{
                print ("Error while fetching url")
            }
            self.isLoadingMore = false
        }
    }
    
    override func prepare(
        for segue: UIStoryboardSegue,
        sender: Any?
    ) {
        switch segue.identifier {
        case Const.postDetailsSegueID:
            let nextVc = segue.destination as! PostDetailsViewController
            nextVc.delegat=self
            DispatchQueue.main.async {
                if let post = self.selectedPost {
                    nextVc.delegat?.post = post
                }
            }
        default: break
        }
    }
    
}

extension PostListViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(
        _ tableView: UITableView,
        numberOfRowsInSection section: Int
    ) -> Int {
        PostManager.manager.listOfPost.count
    }
    
    func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Const.cellIdentifier, for: indexPath) as! PostCell
        let rowData = PostManager.manager.listOfPost[indexPath.row]
        cell.configure(post: rowData)
        cell.postView.delegate=self
        return cell
        
    }
}

extension PostListViewController : UITableViewDelegate{
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let screenHeight = scrollView.frame.size.height
        
        if !self.showOnlySaved && !isLoadingMore && offsetY > contentHeight - screenHeight - CGFloat(pToDeload)  {
            self.isLoadingMore = true
            Task {
                guard let af = after else {print("No more posts"); return}
                print("load posts")
                let (post, after) = try await NetworkRequest().fetchPosts(subreddit: "ios", limit: limit, after: af)
                if let posts = post {
                    DispatchQueue.main.async {
                        let list = posts.map { p in
                            var temp = p
                            if PostManager.manager.savedPost.contains(where: { $0.id == temp.id }) {
                                temp.isSaved = true
                            } else {
                                temp.isSaved = false
                            }
                            return temp
                        }
                        
                        PostManager.manager.listOfPost.append(contentsOf:  list)
                        PostManager.manager.allPost.append(contentsOf: list)
                        
                        self.postTable.reloadData()
                        self.after=after
                    }
                } else{
                    print ("Error while fetching url")
                }
                self.isLoadingMore = false
                
            }
        }
    }
}

extension PostListViewController : PostButtonsDelegate {
    func didTapCommentButton(post: Post) {
        self.selectedPost = post
        self.performSegue(
            withIdentifier: Const.postDetailsSegueID,
            sender: nil
        )
    }
    
    func didTapShareButton(url:URL) {
        let activityViewController = UIActivityViewController(activityItems: [url], applicationActivities: nil)
        self.present(activityViewController, animated: true, completion: nil)
    }
    
    func didTapSaveButton(post: Post) {
        PostManager.manager.saveButtonTap(post: post)
    }
}

extension PostListViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            PostManager.manager.listOfPost = PostManager.manager.savedPost
        } else {
            PostManager.manager.listOfPost = PostManager.manager.savedPost.filter { post in
                return post.title.lowercased().contains(searchText.lowercased())
            }
        }
        postTable.reloadData()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        print("searchBarCancelButtonClicked")
        self.searchField.resignFirstResponder()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        print("searchBarSearchButtonClicked")
        self.searchField.resignFirstResponder()
    }
}

extension PostListViewController : CurentPostDelegat {
    var post: Post? {
        get {
            return self.selectedPost
        }
        set{
            self.selectedPost=newValue
        }
    }
    
    func didUpdateSavedPost() {
        if(self.showOnlySaved){
            PostManager.manager.listOfPost = PostManager.manager.listOfPost.filter { post in
                post.isSaved == true
            }
        }
        self.postTable.reloadData()
    }
}
