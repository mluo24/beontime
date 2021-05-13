//
//  indivClassPushViewController.swift
//  HackChallenge
//
//  Created by Jessie Chen on 6/5/2021.
//

import UIKit

protocol AssignmentDelegate {

    func createNewAssignment(newTitle: String?, newCourse: String?, newDueDate: String?, newType: String?, newPriority: String?)

}

class indivClassPushViewController: UIViewController{
    
    let indivClassTableView = UITableView()
    let indivClassReuseIdentifier = "indivClassReuseIdentifier"
//    var assignmentList = [String]()
    var assignmentList = [Assignment]()
    
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let indivClassColor = UIColor(red: 152/255, green: 194/255, blue: 203/255, alpha: 1)
        navigationController?.navigationBar.barTintColor = indivClassColor
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(createAssignment))
        view.backgroundColor = .white
//        protocol for title name
        title = "My Assignments"
        
//        let random = [Assignment]()
        self.assignmentList = UserDefaults.standard.object(forKey: "assignmentList") as? [Assignment] ?? [Assignment]()
 
        
        
        setupViews()
        didViewLayoutSubview()
        
    }
    
    func didViewLayoutSubview(){
        indivClassTableView.frame = view.bounds
    }
    
    func setupViews(){
        indivClassTableView.translatesAutoresizingMaskIntoConstraints = false
        indivClassTableView.register(AssignmentTableViewCell.self, forCellReuseIdentifier: indivClassReuseIdentifier)
        indivClassTableView.delegate = self
        indivClassTableView.dataSource = self
        indivClassTableView.backgroundColor = .clear
        view.addSubview(indivClassTableView)
    }
    
    @ objc func createAssignment() {
  
        let classPushViewController = editPushViewController()
        classPushViewController.delegate = self
        navigationController?.pushViewController(classPushViewController, animated: true)
        }
    
}

extension indivClassPushViewController: UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    

//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let selectedCell = dataSource.item
//
//    }

}


extension indivClassPushViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return assignmentList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: indivClassReuseIdentifier, for: indexPath) as! AssignmentTableViewCell
        let assignmentObject = assignmentList[indexPath.row]
        cell.configure(with: assignmentObject)
//        cell.textLabel?.text = assignmentList[indexPath.row].title

        
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView.cellForRow(at: indexPath)?.accessoryType == UITableViewCell.AccessoryType.checkmark{
            tableView.cellForRow(at: indexPath)?.accessoryType = UITableViewCell.AccessoryType.none
        }
        else{
            tableView.cellForRow(at: indexPath)?.accessoryType = UITableViewCell.AccessoryType.checkmark
        }
    }
    
}


extension indivClassPushViewController: AssignmentDelegate{
   
    
    
    
    func createNewAssignment(newTitle: String?, newCourse: String?, newDueDate: String?, newType: String?, newPriority: String?) {
        DispatchQueue.main.async {
        let object = Assignment(title: "",course: "",dueDate: "",priority: "",type: "")

        if let unwrappedTitle = newTitle {
            object.title = unwrappedTitle
        }
        if let unwrappedCourse = newCourse {
            object.course = unwrappedCourse
        }
        if let unwrappedDueDate = newDueDate {
            object.dueDate = unwrappedDueDate
        }
        if let unwrappedType = newType {
            object.type = unwrappedType
        }
        if let unwrappedPriority = newPriority {
            object.priority = unwrappedPriority
        }

            self.assignmentList.append(object)
            self.indivClassTableView.reloadData()
    }
    }
    
    
}
 
