//
//  Constant.swift
//  Github Users
//
//  Created by Budi Darmawan on 15/05/21.
//

import Foundation
import Alamofire

struct Services {
    
    static let headers: HTTPHeaders = [
        "Authorization": "token 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"
    ]
    
    struct BaseAPI {
        struct User {
            static let search = "https://api.github.com/search/users?q={username}"
            static let detail = "https://api.github.com/users/{username}"
            static let followers = "https://api.github.com/users/{username}/followers"
            static let following = "https://api.github.com/users/{username}/following"
        }
    }
}
