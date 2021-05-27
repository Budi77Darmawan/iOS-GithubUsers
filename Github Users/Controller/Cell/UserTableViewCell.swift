//
//  UserTableViewCell.swift
//  Github Users
//
//  Created by Budi Darmawan on 14/05/21.
//

import UIKit

class UserTableViewCell: UITableViewCell {
    
    static let reuseIdentifier = "UserTableViewCell"

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
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    
}
