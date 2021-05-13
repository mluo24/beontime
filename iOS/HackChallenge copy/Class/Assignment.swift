//
//  Assignment.swift
//  HackChallenge
//
//  Created by Jessie Chen on 6/5/2021.
//

import UIKit

class Assignment{
    var title: String
    var course: String
    var dueDate: String
    var priority: String
    var type: String
    
    init(title: String, course: String, dueDate: String, priority: String, type: String){
        self.title = title
        self.course = course
        self.dueDate = dueDate
        self.priority = priority
        self.type = type
    }
}
