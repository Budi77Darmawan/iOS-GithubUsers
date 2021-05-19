//
//  DetailViewController.swift
//  Github Users
//
//  Created by Budi Darmawan on 16/05/21.
//

import UIKit
import Alamofire

class DetailViewController: UIViewController {

    @IBOutlet weak var progressBar: UIProgressView!
    @IBOutlet weak var photoUser: UIImageView!
    @IBOutlet weak var fullnameUser: UILabel!
    @IBOutlet weak var usernameUser: UILabel!
    @IBOutlet weak var companyUser: UILabel!
    @IBOutlet weak var locationUser: UILabel!
    @IBOutlet weak var userTableView: UITableView!

    var username: String = ""
    private var followers: [User] = []
    private var following: [User] = []
    private var selectedTab: [User] = []
    private var progress: Float = 0.25
    
    override func viewDidLoad() {
        super.viewDidLoad()

        print("\nUsername -> \(username)")
        photoUser.makeRounded()
        initTableView()
        fetchDataDetail()
        fetchDataFollowers()
        fetchDataFollowing()
    }
    
    private func initTableView() {
        userTableView.dataSource = self
        userTableView.register(UINib(nibName: "UserTableViewCell", bundle: nil), forCellReuseIdentifier: "UserCell")
    }
    
    private func fetchDataDetail() {
        if username.isEmpty { return }
        var baseDetailUrl = Services.BaseAPI.User.detail
        baseDetailUrl = baseDetailUrl.replacingOccurrences(of: "{username}", with: username)
        
        AF.request(baseDetailUrl, method: .get, headers: Services.headers)
            .validate(statusCode: 200..<300)
            .responseJSON { response in
                switch response.result {
                case .success:
                    guard let data = response.data else { return }
                    do {
                        let detailUser = try JSONDecoder().decode(DetailUser.self, from: data)
                        self.setView(detailUser)
                        print("\nDetail User -> \(detailUser)\n")
                    } catch {
                        print("Error Decoder -> \(error)")
                    }
                    self.updateProgressBar()
                case .failure(let error):
                    print("Error -> \(error)")
                    self.updateProgressBar()
                }
        }
    }
    
    private func fetchDataFollowers() {
        if username.isEmpty { return }
        var baseFollowersUrl = Services.BaseAPI.User.followers
        baseFollowersUrl = baseFollowersUrl.replacingOccurrences(of: "{username}", with: username)
        
        AF.request(baseFollowersUrl, method: .get, headers: Services.headers)
            .validate(statusCode: 200..<300)
            .responseJSON { response in
                switch response.result {
                case .success:
                    guard let data = response.data else { return }
                    do {
                        self.followers = try JSONDecoder().decode([User].self, from: data)
                        print("\nFollowers -> \(self.followers)\n")
                        self.selectedTab = self.followers
                        self.userTableView.reloadData()
                    } catch {
                        print("Error Decoder -> \(error)")
                    }
                    self.updateProgressBar()
                case .failure(let error):
                    print("Error -> \(error)")
                    self.updateProgressBar()
                }
        }
    }
    
    private func fetchDataFollowing() {
        if username.isEmpty { return }
        var baseFollowingUrl = Services.BaseAPI.User.following
        baseFollowingUrl = baseFollowingUrl.replacingOccurrences(of: "{username}", with: username)
        
        AF.request(baseFollowingUrl, method: .get, headers: Services.headers)
            .validate(statusCode: 200..<300)
            .responseJSON { response in
                switch response.result {
                case .success:
                    guard let data = response.data else { return }
                    do {
                        self.following = try JSONDecoder().decode([User].self, from: data)
                        print("\nFollowing -> \(self.following)\n")
                    } catch {
                        print("Error Decoder -> \(error)")
                    }
                    self.updateProgressBar()
                case .failure(let error):
                    print("Error -> \(error)")
                    self.updateProgressBar()
                }
        }
    }
    
    private func updateProgressBar() {
        progress += progress
        self.progressBar.progress = progress
        if progress >= 1 {
            self.progressBar.isHidden = true
        }
    }
    
    private func setView(_ detail: DetailUser) {
        photoUser.setImage(URL(string: detail.avatar_url)!)
        fullnameUser.text = detail.name ?? "No Name"
        usernameUser.text = ("@\(detail.login)")
        companyUser.text = detail.company ?? "-"
        locationUser.text = detail.location ?? "-"
    }
    
    
    @IBAction func selectedTab(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            selectedTab = followers
        case 1:
            selectedTab = following
        default:
            selectedTab = followers
        }
        self.userTableView.reloadData()
        self.userTableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: UITableView.ScrollPosition.top, animated: true)
    }
    
    
}

extension DetailViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.selectedTab.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "UserCell", for: indexPath) as? UserTableViewCell {
        
            let user = self.selectedTab[indexPath.row]
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
