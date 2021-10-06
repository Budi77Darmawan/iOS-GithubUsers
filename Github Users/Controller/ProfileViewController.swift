//
//  ProfileViewController.swift
//  Github Users
//
//  Created by Budi Darmawan on 16/05/21.
//

import UIKit

class ProfileViewController: UIViewController {

    @IBOutlet weak var photoProfile: UIImageView!
    @IBOutlet weak var fullnameProfile: UILabel!
    @IBOutlet weak var numberPhone: UILabel!
    @IBOutlet weak var cardStatus: UIView!
    @IBOutlet weak var email: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        photoProfile.makeRounded()
        initCardStatus()
        
    }
    
    private func initCardStatus() {
        cardStatus.layer.shadowColor = UIColor.gray.cgColor
        cardStatus.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        cardStatus.layer.shadowRadius = 4.0
        cardStatus.layer.shadowOpacity = 0.4
    }
}
