//
//  ClassTableViewCell.swift
//  HackChallenge
//
//  Created by Jessie Chen on 5/5/2021.
//

import UIKit

class ClassTableViewCell: UITableViewCell {

    let courseTitle = UILabel()
    let courseDescription = UILabel()
    let courseTime = UILabel()
    let assignmentNum = UILabel()
    
    var cellIndex: Int = 0
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

    }

    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
