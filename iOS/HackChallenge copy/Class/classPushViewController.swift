//
//  classPushViewController.swift
//  HackChallenge
//
//  Created by Jessie Chen on 5/5/2021.
//
import UIKit

class classPushViewController: UIViewController {
    
    let classTableView = UITableView()
    let classReuseIdentifier = "classReuseIdentifier"
    
//    var courseList = [String]()
    var courseList = [Course]()
    var shownCourseData: [Course] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let classColor = UIColor(red: 152/255, green: 194/255, blue: 203/255, alpha: 1)
        navigationController?.navigationBar.barTintColor = classColor
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(tapAdd))
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
        navigationItem.rightBarButtonItem?.tintColor = .white
        navigationController?.navigationBar.tintColor = .white
        

//        self.courseList = UserDefaults.standard.stringArray(forKey: "courseList") ?? []
        view.backgroundColor = .white
        title = "My Classes"
        
        CourseNetworkManager.getCourses { coursesList in
            self.courseList = coursesList
            self.shownCourseData = self.courseList
            self.classTableView.reloadData()
            
        }
        
        setupViews()
        didViewLayoutSubview()
        
    }
    
    func didViewLayoutSubview(){
        classTableView.frame = view.bounds
    }
    
    
    func setupViews(){
        classTableView.translatesAutoresizingMaskIntoConstraints = false
        classTableView.register(ClassTableViewCell.self, forCellReuseIdentifier: classReuseIdentifier)
        classTableView.delegate = self
        classTableView.dataSource = self
        classTableView.backgroundColor = .white
        view.addSubview(classTableView)
    }
    
    @objc func tapAdd(){
        let alert = UIAlertController(title: "Add Course", message: "Add another course", preferredStyle: .alert)
        alert.addTextField { field in
            field.placeholder = "Enter course..."
        }
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Done", style: .default, handler: { action in
//            if let field = alert.textFields?.first{
//                if let text = field.text, !text.isEmpty{
//                    DispatchQueue.main.async {
//                        var list = UserDefaults.standard.stringArray(forKey: "courseList") ?? []
//                        list.append(text)
//                        UserDefaults.standard.setValue(list, forKey: "courseList")
//                        self.courseList.append(text)
//                        self.classTableView.reloadData()
//                    }
//                }
//            }
//            if let field = alert.textFields?.first{
//                if let id = field.text{
////                    let intergerID = Int(id) {
//                    CourseNetworkManager.getCourse(id: Int(id)!) {post in
//                            self.courseList.append(post)
//                            self.classTableView.reloadData()
////                        }
//                    }
//                }
//
//            }
            if let field = alert.textFields?.first{
                if let name = field.text{
                    CourseNetworkManager.addCourse(subject: "", code: "", name: name, days_on: "", time: "09:00PM"){
                        course in
                        self.courseList.append(course)
                        self.shownCourseData = self.courseList
                        self.classTableView.reloadData()
                    }
                }
            }
        }))
        present(alert, animated: true)
        classTableView.reloadData()
    }
}

extension classPushViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        _ = courseList[indexPath.row]
        let pushViewController = indivClassPushViewController()
//        pushViewController.delegate = self
        navigationController?.pushViewController(pushViewController, animated: true)
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete{
            DispatchQueue.main.async {
                var list = UserDefaults.standard.stringArray(forKey: "courseList") ?? []
                list.remove(at: indexPath.row)
                UserDefaults.standard.setValue(list, forKey: "courseList")
                self.courseList.remove(at: indexPath.row)
                self.classTableView.reloadData()
        }

        }
    }
}

//
//}

extension classPushViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return courseList.count
    }


    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: classReuseIdentifier, for: indexPath)
        cell.textLabel?.text = courseList[indexPath.row].name
        return cell
    }
}




