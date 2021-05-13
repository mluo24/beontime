//
//  AssignmentCollectionViewCell.swift
//  HackChallenge
//
//  Created by Jessie Chen on 6/5/2021.
//

import UIKit

class AssignmentCollectionViewCell: UICollectionViewCell {
    
    var nameTitle = UILabel()
    var dateTitle = UILabel()
    var typeTitle = UILabel()
    var priorityTitle = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupViews()
        setupConstraints()
        
    }
    
    func setupViews(){
        nameTitle.translatesAutoresizingMaskIntoConstraints = false
        nameTitle.font = UIFont.systemFont(ofSize: 13)
        nameTitle.text = "Title"
        nameTitle.textColor = .black
        contentView.addSubview(nameTitle)
        
        dateTitle.translatesAutoresizingMaskIntoConstraints = false
        dateTitle.font = UIFont.systemFont(ofSize: 9)
        dateTitle.text = "Date"
        dateTitle.textColor = .black
        contentView.addSubview(dateTitle)
        
        typeTitle.translatesAutoresizingMaskIntoConstraints = false
        typeTitle.font = UIFont.systemFont(ofSize: 9)
        typeTitle.text = "Type"
        typeTitle.textColor = .black
        contentView.addSubview(typeTitle)
        
        priorityTitle.translatesAutoresizingMaskIntoConstraints = false
        priorityTitle.font = UIFont.systemFont(ofSize: 9)
        priorityTitle.text = "Priorty"
        priorityTitle.textColor = .black
        contentView.addSubview(priorityTitle)
       
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            nameTitle.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 11),
            nameTitle.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 18)
        ])
        
        
        NSLayoutConstraint.activate([
            dateTitle.topAnchor.constraint(equalTo: nameTitle.bottomAnchor),
            dateTitle.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 18)
        ])
        
        NSLayoutConstraint.activate([
            typeTitle.topAnchor.constraint(equalTo: dateTitle.bottomAnchor),
            typeTitle.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 18)
        ])
        
        NSLayoutConstraint.activate([
            priorityTitle.topAnchor.constraint(equalTo: typeTitle.bottomAnchor),
            priorityTitle.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 18)
        ])
    }
    
    func configure (for assignment: Assignment){
        nameTitle.text = assignment.title
        dateTitle.text = assignment.dueDate
        typeTitle.text = assignment.type
        priorityTitle.text = assignment.priority
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
}
