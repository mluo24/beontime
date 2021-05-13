//
//  HeaderView.swift
//  HackChallenge
//
//  Created by Jessie Chen on 11/5/2021.
//

import UIKit

class HeaderView: UICollectionReusableView {
    
    var label = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = ""
        label.textColor = .black
        addSubview(label)
    }
    
    func setupConstraint(){
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            label.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            label.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }
    
    func setTitle(title: String){
        label.text = title
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
