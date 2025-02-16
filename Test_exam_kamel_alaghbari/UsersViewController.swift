//
//  UsersViewController.swift
//  Test_exam_kamel_alaghbari
//
//  Created by Kamel Alaghbari on 04/02/2025.
//


import UIKit


// MARK: - Users ViewController
class UsersViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
    private var users: [User] = []
    private var filteredUsers: [User] = []
    private let tableView = UITableView()
    private let searchBar = UISearchBar()
    private let refreshControl = UIRefreshControl()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Users"
        view.backgroundColor = .white
        setupSearchBar()
        setupTableView()
        fetchData()
    }

    private func setupSearchBar() {
        searchBar.delegate = self
        searchBar.placeholder = "Search Users"
        navigationItem.titleView = searchBar
    }

    private func setupTableView() {
        tableView.frame = view.bounds
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        refreshControl.addTarget(self, action: #selector(refreshData), for: .valueChanged)
        tableView.refreshControl = refreshControl

        view.addSubview(tableView)
        
        tableView.refreshControl?.beginRefreshing()
        
        
    }

    @objc private func refreshData() {
        fetchData()
    }

    private func fetchData() {
        NetworkManager.shared.fetchUsers { [weak self] result in
            DispatchQueue.main.async {
                self?.refreshControl.endRefreshing()
                switch result {
                case .success(let users):
                    self?.users = users
                    self?.filteredUsers = users
                    self?.tableView.reloadData()
                case .failure(let error):
                    print("Error: \(error.localizedDescription)")
                }
            }
        }
    }

    // MARK: - UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredUsers.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let user = filteredUsers[indexPath.row]
        cell.textLabel?.text = "\(user.name) - \(user.email)"
        return cell
    }

    // MARK: - UITableViewDelegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let user = filteredUsers[indexPath.row]
        
        let detailsVC = UserDetailsViewController(user: user)
        navigationController?.pushViewController(detailsVC, animated: true)
    }

    // MARK: - UISearchBarDelegate
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            filteredUsers = users
        } else {
            filteredUsers = users.filter { $0.name.lowercased().contains(searchText.lowercased()) }
        }
        tableView.reloadData()
    }
}
