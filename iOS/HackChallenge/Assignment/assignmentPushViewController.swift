//
//  assignmentPushViewController.swift
//  HackChallenge
//
//  Created by Jessie Chen on 4/5/2021.
//

import UIKit

class assignmentPushViewController: UIViewController {
    
    var collectionView: UICollectionView!
    
    var assignment:[[Assignment]] = []
    var sections: [String] = []
    
    let assignmentCellReuseIdentifier = "assignmentCellReuseIdentifier"
    let headCellReuseIdentifier = "headCellReuseIdentifier"
    
    let cellPadding: CGFloat = 8
    let sectionPadding: CGFloat = 4
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let assignmentColor = UIColor(red: 152/255, green: 194/255, blue: 203/255, alpha: 1)
        navigationController?.navigationBar.barTintColor = assignmentColor
        navigationController?.navigationBar.tintColor = .white

        
        view.backgroundColor = .white
        title = "My Assignments"
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = cellPadding
        layout.sectionInset = UIEdgeInsets(top: sectionPadding, left: 0, bottom: sectionPadding, right: 0)
        
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .clear
        
        collectionView.register(AssignmentCollectionViewCell.self, forCellWithReuseIdentifier: assignmentCellReuseIdentifier)
        collectionView.register(HeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headCellReuseIdentifier)
        
        collectionView.dataSource = self
        collectionView.delegate = self
        
        view.addSubview(collectionView)
        setupConstraints()
        createDummy()
    }
    
    
    func createDummy(){
        
        sections = ["assignment","quiz","exam"]
        
        assignment = [[Assignment(title: "PSET 1", course:"Phys", dueDate: "00:00:00", priority:"medium", type: "assignment")],
        [Assignment(title: "PSET 2", course:"Phys", dueDate: "00:00:00", priority:"medium", type: "assignment")],
        [Assignment(title: "PSET 1", course:"Phys", dueDate: "00:00:00", priority:"high", type: "quiz")]]
        
//        let assignAssignment = [Assignment]()
//        let assignQuiz = [Assignment]()
//        let assignExam = [Assignment]()
//        assignment = [assignAssignment,assignQuiz,assignExam]
    }
    
    func setupConstraints() {
        let collectionViewPadding: CGFloat = 12
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: collectionViewPadding),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: collectionViewPadding),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -collectionViewPadding),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -collectionViewPadding)
        ])
    }
}


extension assignmentPushViewController: UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return assignment[section].count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: assignmentCellReuseIdentifier, for: indexPath) as! AssignmentCollectionViewCell
    
        cell.configure(for: assignment[indexPath.section][indexPath.item])
        return cell

    }

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return sections.count
    }

    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headCellReuseIdentifier, for: indexPath) as! HeaderView
        header.setTitle(title: sections[indexPath.section])
        return header
        }
    }

extension assignmentPushViewController: UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 341, height: 80)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: 341, height: 24)
    }
}
