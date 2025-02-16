//
//  PostsViewController.swift
//  Test_exam_kamel_alaghbari
//
//  Created by Kamel Alaghbari on 05/02/2025.
//
import UIKit
import RxSwift
import RxCocoa
// MARK: - Posts ViewController
class PostsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
    
    private var viewModel:PostViewModel? = nil
    private let disposeBag = DisposeBag()
    
    private var filteredPosts: [ResponsePost] = []
    private var posts: [ResponsePost] = []
    private let tableView = UITableView()
    private let refreshControl = UIRefreshControl()
    private let searchBar = UISearchBar()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Posts"
        view.backgroundColor = .white
        setupSearchBar()
        setupTableView()
        setupNavigationBar()
        
        viewModel = PostViewModel()
        subscribeToLoading()
        subscribeToErrorMessage()
        
        if InternetConnectionManager.isConnectedToNetwork()
        {
            viewModel?.getAllPosts()
        }
        else
        {
            
            self.displayMessage(titleMsg: "Warning", message: "No Internet Connection", messageStatus: .MessageError)
        }
        subscribeToResponse()
     
//        fetchPosts()
    }
    
    private func setupNavigationBar() {
           navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addPost))
       }
    
    @objc private func addPost() {
          let addPostVC = PostEntryViewController()
            navigationController?.pushViewController(addPostVC, animated: true)
       }
    
    private func setupSearchBar() {
        searchBar.delegate = self
        searchBar.placeholder = "Search Posts"
        navigationItem.titleView = searchBar
    }
    
    func subscribeToErrorMessage()
    {
        viewModel?.messageError.subscribe(onNext: {[weak self] errorMessage in
            guard let self = self else {return}
            DispatchQueue.main.async {
                
                self.refreshControl.endRefreshing()
                self.displayMessage(titleMsg: "Error", message:  "\(errorMessage)" , messageStatus: .MessageError)
                
            }
            
        }).disposed(by: disposeBag)
    }
    
    func subscribeToLoading()
    {
        viewModel?.loadingBehavior.subscribe(onNext: {[weak self] isLoading in
            guard let self = self else {return}
            DispatchQueue.main.async {
                if isLoading {
                    self.showLoadingDialog()
                } else {
                    self.refreshControl.endRefreshing()
                    self.hideMyDialog()
                }
            }
        }).disposed(by: disposeBag)
    }

    
    
    func subscribeToResponse()
    {
        
        viewModel?.allPostsModelObservable.subscribe(onNext: {[weak self] postList in
            
            guard let self = self else {return}
            
            if postList.count > 0
            {
                self.posts = postList
                self.filteredPosts = postList 
                DispatchQueue.main.async {
                    self.refreshControl.endRefreshing()
                    self.tableView.reloadData()
                }
            }
            
            
        }).disposed(by: disposeBag)
    }
    
    private func setupTableView() {
        tableView.frame = view.bounds
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "postCell")

        refreshControl.addTarget(self, action: #selector(fetchPosts), for: .valueChanged)
        tableView.refreshControl = refreshControl

        view.addSubview(tableView)
    }

    @objc private func fetchPosts() {
//        viewModel?.getAllPosts()
//        NetworkManager.shared.fetchPosts { [weak self] result in
//            DispatchQueue.main.async {
//                self?.refreshControl.endRefreshing()
//                switch result {
//                case .success(let posts):
//                    self?.posts = posts
//                    self?.tableView.reloadData()
//                case .failure(let error):
//                    print("Error fetching posts: \(error.localizedDescription)")
//                }
//            }
//        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredPosts.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "postCell", for: indexPath)
        let post = filteredPosts[indexPath.row]
        cell.textLabel?.text = "\(post.id ?? 0) - \(post.title ?? "No title")"
        return cell
    }
    
    
    // MARK: - UITableViewDelegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let post = filteredPosts[indexPath.row]
        
        let detailsVC = PostDetailsViewController(post: post)
        navigationController?.pushViewController(detailsVC, animated: true)
    }
    // MARK: - UISearchBarDelegate
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            filteredPosts = posts
        } else {
            filteredPosts = posts.filter { $0.title?.lowercased().contains(searchText.lowercased()) ?? false }
        }
        tableView.reloadData()
    }
}


