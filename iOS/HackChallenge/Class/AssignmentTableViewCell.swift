//
//  AssignmentTableViewCell.swift
//  HackChallenge
//
//  Created by Jessie Chen on 6/5/2021.
//

import UIKit

class AssignmentTableViewCell: UITableViewCell {
    
    let assignmentTitle = UILabel()
    let courseTitle = UILabel()
    let dueDateTitle = UILabel()
    let priorityTitle = UILabel()
    
//    var cellIndex: Int = 0
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        setupViews()
        setupConstraints()
    }
    
    func setupViews(){
        assignmentTitle.translatesAutoresizingMaskIntoConstraints = false
        assignmentTitle.font = UIFont.systemFont(ofSize: 13)
        assignmentTitle.text = "assignmentTitle"
        contentView.addSubview(assignmentTitle)
        
        courseTitle.translatesAutoresizingMaskIntoConstraints = false
        courseTitle.font = UIFont.systemFont(ofSize: 9)
        courseTitle.text = "courseTitle"
        contentView.addSubview(courseTitle)
        
        dueDateTitle.translatesAutoresizingMaskIntoConstraints = false
        dueDateTitle.font = UIFont.systemFont(ofSize: 9)
        dueDateTitle.text = "dueDateTitle"
        contentView.addSubview(dueDateTitle)
        
        priorityTitle.translatesAutoresizingMaskIntoConstraints = false
        priorityTitle.font = UIFont.systemFont(ofSize: 9)
        priorityTitle.text = "priorityTitle"
        contentView.addSubview(priorityTitle)
        
    }
    
    func setupConstraints(){
        NSLayoutConstraint.activate([
            assignmentTitle.topAnchor.constraint(equalTo: contentView.topAnchor,constant: 10),
            assignmentTitle.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 18)
        ])
        
        NSLayoutConstraint.activate([
            courseTitle.topAnchor.constraint(equalTo: assignmentTitle.bottomAnchor,constant: 6),
            courseTitle.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 18)
        ])
        
        NSLayoutConstraint.activate([
            dueDateTitle.topAnchor.constraint(equalTo: courseTitle.bottomAnchor,constant: 6),
            dueDateTitle.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 18)
        ])
        
        NSLayoutConstraint.activate([
            priorityTitle.topAnchor.constraint(equalTo: dueDateTitle.bottomAnchor,constant: 6),
            priorityTitle.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 18)
        ])
        
    }

    func configure(with assignmentObject: Assignment){
        assignmentTitle.text = assignmentObject.title
        courseTitle.text = assignmentObject.course
        dueDateTitle.text = assignmentObject.dueDate
        priorityTitle.text = assignmentObject.priority
            
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    

}
