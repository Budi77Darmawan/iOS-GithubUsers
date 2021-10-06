//
//  ModelUser.swift
//  Github Users
//
//  Created by Budi Darmawan on 15/05/21.
//

import Foundation

struct Users: Decodable {
    let items: [User]
}

struct User: Decodable {
    let id: Int
    let login: String
    let avatar_url: String
    let type: String
}

struct DetailUser: Decodable {
    let id: Int
    let login: String
    let avatar_url: String
    let type: String
    let name: String?
    let company: String?
    let location: String?
    let followers: Int
    let following: Int
}
