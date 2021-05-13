//
//  Courses.swift
//  HackChallenge
//
//  Created by Jessie Chen on 10/5/2021.
//

struct Course: Codable{
//    let id: Int
    let subject: String
    let code: String
    let name: String
    let days_on: String
    let time: String
//    let subject = String
}

struct CourseResponse: Codable {
    let success: Bool
    let data: Course
}

struct CoursesResponse: Codable {
//    let success = Bool
    let data: [Course]
}
