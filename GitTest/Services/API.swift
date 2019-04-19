//
//  API.swift
//  GitTest
//
//  Created by Developer on 4/19/19.
//  Copyright © 2019 Developer. All rights reserved.
//

import Foundation
import Alamofire

class ContributorsAPI: NSObject {
    
    private enum API {
        static let sitePath = "https://api.github.com"
        static let clientId = "932306a5678e9af8c6b4d821ea9cf0c6320f3b61"
    }
    
    // fetching array of contributors
    class func fetchContributors(owner: String, repo: String, completion: @escaping ([Contributor]?, String?) -> ()) {
        
        let url = "\(API.sitePath)/repos/\(owner)/\(repo)/contributors"
        let headers = ["Authorization": API.clientId]
        
        Alamofire.request(url, method: .get, parameters: nil, encoding: URLEncoding.default, headers: headers).responseData { response in
            if let limitLoaders = response.response?.allHeaderFields["x-ratelimit-remaining"] as? String {
                print("x-ratelimit-remaining: \(limitLoaders)") // LOG
            }
            
            switch response.result {
            case .success(let data):
                if let jsonString = String(data: data, encoding: .utf8) {
                    print(jsonString)
                }
                
                let contributors: [Contributor]? = try? JSONDecoder().decode([Contributor].self, from: data)

                var error: String?
                if contributors == nil {
                    let errorInfo = try? JSONDecoder().decode(ErrorData.self, from: data)
                    error = errorInfo?.errors.first ?? "Unknown Error"
                }
                completion(contributors, error)
            case .failure(let error):
                print("Request failed with error: \(error)")
            }
        }
    }
    
    // fetching location
    class func fetchLocation(username: String, completion: @escaping (User?, String?) -> ()) {
        
        let url = "\(API.sitePath)/users/\(username)"
        let headers = ["Authorization": API.clientId]
        
        Alamofire.request(url, method: .get, parameters: nil, encoding: URLEncoding.default, headers: headers).responseData { response in
            if let limitLoaders = response.response?.allHeaderFields["x-ratelimit-remaining"] as? String {
                print("x-ratelimit-remaining: \(limitLoaders)") // LOG
            }
            
            switch response.result {
            case .success(let data):
                if let jsonString = String(data: data, encoding: .utf8) {
                    print(jsonString)
                }
                
                let user: User? = try? JSONDecoder().decode(User.self, from: data)
                
                var error: String?
                if user == nil {
                    let errorInfo = try? JSONDecoder().decode(ErrorData.self, from: data)
                    error = errorInfo?.errors.first ?? "Unknown Error"
                }
                completion(user, error)
            case .failure(let error):
                print("Request failed with error: \(error)")
            }
        }
    }
}
