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
    
    private var listOfPost = [Post]()
    
    var path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!.appendingPathComponent("postdata.json")
    
    private var savedPost = [Post]()
    private var allPost = [Post]()
    
    private var selectedPost: Post?
    private var showOnlySaved = false
    
    private let subreddit="ios"
    private let limit=10
    
    private let pToDeload = 600
    
    private var after:String? = ""
    private var isLoadingMore = false
    
    static let controller = PostListViewController()
    
    @IBOutlet weak var searchField: UITextField!
    
    @IBOutlet weak var postSubreddit: UILabel!
    @IBOutlet weak var postTable: UITableView!
    
    @IBOutlet weak var showSavedButton: UIButton!
    
    @IBAction func showSavedButtonTap(_ sender: Any) {
        self.showOnlySaved.toggle()
        print(self.showOnlySaved ? "Showing saved posts": "Showing all posts")
        
        if self.showOnlySaved {
            self.showSavedButton.setImage(UIImage.init(systemName: "bookmark.fill"), for: .normal)
            self.searchField.isHidden = false
            self.listOfPost = self.savedPost
        }
        else {
            self.showSavedButton.setImage(UIImage.init(systemName: "bookmark"), for: .normal)
            self.searchField.isHidden = true
            self.listOfPost=self.allPost
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
        
        self.savedPost = loadPostsFromFile() ?? []
        
        
        Task {
            let af = after ?? ""
            let (post, after) = try await NetworkRequest().fetchPosts(subreddit: "ios", limit: limit, after: af)
            if let posts = post {
                DispatchQueue.main.async {
                    
                    let list = posts.map { p in
                        var temp = p
                        if self.savedPost.contains(where: { $0.id == temp.id }) {
                            temp.isSaved = true
                        } else {
                            temp.isSaved = false
                        }
                        return temp
                    }
                    
                    self.listOfPost.append(contentsOf:  list)
                    self.allPost.append(contentsOf: list)
                    //self.savedPost.append(contentsOf: list)
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
        self.searchField.delegate = self
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
    
    func savePostsToFile() {
        do {
            print("Saving data")
            let encoder = JSONEncoder()
            encoder.outputFormatting = .prettyPrinted
            let data = try encoder.encode(self.savedPost)
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
            print("Load data from file")
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

extension PostListViewController: UITableViewDataSource {
    
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
        cell.postView.delegate=self
        return cell
        
    }
}
extension PostListViewController : UITableViewDelegate{
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

       if !self.showOnlySaved && !isLoadingMore && offsetY > contentHeight - screenHeight - CGFloat(pToDeload)  {
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

extension PostListViewController : ShareButtonDelegate {
    func didTapShareButton(url: URL) {
        print("ttttt")
        let activityViewController = UIActivityViewController(activityItems: [url], applicationActivities: nil)
                self.present(activityViewController, animated: true, completion: nil)
    }
}

extension PostListViewController: UITextFieldDelegate {
    func textField(
        _ textField: UITextField,
        shouldChangeCharactersIn range: NSRange,
        replacementString string: String
    ) -> Bool {
        let searchText = (textField.text ?? "") + string

        self.listOfPost =
        self.savedPost.filter({
            $0.title.lowercased().contains(searchText.lowercased())
        })

        postTable.reloadData()
        return true
    }
}
