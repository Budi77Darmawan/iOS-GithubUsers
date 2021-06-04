//
//  UserTableViewCell.swift
//  Github Users
//
//  Created by Budi Darmawan on 14/05/21.
//

import UIKit

class UserTableViewCell: UITableViewCell {
    
    static let reuseIdentifier = "UserTableViewCell"

    @IBOutlet var cardView: UIView!
    @IBOutlet weak var photoUser: UIImageView!
    @IBOutlet weak var nameUser: UILabel!
    @IBOutlet weak var typeUser: UILabel!
    
    func configureCell(_ user: User) {
        nameUser.text = user.login
        typeUser.text = user.type
        
        guard let photoUserUrl = URL(string: user.avatar_url) else {
            return
        }
        photoUser.setImage(photoUserUrl)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        photoUser.makeRounded()
        cardView.backgroundColor = .white
        cardView.layer.cornerRadius = 10
        cardView.layer.masksToBounds = false
        cardView.layer.shadowRadius = 2
        cardView.layer.shadowOpacity = 0.7
        cardView.layer.shadowOffset = CGSize(width: 0, height: 0.5)
        cardView.layer.shadowColor =  UIColor.lightGray.cgColor
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    
}
