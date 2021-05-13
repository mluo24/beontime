//
//  AssignmentNetworkManager.swift
//  HackChallenge
//
//  Created by Jessie Chen on 11/5/2021.
//

import Foundation
import Alamofire

class AssignmentNetworkManager{
    
    static let host = "http://beontimeapp.herokuapp.com/"
    
    static func getAssignments(completion: @escaping([Assignments]) -> Void){
        let endpoint = "\(host)"
        AF.request(endpoint, method: .get).validate().responseData { response in
            switch response.result{
            case .success(let data):
                let jsonDecoder = JSONDecoder()
                if let assignmentsResponse = try? jsonDecoder.decode([Assignments].self, from: data){
                    completion(assignmentsResponse)
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
        
    }
    
    static func createAssignment(title: String, course: String, duedate:String, priority: String, type: String, completion: @escaping(Assignments) -> Void){
        let endpoint = "\(host)/api/courses/2/assignments/"
        let parameters : [String:Any] = [
            "title": title,
            "due_date": duedate,
            "discription": course,
            "priority": priority,
            "type": type
        ]
        AF.request(endpoint, method: .post, parameters: parameters, encoding: JSONEncoding.default).validate().responseData { response in
            switch response.result{
            case .success(let data):
                let jsonDecoder = JSONDecoder()
                
                if let oneAssignmentResponse = try? jsonDecoder.decode(Assignments.self, from: data){
                    completion(oneAssignmentResponse)
                }
            case.failure(let error):
                print(error.localizedDescription)
            }
        }
            
            }
}
