//
//  ViewController.swift
//  HackChallenge
//
//  Created by Jessie Chen on 4/5/2021.
//

import UIKit

class ViewController: UIViewController {

//    var delegate:ViewController?
    
    let classesButton = UIButton()
    let assignmentsButton = UIButton()
    let usersButton = UIButton()
    
    let classTitle = UILabel()
    let assignmentTitle = UILabel()
    let userTitle = UILabel()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        view.backgroundColor = .white
        title = "BeOnTime"
        
        let color = UIColor(red: 152/255, green: 194/255, blue: 203/255, alpha: 1)
        
        navigationController?.navigationBar.barTintColor = color
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
        
        assignmentsButton.translatesAutoresizingMaskIntoConstraints = false
        assignmentsButton.setImage(UIImage(named: "Assignment Button"), for: .normal)
        assignmentsButton.addTarget(self, action: #selector(assignmentPushViewControllerButtonPressed), for: .touchUpInside)
        view.addSubview(assignmentsButton)
        
        assignmentTitle.translatesAutoresizingMaskIntoConstraints = false
        assignmentTitle.text = "Assignments"
        assignmentTitle.font = UIFont.boldSystemFont(ofSize: 18)
        view.addSubview(assignmentTitle)
        
        classesButton.translatesAutoresizingMaskIntoConstraints = false
        classesButton.setImage(UIImage(named: "Courses Button"), for: .normal)
        classesButton.addTarget(self, action: #selector(classPushViewControllerButtonPressed), for: .touchUpInside)
        view.addSubview(classesButton)
        
        classTitle.translatesAutoresizingMaskIntoConstraints = false
        classTitle.text = "Classes"
        classTitle.font = UIFont.boldSystemFont(ofSize: 18)
        view.addSubview(classTitle)
        
        usersButton.translatesAutoresizingMaskIntoConstraints = false
        usersButton.setImage(UIImage(named: "User logo"), for: .normal)
        usersButton.addTarget(self, action: #selector(userPushViewControllerButtonPressed), for: .touchUpInside)
        view.addSubview(usersButton)
        
        userTitle.translatesAutoresizingMaskIntoConstraints = false
        userTitle.text = "Profile"
        userTitle.font = UIFont.boldSystemFont(ofSize: 18)
        view.addSubview(userTitle)
        
        setupViews()
    }
    
    func setupViews(){
        
        NSLayoutConstraint.activate([
            classesButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 67),
            classesButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
            
        ])
        
        NSLayoutConstraint.activate([
            classTitle.topAnchor.constraint(equalTo: classesButton.bottomAnchor, constant: 5),
            classTitle.centerXAnchor.constraint(equalTo: view.centerXAnchor)
            
        ])
        
        NSLayoutConstraint.activate([
            assignmentsButton.topAnchor.constraint(equalTo:view.topAnchor,constant: 327),
            assignmentsButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
            
        ])
        
        NSLayoutConstraint.activate([
            assignmentTitle.topAnchor.constraint(equalTo: assignmentsButton.bottomAnchor, constant: 5),
            assignmentTitle.centerXAnchor.constraint(equalTo: view.centerXAnchor)
            
        ])
        

        NSLayoutConstraint.activate([
            usersButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 500),
            usersButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)

            
        ])
        
        NSLayoutConstraint.activate([
            userTitle.topAnchor.constraint(equalTo: usersButton.bottomAnchor, constant: 5),
            userTitle.centerXAnchor.constraint(equalTo: view.centerXAnchor)
            
        ])
    }
    
    
    
    @objc func classPushViewControllerButtonPressed() {
        let classPushView = userPushViewController()
//            quizPushView.delegate=self
        navigationController?.pushViewController(classPushView, animated: true)
    }

    @objc func assignmentPushViewControllerButtonPressed() {
        let assignmentPushView = assignmentPushViewController()
//            assignmentPushView.delegate=self
        navigationController?.pushViewController(assignmentPushView, animated: true)
    }

    
    @objc func userPushViewControllerButtonPressed() {
        let userPushView = userPushViewController()
//            examPushView.delegate=self
        navigationController?.pushViewController(userPushView, animated: true)
    }
}

