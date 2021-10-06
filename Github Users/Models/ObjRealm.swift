//
//  Realm.swift
//  Github Users
//
//  Created by Budi Darmawan on 22/05/21.
//

import Foundation
import RealmSwift

class ObjUser: Object {
    @objc dynamic var id: Int = 0
    @objc dynamic var login: String = ""
    @objc dynamic var avatar_url: String = ""
    @objc dynamic var type: String = ""
}
