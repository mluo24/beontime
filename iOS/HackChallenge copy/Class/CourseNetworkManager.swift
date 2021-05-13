//
//  CourseNetworkManager.swift
//  HackChallenge
//
//  Created by Jessie Chen on 10/5/2021.
//

import Foundation
import Alamofire

class CourseNetworkManager{
    
    static let host = "http://beontimeapp.herokuapp.com/"
    
    static func addCourse(subject: String, code: String, name: String, days_on: String, time: String, completion: @escaping(Course) -> Void){
        let endpoint = "\(host)api/courses/"
        guard let token = sessionResponse.currentSession?.session_token else {
            return}
        let headers: HTTPHeaders = [
            "Authorization": token
        ]
        let parameters : [String:String] = [
            "subject":subject,
            "code":code,
            "name": name,
            "days_on": days_on,
            "time":time]
//        AF.request(endpoint, method: .post, headers: headers).validate().responseData { response in
        AF.request(endpoint, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers).validate().responseData{ response in
            switch response.result{
            case .success(let data):
                let jsonDecoder = JSONDecoder()
                if let coursesResponse = try? jsonDecoder.decode(CourseResponse.self, from: data){
                    completion(coursesResponse.data)
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
        
    }
    
    static func getCourses(completion: @escaping([Course]) -> Void){
        let endpoint = "\(host)api/courses/"
        AF.request(endpoint, method: .get).validate().responseData { response in
            switch response.result{
            case .success(let data):
                let jsonDecoder = JSONDecoder()
                if let coursesResponse = try? jsonDecoder.decode([Course].self, from: data){
                    completion(coursesResponse)
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
        
    }
    
    static func getCourse(id: Int, completion: @escaping(Course) -> Void){
        let endpoint = "\(host)api/courses/\(id)/"
        guard let token = sessionResponse.currentSession?.session_token else {
            return}
        let headers: HTTPHeaders = [
            "Authorization": token
        ]
        AF.request(endpoint, method: .get, headers: headers).validate().responseData { response in
            switch response.result{
            case .success(let data):
                let jsonDecoder = JSONDecoder()
                if let courseResponse = try? jsonDecoder.decode(Course.self, from: data){
                    completion(courseResponse)
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
        
    }
}
