//
//  ImageExt.swift
//  Github Users
//
//  Created by Budi Darmawan on 17/05/21.
//

import Foundation
import UIKit
import Kingfisher

extension UIImageView {
    
    func makeRounded() {
        self.layer.cornerRadius = self.frame.height / 2
        self.clipsToBounds = true
        self.layer.borderWidth = 0.6
        self.layer.borderColor = UIColor.darkGray.cgColor
    }
    
    func setImage(_ imageURL: URL) {
        self.kf.setImage(with: imageURL, placeholder: UIImage(named: "profile"))
    }
}
