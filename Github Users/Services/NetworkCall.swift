//
//  NetworkCall.swift
//  Github Users
//
//  Created by Bayu Kurniawan on 6/8/21.
//

import Foundation
import Alamofire

class NetworkCall : NSObject {
  
  var url: String = ConstServices.BaseAPI.github
  var headers: HTTPHeaders = ConstServices.headers
  var method: HTTPMethod = .get
  var parameters: Parameters? = nil
  
  init(url: String, params: Parameters?){
    super.init()
    self.url += url
    self.parameters = params
  }
  
  func executeQuery<T> (completion: @escaping (Result<T, Error>) -> Void) where T: Decodable {
    AF.request(url, method: method, parameters: parameters, headers: headers)
      .validate(statusCode: 200...299)
      .responseJSON { response in
        switch response.result {
        case .success:
          guard let data = response.data else { return }
          do {
            let result = try JSONDecoder().decode(T.self, from: data)
            completion(.success(result))
          } catch let error {
            completion(.failure(error))
          }
        case .failure(let error):
          completion(.failure(error))
        }
      }
  }
}
