//
//  Users.swift
//  HackChallenge
//
//  Created by Jessie Chen on 10/5/2021.
//

struct User: Codable{
    let email: String
    let password: String
    let name: String
    let netid: String
}


struct UserResponse: Codable {
//    let success = Bool
    let data: User
}

struct sessionResponse: Codable{
    let session_token: String
    let session_expiration: String
    let update_token: String
    
    static var currentSession: sessionResponse?
}

//static var currentSession: sessionResponse?
