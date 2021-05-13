//
//  Assignments .swift
//  HackChallenge
//
//  Created by Jessie Chen on 11/5/2021.
//

struct Assignments: Codable{
    let title: String
    let course: String
    let duedate: String
    let priority: String
    let type: String
}

struct oneAssignmentResponse: Codable {
//    let success = Bool
    let data: Assignments
}

struct AssignmentsResponse: Codable {
//    let success = Bool
    let data: [Assignments]
}



