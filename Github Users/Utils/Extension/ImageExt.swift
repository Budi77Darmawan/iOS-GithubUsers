//
//  ImageExt.swift
//  Github Users
//
//  Created by Budi Darmawan on 17/05/21.
//

import Foundation
import UIKit

extension UIImageView {
    
    func makeRounded() {
        self.layer.cornerRadius = self.frame.height / 2
        self.clipsToBounds = true
        self.layer.borderWidth = 0.6
        self.layer.borderColor = UIColor.darkGray.cgColor
    }
    
    func setImage(_ imageURL: URL) {
        DispatchQueue.global().async {
            if let data = try? Data(contentsOf: imageURL) {
            if let image = UIImage(data: data) {
                DispatchQueue.main.async {
                    self.image = image
                }
            }}
        }
    }
}
