//
//  UserNetworkManager.swift
//  HackChallenge
//
//  Created by Jessie Chen on 10/5/2021.
//

import Foundation
import Alamofire

class UserNetworkManager{
    
    static let host = "http://beontimeapp.herokuapp.com/"
    
    static func checkUser(email: String, password: String, completion: @escaping(sessionResponse) -> Void){
        let endpoint = "\(host)login/"
        let parameters: [String: Any] = [
            "email": email,
            "password": password
        ]
        AF.request(endpoint, method: .post, parameters: parameters, encoding: JSONEncoding.default).validate().responseData{ response in
            switch response.result{
            case .success(let data):
                let jsonDecoder = JSONDecoder()
                
                if let userResponse = try? jsonDecoder.decode(sessionResponse.self, from: data){
                    completion(userResponse)
                }
            case.failure(let error):
                print(error.localizedDescription)
            }
        }
        
    }
    
    static func createUser(email: String, password: String, name: String, netid: String, completion: @escaping(User) -> Void){
        let endpoint = "\(host)register/"
        let parameters: [String: Any] = [
            "email": email,
            "password": password,
            "name": name,
            "netid": netid
        ]
        AF.request(endpoint, method: .post, parameters: parameters, encoding: JSONEncoding.default).validate().responseData{ response in
            switch response.result{
            case .success(let data):
                let jsonDecoder = JSONDecoder()
                
                if let userResponse = try? jsonDecoder.decode(User.self, from: data){
                    completion(userResponse)
                }
            case.failure(let error):
                print(error.localizedDescription)
            }
        }
        
    }
    
    
    
}
