//
//  editPushViewController.swift
//  HackChallenge
//
//  Created by Jessie Chen on 6/5/2021.
//

import UIKit

class editPushViewController: UIViewController{
    
    var delegate: AssignmentDelegate?
    
    let createButton = UIButton()
    
    var nameInput = UITextField()
    var courseInput = UITextField()
    var typeInput = UIButton()
    var pickType = UIPickerView()
//    var duedateInput = UIButton()
    var dueDate = UITextField()
    let pickDueDate = UIDatePicker()
    var priorityInput = UIButton()
    var pickPriority = UIPickerView()
    var type = String()
    var prioity = String()
    
    let nameTitle = UILabel()
    let courseTitle = UILabel()
    let typeTitle = UILabel()
    let priorityTitle = UILabel()
    let dueDateTitle = UILabel()
    
    let typeList = ["Assignment","Project","Quiz","Exam"]
    let priorityList = ["High Priority", "Medium Priority","Low Priority"]
        
    var titleInit: String!
    var courseInit: String!
    var dueDateInit: String!
    var typeInit: String!
    var priorityInit: String!
    
    var assignmentsData: [Assignments] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        
        let indivClassColor = UIColor(red: 152/255, green: 194/255, blue: 203/255, alpha: 1)
        navigationController?.navigationBar.barTintColor = indivClassColor
        
        view.backgroundColor = .white
        title = "Add Assignment"
        
        pickType.dataSource = self
        pickType.delegate = self
        pickPriority.dataSource = self
        pickPriority.delegate = self
        
        pickType.tag = 1
        pickPriority.tag = 2
        
        setupViews()
        setupConstriants()
        createPickDate()
    }

    
    func createPickDate(){

        dueDate.inputView = pickDueDate
        dueDate.inputAccessoryView = createToolBar()
        pickDueDate.preferredDatePickerStyle = .wheels
        pickDueDate.datePickerMode = .dateAndTime
        
    
    }
    
    func createToolBar() -> UIToolbar{
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(donePressed))
        toolbar.setItems([doneButton], animated: false)
        toolbar.isUserInteractionEnabled = true
        
        return toolbar
    }
    
    func setupViews(){
        
        nameTitle.translatesAutoresizingMaskIntoConstraints = false
        nameTitle.text = "Name (e.g. A1)"
        nameTitle.textColor = .black
        nameTitle.font = UIFont.systemFont(ofSize: 9)
        view.addSubview(nameTitle)
        
        courseTitle.translatesAutoresizingMaskIntoConstraints = false
        courseTitle.text = "Class Name"
        courseTitle.textColor = .black
        courseTitle.font = UIFont.systemFont(ofSize: 9)
        view.addSubview(courseTitle)
        
        typeTitle.translatesAutoresizingMaskIntoConstraints = false
        typeTitle.text = "Type"
        typeTitle.textColor = .black
        typeTitle.font = UIFont.systemFont(ofSize: 9)
        view.addSubview(typeTitle)
        
        priorityTitle.translatesAutoresizingMaskIntoConstraints = false
        priorityTitle.text = "Priority"
        priorityTitle.textColor = .black
        priorityTitle.font = UIFont.systemFont(ofSize: 9)
        view.addSubview(priorityTitle)
        
        dueDateTitle.translatesAutoresizingMaskIntoConstraints = false
        dueDateTitle.text = "Due Date"
        dueDateTitle.textColor = .black
        dueDateTitle.font = UIFont.systemFont(ofSize: 9)
        view.addSubview(dueDateTitle)
        
        nameInput.translatesAutoresizingMaskIntoConstraints = false
        nameInput.backgroundColor = .white
        view.addSubview(nameInput)
        
        courseInput.translatesAutoresizingMaskIntoConstraints = false
        courseInput.backgroundColor = .white
        view.addSubview(courseInput)
        
        pickType.translatesAutoresizingMaskIntoConstraints = false
        pickType.isHidden = true
        view.addSubview(pickType)
        
        typeInput.translatesAutoresizingMaskIntoConstraints = false
        typeInput.addTarget(self, action: #selector(showType), for: .touchUpInside)
        typeInput.backgroundColor = .white
        typeInput.setTitleColor( .gray, for: .normal)
        typeInput.setTitle("Assignment (default)", for: .normal)
        view.addSubview(typeInput)
        
        pickPriority.translatesAutoresizingMaskIntoConstraints = false
        pickPriority.isHidden = true
        view.addSubview(pickPriority)
        
        priorityInput.translatesAutoresizingMaskIntoConstraints = false
        priorityInput.addTarget(self, action: #selector(showPriority), for: .touchUpInside)
        priorityInput.backgroundColor = .white
        priorityInput.setTitleColor( .gray, for: .normal)
        priorityInput.setTitle("Medium Priority (default)", for: .normal)
        view.addSubview(priorityInput)
        
//        pickDueDate.translatesAutoresizingMaskIntoConstraints = false
//        view.addSubview(pickDueDate)

        dueDate.translatesAutoresizingMaskIntoConstraints = false
        dueDate.placeholder = "select the due date"
        dueDate.backgroundColor = .clear
        view.addSubview(dueDate)

        createButton.translatesAutoresizingMaskIntoConstraints = false
        createButton.layer.cornerRadius = 10
        createButton.backgroundColor = UIColor(red: 152/255, green: 194/255, blue: 203/255, alpha: 1)
        createButton.addTarget(self, action: #selector(createNewAssignment), for: .touchUpInside)
        createButton.setTitle("Create Assignment", for: .normal)
        view.addSubview(createButton)
        
    }
    
    
    
    func setupConstriants(){
        
        NSLayoutConstraint.activate([
            nameTitle.topAnchor.constraint(equalTo: view.topAnchor, constant: 101),
            nameTitle.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
        ])
        
        NSLayoutConstraint.activate([
            courseTitle.topAnchor.constraint(equalTo: nameTitle.bottomAnchor, constant: 36),
            courseTitle.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
        ])
        
        NSLayoutConstraint.activate([
            typeTitle.bottomAnchor.constraint(equalTo: typeInput.topAnchor, constant: -9),
            typeTitle.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
        ])
        
        NSLayoutConstraint.activate([
            priorityTitle.bottomAnchor.constraint(equalTo: priorityInput.topAnchor, constant: -9),
            priorityTitle.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
        ])
        
        NSLayoutConstraint.activate([
            dueDateTitle.bottomAnchor.constraint(equalTo: dueDate.topAnchor, constant: -9),
            dueDateTitle.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
        ])
        
        NSLayoutConstraint.activate([
            nameInput.topAnchor.constraint(equalTo: view.topAnchor, constant: 116),
            nameInput.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 9),
            nameInput.widthAnchor.constraint(equalToConstant: 334),
            nameInput.heightAnchor.constraint(equalToConstant: 20)
        ])
        
        NSLayoutConstraint.activate([
            courseInput.topAnchor.constraint(equalTo: nameInput.bottomAnchor, constant: 30),
            courseInput.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 9),
            courseInput.widthAnchor.constraint(equalToConstant: 334),
            courseInput.heightAnchor.constraint(equalToConstant: 20)
        ])
        
        NSLayoutConstraint.activate([
            pickType.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            pickType.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        
        NSLayoutConstraint.activate([
            typeInput.topAnchor.constraint(equalTo: courseInput.bottomAnchor, constant: 30),
            typeInput.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 9)
        ])
        
        NSLayoutConstraint.activate([
            pickPriority.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            pickPriority.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        
        NSLayoutConstraint.activate([
            priorityInput.topAnchor.constraint(equalTo: typeInput.bottomAnchor, constant: 30),
            priorityInput.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 9)
        ])
        
        NSLayoutConstraint.activate([
            dueDate.topAnchor.constraint(equalTo: priorityInput.bottomAnchor, constant: 30),
            dueDate.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 9)
        ])

//        NSLayoutConstraint.activate([
//            pickDueDate.topAnchor.constraint(equalTo: dueDate.topAnchor),
//            pickDueDate.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 9)
//        ])
        
        NSLayoutConstraint.activate([
            createButton.topAnchor.constraint(equalTo: dueDate.bottomAnchor, constant: 50),
            createButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            createButton.widthAnchor.constraint(equalToConstant: 356),
            createButton.heightAnchor.constraint(equalToConstant: 38)
        ])
    }
    
    @objc func showType(){
        if pickType.isHidden{
            pickType.isHidden = false
        }
    }
    
    @objc func showPriority(){
        if pickPriority.isHidden{
            pickPriority.isHidden = false
        }
    }
    
    
    
    @objc func donePressed(){
        self.view.endEditing(true)
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        dueDate.text = formatter.string(from: pickDueDate.date)
       

    }

}

extension editPushViewController: UIPickerViewDataSource{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch pickerView.tag{
        case 1:
            return typeList.count
        case 2:
            return priorityList.count
        default:
            return 1
            
        }
    }
}

extension editPushViewController: UIPickerViewDelegate{
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String?{
//        return typeList[row]
        switch pickerView.tag{
        case 1:
            return typeList[row]
        case 2:
            return priorityList[row]
        default:
            return "data not found."
            
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch pickerView.tag{
        case 1:
            typeInput.setTitle(typeList[row], for: .normal)
            pickType.isHidden = true
            type = typeList[row]
        case 2:
            priorityInput.setTitle(priorityList[row], for: .normal)
            pickPriority.isHidden = true
            prioity = priorityList[row]
        default:
            return
            
        }
//        typeInput.setTitle(typeList[row], for: .normal)
//        pickType.isHidden = true
    }
    
    @objc func createNewAssignment() {
        delegate?.createNewAssignment(newTitle: nameInput.text, newCourse: courseInput.text, newDueDate: dueDate.text, newType: type, newPriority: prioity)
        navigationController?.popViewController(animated: true)
        AssignmentNetworkManager.createAssignment(title: nameInput.text ?? "", course: courseInput.text ?? "", duedate: dueDate.text ?? "", priority: prioity , type: type ) { assignments in
            self.assignmentsData.append(assignments)
        }

    }
    
}

