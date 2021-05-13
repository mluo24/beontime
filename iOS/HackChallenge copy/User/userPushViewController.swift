//
//  userPushViewController.swift
//  HackChallenge
//
//  Created by Jessie Chen on 5/5/2021.
//

import UIKit

class userPushViewController: UIViewController {
    
    var emailInput = UITextField()
    var passwordInput = UITextField()
    var nameInput = UITextField()
    var netidInput = UITextField()
    
    let emailTitle = UILabel()
    let passwordTitle = UILabel()
    let nameTitle = UILabel()
    let netidTitle = UILabel()
    
    let loginButton = UIButton()
    let registerButton = UIButton()
    
    let profileButton = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let userColor = UIColor(red: 152/255, green: 194/255, blue: 203/255, alpha: 1)
        navigationController?.navigationBar.barTintColor = userColor

        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
        navigationItem.rightBarButtonItem?.tintColor = .white
        navigationController?.navigationBar.tintColor = .white

        
        view.backgroundColor = .white
        title = "User Information"
    
        setupViews()
        setupConstraints()
    }
    
    func setupViews(){
        emailInput.translatesAutoresizingMaskIntoConstraints = false
        emailInput.placeholder = "Enter your email..."
        emailInput.autocapitalizationType = .none
        emailInput.autocorrectionType = .no
        view.addSubview(emailInput)
        
        emailTitle.translatesAutoresizingMaskIntoConstraints = false
        emailTitle.text = "Email:"
        emailTitle.font = UIFont.systemFont(ofSize: 14)
//        emailTitle.textColor = UIColor(red: 80/255, green: 80/255, blue: 80/255, alpha: 1)
        view.addSubview(emailTitle)
        
        passwordInput.translatesAutoresizingMaskIntoConstraints = false
        passwordInput.placeholder = "Enter your password..."
        passwordInput.autocapitalizationType = .none
        passwordInput.autocorrectionType = .no
        view.addSubview(passwordInput)
        
        passwordTitle.translatesAutoresizingMaskIntoConstraints = false
        passwordTitle.text = "Password:"
        passwordTitle.font = UIFont.systemFont(ofSize: 14)
        view.addSubview(passwordTitle)
        
        nameInput.translatesAutoresizingMaskIntoConstraints = false
        nameInput.placeholder = "Enter your name..."
        nameInput.autocapitalizationType = .none
        nameInput.autocorrectionType = .no
        view.addSubview(nameInput)
        
        nameTitle.translatesAutoresizingMaskIntoConstraints = false
        nameTitle.text = "Name:"
        nameTitle.font = UIFont.systemFont(ofSize: 14)
        view.addSubview(nameTitle)
        
        netidInput.translatesAutoresizingMaskIntoConstraints = false
        netidInput.placeholder = "Enter your netID..."
        netidInput.autocapitalizationType = .none
        netidInput.autocorrectionType = .no
        view.addSubview(netidInput)
        
        netidTitle.translatesAutoresizingMaskIntoConstraints = false
        netidTitle.text = "Net ID:"
        netidTitle.font = UIFont.systemFont(ofSize: 14)
        view.addSubview(netidTitle)
        
        loginButton.translatesAutoresizingMaskIntoConstraints = false
        loginButton.setTitle("Log in", for: .normal)
        loginButton.layer.cornerRadius = 10
        loginButton.addTarget(self, action: #selector(login), for: .touchUpInside)
        loginButton.backgroundColor = UIColor(red: 152/255, green: 194/255, blue: 203/255, alpha: 1)
        view.addSubview(loginButton)
        
        registerButton.translatesAutoresizingMaskIntoConstraints = false
        registerButton.setTitle("Register", for: .normal)
        registerButton.layer.cornerRadius = 10
        registerButton.addTarget(self, action: #selector(register), for: .touchUpInside)
        registerButton.backgroundColor = UIColor(red: 152/255, green: 194/255, blue: 203/255, alpha: 1)
        view.addSubview(registerButton)
        
        profileButton.translatesAutoresizingMaskIntoConstraints = false
        profileButton.setImage(UIImage(named: "User"), for: .normal)
        view.addSubview(profileButton)
    }
    
    func setupConstraints(){
        NSLayoutConstraint.activate([
            emailInput.topAnchor.constraint(equalTo: view.topAnchor, constant: 300),
            emailInput.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emailInput.widthAnchor.constraint(equalToConstant: 300)
        ])
        
        NSLayoutConstraint.activate([
            emailTitle.topAnchor.constraint(equalTo: emailInput.topAnchor, constant: -25),
            emailTitle.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 38),
            emailTitle.widthAnchor.constraint(equalToConstant: 300)
        ])
        
        NSLayoutConstraint.activate([
            passwordInput.topAnchor.constraint(equalTo: emailInput.topAnchor, constant: 60),
            passwordInput.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            passwordInput.widthAnchor.constraint(equalToConstant: 300)
        ])
        
        NSLayoutConstraint.activate([
            passwordTitle.topAnchor.constraint(equalTo: passwordInput.topAnchor, constant: -25),
            passwordTitle.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 38),
            passwordTitle.widthAnchor.constraint(equalToConstant: 300)
        ])
        
        NSLayoutConstraint.activate([
            nameInput.topAnchor.constraint(equalTo: passwordInput.topAnchor, constant: 60),
            nameInput.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            nameInput.widthAnchor.constraint(equalToConstant: 300)
        ])
        
        NSLayoutConstraint.activate([
            nameTitle.topAnchor.constraint(equalTo: nameInput.topAnchor, constant: -25),
            nameTitle.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 38),
            nameTitle.widthAnchor.constraint(equalToConstant: 300)
        ])
        
        NSLayoutConstraint.activate([
            netidInput.topAnchor.constraint(equalTo: nameInput.topAnchor, constant: 60),
            netidInput.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            netidInput.widthAnchor.constraint(equalToConstant: 300)
        ])
        
        NSLayoutConstraint.activate([
            netidTitle.topAnchor.constraint(equalTo: netidInput.topAnchor, constant: -25),
            netidTitle.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 38),
            netidTitle.widthAnchor.constraint(equalToConstant: 300)
        ])
        
        NSLayoutConstraint.activate([
            loginButton.topAnchor.constraint(equalTo: netidInput.topAnchor, constant: 60),
            loginButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loginButton.widthAnchor.constraint(equalToConstant: 300),
            loginButton.heightAnchor.constraint(equalToConstant: 38)
        ])
        
        NSLayoutConstraint.activate([
            registerButton.topAnchor.constraint(equalTo: loginButton.topAnchor, constant: 60),
            registerButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            registerButton.widthAnchor.constraint(equalToConstant: 300),
            registerButton.heightAnchor.constraint(equalToConstant: 38)
        ])
        
        NSLayoutConstraint.activate([
            profileButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 106),
            profileButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
        ])
    }
    
    @objc func login(){
        let email = emailInput.text ?? ""
        let password = passwordInput.text ?? ""
        UserNetworkManager.checkUser(email: email, password: password){ session -> Void in
            sessionResponse.currentSession = session
                let profilePushView = classPushViewController()
                self.navigationController?.pushViewController(profilePushView, animated: true)
            
        }
    }
//    
    @objc func register(){
        let email = emailInput.text ?? ""
        let password = passwordInput.text ?? ""
        let name = nameInput.text ?? ""
        let netid = netidInput.text ?? ""
        UserNetworkManager.createUser(email: email, password: password, name: name, netid: netid){ user -> Void in}
    }
}
