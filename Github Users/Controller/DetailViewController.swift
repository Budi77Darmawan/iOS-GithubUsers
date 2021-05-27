//
//  DetailViewController.swift
//  Github Users
//
//  Created by Budi Darmawan on 16/05/21.
//

import UIKit
import Alamofire
import RealmSwift
import Toast_Swift

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
    private var detailUser = DetailUser(id: 0, login: "", avatar_url: "", type: "", name: "", company: "", location: "", followers: 0, following: 0)
    private var followers: [User] = []
    private var following: [User] = []
    private var selectedTab: [User] = []
    private var isTabFollowers: Bool = true
    private var isFavorite: Bool = false
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
                self.view.makeToast("Has been removed from the user's favorites list")
            }
        } else {
            try! realmDB.write {
                realmDB.add(t)
                isFavorite = !isFavorite
                btnFavourite.setImage(UIImage(named: "favorite"), for: .normal)
                self.view.makeToast("Successfully added to the user's favorite list")
            }
        }
    }
    
    private func initTableView() {
        userTableView.dataSource = self
        userTableView.register(UINib(nibName: "UserTableViewCell", bundle: nil), forCellReuseIdentifier: UserTableViewCell.reuseIdentifier)
        userTableView.tableFooterView = UIView()
    }
    
    private func fetchDataDetail() {
        if username.isEmpty { return }
        ApiManager.shared.fetchDetailUser(username: username) { detail in
            if detail != nil {
                self.detailUser = detail!
                self.setView()
            }
            self.updateProgressBar()
        }
    }
    
    private func fetchDataFollowers() {
        if username.isEmpty { return }
        ApiManager.shared.fecthFollowersUser(username: username) { listFollowers in
            if listFollowers != nil {
                self.followers = listFollowers!
            }
            self.selectedTab = self.followers
            if !self.selectedTab.isEmpty {
                self.showBackgroundTable(false)
            } else {
                self.showBackgroundTable(true)
            }
            self.userTableView.reloadData()
            self.updateProgressBar()
        }
    }
    
    private func fetchDataFollowing() {
        if username.isEmpty { return }
        ApiManager.shared.fecthFollowingUser(username: username) { listFollowing in
            if listFollowing != nil {
                self.following = listFollowing!
            }
            self.updateProgressBar()
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
        fullnameUser.text = detailUser.name ?? "No Name"
        usernameUser.text = ("@\(detailUser.login)")
        companyUser.text = detailUser.company ?? "-"
        locationUser.text = detailUser.location ?? "-"
        readDatabase()
        guard let photoUserUrl = URL(string: detailUser.avatar_url) else {
            return
        }
        photoUser.setImage(photoUserUrl)
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
        if let cell = tableView.dequeueReusableCell(withIdentifier: UserTableViewCell.reuseIdentifier, for: indexPath) as? UserTableViewCell {
        
            let user = self.selectedTab[indexPath.row]
            cell.configureCell(user)
            return cell
        } else {
            return UITableViewCell()
        }
    }
}
