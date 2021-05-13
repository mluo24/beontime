//
//  FilterCollectionViewCell.swift
//  HackChallenge
//
//  Created by Jessie Chen on 11/5/2021.
//

import UIKit

class FilterCollectionViewCell: UICollectionViewCell {
   
    var label = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = ""
        label.textColor = UIColor(red: 111/255, green: 177/255, blue: 238/255, alpha: 1)
        addSubview(label)
        
        setupConstraints()
    }
    
    func setupConstraints(){
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            label.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            label.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureFilter(for filter: Filter){
        label.text = filter.filterLabel
        
    }
}
