//
//  FavoriteViewController.swift
//  Github Users
//
//  Created by Budi Darmawan on 22/05/21.
//

import Foundation
import UIKit
import RealmSwift

class FavoriteViewController: UIViewController {
    
    @IBOutlet weak var usersTableView: UITableView!
    private var realmDB: Realm!
    private var users: [User] = []
    private var username = ""
    
    override func viewWillAppear(_ animated: Bool) {
        readDatabase()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        realmDB = try! Realm()
        
        usersTableView.dataSource = self
        usersTableView.delegate = self
        usersTableView.register(UINib(nibName: "UserTableViewCell", bundle: nil), forCellReuseIdentifier: UserTableViewCell.reuseIdentifier)
        usersTableView.tableFooterView = UIView()
    }
    
    private func readDatabase() {
        self.users = []
        let users = realmDB.objects(ObjUser.self)
        for user in users {
            let t = User(id: user.id, login: user.login, avatar_url: user.avatar_url, type: user.type)
            self.users.append(t)
        }
        if self.users.isEmpty {
            showBackgroundTable()
        }
        usersTableView.reloadData()
    }
    
    private func showBackgroundTable() {
        usersTableView.setEmptyViewWithImage(title: "Empty users", message: "There are no favorite users yet.", messageImage: UIImage(named: "empty")!)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let sceneDetail = segue.destination as? DetailViewController else {
            return
        }
        sceneDetail.username = self.username
    }
}

extension FavoriteViewController: UITableViewDataSource {
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

extension FavoriteViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        username = users[indexPath.row].login
        performSegue(withIdentifier: "gotoDetailFromFavorite", sender: self)
    }
}
