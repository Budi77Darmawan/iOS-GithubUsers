//
//  ViewController.swift
//  Github Users
//
//  Created by Budi Darmawan on 14/05/21.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var progressIndicator: UIActivityIndicatorView!
    @IBOutlet weak var usersTableView: UITableView!
    
    private let searchController = UISearchController(searchResultsController: nil)
    private var debouncer: Debouncer!
    private var searchText = ""
    private var users: [User] = []
    private var username = ""
    private var isSearching = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        debouncer = Debouncer.init(delay: 0.5, callback: fetchDataUsersByUsername)

        usersTableView.dataSource = self
        usersTableView.delegate = self
        usersTableView.register(UINib(nibName: "UserTableViewCell", bundle: nil), forCellReuseIdentifier: UserTableViewCell.reuseIdentifier)
        usersTableView.tableFooterView = UIView()
        showBackgroundTable(true)
        
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        definesPresentationContext = true
    }
    
    @IBAction func iconProfile(_ sender: Any) {
        performSegue(withIdentifier: "gotoProfile", sender: self)
    }
    
    @IBAction func iconFavorite(_ sender: Any) {
        performSegue(withIdentifier: "gotoFavorite", sender: self)
    }
    
    private func showBackgroundTable(_ isVisible: Bool) {
        if isVisible {
            if isSearching {
                usersTableView.setEmptyViewWithImage(title: "User not found!", message: "Please check the search username again.", messageImage: UIImage(named: "not_found")!)
            } else {
                usersTableView.setEmptyViewWithImage(title: "Waiting to search!", message: "Search result will appear here.", messageImage: UIImage(named: "search")!)
            }
        } else {
            usersTableView.restore()
        }
    }

    private func fetchDataUsersByUsername() {
        ApiManager.shared.fetchUsersByUsername(username: searchText) { listUser in
            self.users = listUser ?? []
            if !self.users.isEmpty {
                self.showBackgroundTable(false)
            } else {
                self.showBackgroundTable(true)
            }
            self.usersTableView.isHidden = false
            self.usersTableView.reloadData()
            if !self.users.isEmpty {
                self.usersTableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: UITableView.ScrollPosition.top, animated: true)
            }
            self.progressIndicator.stopAnimating()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let sceneDetail = segue.destination as? DetailViewController else {
            return
        }
        sceneDetail.username = self.username
    }
}
    
extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: UserTableViewCell.reuseIdentifier, for: indexPath) as? UserTableViewCell {
        
            let user = self.users[indexPath.row]
            cell.configureCell(user)
            return cell
        } else {
            return UITableViewCell()
        }
    }
}

extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        username = users[indexPath.row].login
        performSegue(withIdentifier: "gotoDetail", sender: self)
    }
}

extension ViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchText = searchController.searchBar.text else {
            return
        }
        self.searchText = searchText

        self.usersTableView.isHidden = true
        if self.searchText.isEmpty {
            isSearching = false
            showBackgroundTable(true)
            users = []
            self.usersTableView.reloadData()
            self.usersTableView.isHidden = false
            self.progressIndicator.stopAnimating()
            debouncer.cancel()
            print("Empty search")
        } else {
            isSearching = true
            self.progressIndicator.startAnimating()
            debouncer.call()
        }
    }
}

