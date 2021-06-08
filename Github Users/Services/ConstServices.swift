//
//  Constant.swift
//  Github Users
//
//  Created by Budi Darmawan on 15/05/21.
//

import Foundation
import Alamofire

struct ConstServices {
    
    static let headers: HTTPHeaders = [
        "Authorization": "token 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"
    ]
    
    struct BaseAPI {
      static let github = "https://api.github.com/"
        struct User {
            static let search = "search/users"
            static let detail = "users/{username}"
            static let followers = "users/{username}/followers"
            static let following = "users/{username}/following"
        }
    }
}
