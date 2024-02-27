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
    
    @IBOutlet weak var searchField: UITextField!
    
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
            PostManager.manager.listOfPost=PostManager.manager.allPost
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
        
        self.isLoadingMore = true
        
        PostManager.manager.savedPost = PostManager.manager.loadPostsFromFile() ?? []
        
        
        Task {
            let af = after ?? ""
            let (post, after) = try await NetworkRequest().fetchPosts(subreddit: "ios", limit: limit, after: af)
            if let posts = post {
                DispatchQueue.main.async {
                    if(posts.isEmpty){
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
                        
                        PostManager.manager.listOfPost.append(contentsOf:  list)
                        PostManager.manager.allPost.append(contentsOf: list)
                    }
                    self.postTable.reloadData()
                    self.after=after
                    
                }
            } else{
                print ("Error while fetching url")
            }
            self.isLoadingMore = false
        }
        
        self.postTable.delegate = self
        self.postTable.dataSource = self
        self.searchField.delegate = self
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
                    nextVc.configure(post: post)
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
    func tableView(
        _ tableView: UITableView,
        didSelectRowAt indexPath: IndexPath
    ) {
        self.selectedPost = PostManager.manager.listOfPost[indexPath.row]
        self.performSegue(
            withIdentifier: Const.postDetailsSegueID,
            sender: nil
        )
    }
    
   func scrollViewDidScroll(_ scrollView: UIScrollView) {
       
       let offsetY = scrollView.contentOffset.y
       let contentHeight = scrollView.contentSize.height
       let screenHeight = scrollView.frame.size.height

       if !self.showOnlySaved && !isLoadingMore && offsetY > contentHeight - screenHeight - CGFloat(pToDeload)  {
           self.isLoadingMore = true
           Task {
               
               guard let af = after else {print("No more posts"); return}
               
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
    func didTapShareButton(url:URL) {
        let activityViewController = UIActivityViewController(activityItems: [url], applicationActivities: nil)
                self.present(activityViewController, animated: true, completion: nil)
    }
    
    func didTapSaveButton(post: Post) {
        PostManager.manager.saveButtonTap(post: post)
    }
}

extension PostListViewController: UITextFieldDelegate {
    func textField(
        _ textField: UITextField,
        shouldChangeCharactersIn range: NSRange,
        replacementString string: String
    ) -> Bool {
        let search = (textField.text ?? "") + string
        PostManager.manager.listOfPost =
        PostManager.manager.savedPost.filter({
            $0.title.lowercased().contains(search.lowercased())
        })
        postTable.reloadData()
        return true
    }
}

extension PostListViewController : UpdateTableDelegat {
    func didUpdateSavedPost() {
        if(self.showOnlySaved){
            PostManager.manager.listOfPost = PostManager.manager.listOfPost.filter { post in
                post.isSaved == true
            }
        }
        self.postTable.reloadData()
    }
}
