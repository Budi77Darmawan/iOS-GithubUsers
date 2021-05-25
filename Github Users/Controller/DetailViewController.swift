//
//  DetailViewController.swift
//  Github Users
//
//  Created by Budi Darmawan on 16/05/21.
//

import UIKit
import Alamofire
import RealmSwift

class DetailViewController: UIViewController {
    
    @IBOutlet weak var progressBar: UIProgressView!
    @IBOutlet weak var photoUser: UIImageView!
    @IBOutlet weak var fullnameUser: UILabel!
    @IBOutlet weak var usernameUser: UILabel!
    @IBOutlet weak var companyUser: UILabel!
    @IBOutlet weak var locationUser: UILabel!
    @IBOutlet weak var userTableView: UITableView!
    @IBOutlet var btnFavourite: UIButton!
    
    var username: String = ""
    var isFavorite: Bool = false
    private var detailUser = DetailUser(id: 0, login: "", avatar_url: "", type: "", name: "", company: "", location: "", followers: 0, following: 0)
    private var followers: [User] = []
    private var following: [User] = []
    private var selectedTab: [User] = []
    private var isTabFollowers: Bool = true
    private var progress: Float = 0.25
    private var realmDB: Realm!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        realmDB = try! Realm()
        photoUser.makeRounded()
        initTableView()
        fetchDataDetail()
        fetchDataFollowers()
        fetchDataFollowing()
    }
    
    func updateRighBarButton(_ isFavourite : Bool){
        btnFavourite = UIButton(frame: CoreGraphics.CGRect(x: 0,y: 0,width: 30,height: 30))
        btnFavourite.addTarget(self, action: #selector(btnFavouriteDidTap), for: UIControl.Event.touchUpInside)

        if isFavourite {
            btnFavourite.setImage(UIImage(named: "favorite"), for: .normal)
        } else {
            btnFavourite.setImage(UIImage(named: "unfavorite"), for: .normal)
        }
        
        let rightButton = UIBarButtonItem(customView: btnFavourite)
        self.navigationItem.setRightBarButtonItems([rightButton], animated: true)
        
    }
    
    @objc func btnFavouriteDidTap() {
        let t = ObjUser()
        t.id = detailUser.id
        t.login = detailUser.login
        t.avatar_url = detailUser.avatar_url
        t.type = detailUser.type

        if isFavorite {
            try! realmDB.write {
                realmDB.delete(realmDB.objects(ObjUser.self).filter("id=%@", t.id))
                isFavorite = !isFavorite
                btnFavourite.setImage(UIImage(named: "unfavorite"), for: .normal)
            }
        } else {
            try! realmDB.write {
                realmDB.add(t)
                isFavorite = !isFavorite
                btnFavourite.setImage(UIImage(named: "favorite"), for: .normal)
            }
        }
    }
    
    private func initTableView() {
        userTableView.dataSource = self
        userTableView.register(UINib(nibName: "UserTableViewCell", bundle: nil), forCellReuseIdentifier: "UserCell")
        userTableView.tableFooterView = UIView()
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
                        let detail = try JSONDecoder().decode(DetailUser.self, from: data)
                        self.detailUser = detail
                        self.setView()
                        print("\nDetail User -> \(self.detailUser)\n")
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
                        if !self.selectedTab.isEmpty {
                            self.showBackgroundTable(false)
                        } else {
                            self.showBackgroundTable(true)
                        }
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
        
    private func setView() {
        photoUser.setImage(URL(string: detailUser.avatar_url)!)
        fullnameUser.text = detailUser.name ?? "No Name"
        usernameUser.text = ("@\(detailUser.login)")
        companyUser.text = detailUser.company ?? "-"
        locationUser.text = detailUser.location ?? "-"
        readDatabase()
    }
    
    private func readDatabase() {
        let usersDB = realmDB.objects(ObjUser.self)
        for user in usersDB {
            if detailUser.id == user.id {
                isFavorite = true
                break
            }
        }
        updateRighBarButton(isFavorite)
    }
    
    private func showBackgroundTable(_ isVisible: Bool) {
        var title = ""
        var message = ""
        if isVisible {
            if isTabFollowers {
                title = "No followers"
                message = "User has no followers yet"
            } else {
                title = "Not following anyone"
                message = "User hasn't followed anyone yet"
            }
            userTableView.setEmptyViewWithTitle(title: title, message: message)
        } else {
            userTableView.restore()
        }
    }
    
    
    @IBAction func selectedTab(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            selectedTab = followers
            isTabFollowers = true
        case 1:
            selectedTab = following
            isTabFollowers = false
        default:
            selectedTab = followers
            isTabFollowers = true
        }
        if !selectedTab.isEmpty {
            self.userTableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: UITableView.ScrollPosition.top, animated: true)
            self.showBackgroundTable(false)
        } else {
            self.showBackgroundTable(true)
        }
        self.userTableView.reloadData()
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
