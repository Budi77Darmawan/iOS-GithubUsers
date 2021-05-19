//
//  ViewController.swift
//  Github Users
//
//  Created by Budi Darmawan on 14/05/21.
//

import UIKit
import Alamofire

class ViewController: UIViewController {
    
    @IBOutlet weak var progressIndicator: UIActivityIndicatorView!
    @IBOutlet weak var usersTableView: UITableView!
    
    let searchController = UISearchController(searchResultsController: nil)
    private var debouncer: Debouncer!
    private var searchText: String = ""
    private var searchUrl: String = ""
    private var users: [User] = []
    private var username: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        debouncer = Debouncer.init(delay: 0.5, callback: fetchData)

        usersTableView.dataSource = self
        usersTableView.delegate = self
        usersTableView.register(UINib(nibName: "UserTableViewCell", bundle: nil), forCellReuseIdentifier: "UserCell")
        usersTableView.isHidden = true
        
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        definesPresentationContext = true
    }
    
    @IBAction func iconProfile(_ sender: Any) {
        performSegue(withIdentifier: "gotoProfile", sender: self)
    }

    private func fetchData() {
        AF.request(searchUrl, method: .get, headers: Services.headers)
            .validate(statusCode: 200..<300)
            .responseJSON { response in
                switch response.result {
                case .success:
                    guard let data = response.data else { return }
                    do {
                        let users = try JSONDecoder().decode(Users.self, from: data)
                        self.users = users.items
                        if !self.users.isEmpty {
                            self.visibleTable(true)
                            self.usersTableView.reloadData()
                            if self.usersTableView.contentSize.height < self.usersTableView.frame.size.height {
                                self.usersTableView.isScrollEnabled = false
                             }
                            else {
                                self.usersTableView.isScrollEnabled = true
                             }
                            print(users)
                        } else {
                            self.visibleTable(false)
                            print("Not found")
                        }
                        self.progressIndicator.stopAnimating()
                    } catch {
                        print("Error Decoder -> \(error)")
                        self.progressIndicator.stopAnimating()
                    }
                case .failure(let error):
                    print("Error -> \(error)")
                    self.progressIndicator.stopAnimating()
                }
        }
    }

    func visibleTable(_ visible: Bool) {
        self.usersTableView.isHidden = !visible
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
        if let cell = tableView.dequeueReusableCell(withIdentifier: "UserCell", for: indexPath) as? UserTableViewCell {
        
            let user = self.users[indexPath.row]
            cell.nameUser.text = user.login
            cell.typeUser.text = user.type
            
            let photoUserUrl = URL(string: user.avatar_url)!
            cell.photoUser.setImage(photoUserUrl)
            cell.photoUser.makeRounded()
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

        visibleTable(false)
        if self.searchText.isEmpty {
            self.progressIndicator.stopAnimating()
            debouncer.cancel()
            print("Empty search")
        } else {
            let baseSearchUrl = Services.BaseAPI.User.search
            self.searchUrl = baseSearchUrl.replacingOccurrences(of: "{username}", with: searchText)
            self.progressIndicator.startAnimating()
            debouncer.call()
        }
    }
}

