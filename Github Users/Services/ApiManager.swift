//
//  ApiManager.swift
//  Github Users
//
//  Created by Budi Darmawan on 25/05/21.
//

import Foundation
import Alamofire

class ApiManager {
    
    static let shared = ApiManager()
    
    func fetchUsersByUsername(username: String, completion: @escaping ([User]?) -> ()) {
        var baseSearchUrl = ConstServices.BaseAPI.User.search
        baseSearchUrl = baseSearchUrl.replacingOccurrences(of: "{username}", with: username)
        
        AF.request(baseSearchUrl, method: .get, headers: ConstServices.headers)
            .validate(statusCode: 200..<300)
            .responseJSON { response in
                switch response.result {
                case .success:
                    guard let data = response.data else { return }
                    do {
                        let users = try JSONDecoder().decode(Users.self, from: data)
                        completion(users.items)
                    } catch {
                        completion(nil)
                        print("Error Decoder -> \(error)")
                    }
                case .failure(let error):
                    completion(nil)
                    print("Error -> \(error)")
                }
        }
    }
    
    func fetchDetailUser(username: String, completion: @escaping (DetailUser?) -> ()) {
        var baseDetailUrl = ConstServices.BaseAPI.User.detail
        baseDetailUrl = baseDetailUrl.replacingOccurrences(of: "{username}", with: username)
        
        AF.request(baseDetailUrl, method: .get, headers: ConstServices.headers)
            .validate(statusCode: 200..<300)
            .responseJSON { response in
                switch response.result {
                case .success:
                    guard let data = response.data else { return }
                    do {
                        let detail = try JSONDecoder().decode(DetailUser.self, from: data)
                        completion(detail)
                    } catch {
                        completion(nil)
                        print("Error Decoder -> \(error)")
                    }
                case .failure(let error):
                    completion(nil)
                    print("Error -> \(error)")
                }
        }
    }
    
    func fecthFollowersUser(username: String, completion: @escaping ([User]?) -> ()) {
        var baseFollowersUrl = ConstServices.BaseAPI.User.followers
        baseFollowersUrl = baseFollowersUrl.replacingOccurrences(of: "{username}", with: username)
        
        AF.request(baseFollowersUrl, method: .get, headers: ConstServices.headers)
            .validate(statusCode: 200..<300)
            .responseJSON { response in
                switch response.result {
                case .success:
                    guard let data = response.data else { return }
                    do {
                        let followers = try JSONDecoder().decode([User].self, from: data)
                        completion(followers)
                    } catch {
                        completion(nil)
                        print("Error Decoder -> \(error)")
                    }
                case .failure(let error):
                    completion(nil)
                    print("Error -> \(error)")
                }
        }
    }
    
    func fecthFollowingUser(username: String, completion: @escaping ([User]?) -> ()) {
        var baseFollowingUrl = ConstServices.BaseAPI.User.following
        baseFollowingUrl = baseFollowingUrl.replacingOccurrences(of: "{username}", with: username)
        
        AF.request(baseFollowingUrl, method: .get, headers: ConstServices.headers)
            .validate(statusCode: 200..<300)
            .responseJSON { response in
                switch response.result {
                case .success:
                    guard let data = response.data else { return }
                    do {
                        let following = try JSONDecoder().decode([User].self, from: data)
                        completion(following)
                    } catch {
                        completion(nil)
                        print("Error Decoder -> \(error)")
                    }
                case .failure(let error):
                    completion(nil)
                    print("Error -> \(error)")
                }
        }
    }

    
}
