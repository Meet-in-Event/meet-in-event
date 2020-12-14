//
//  LogIn.swift
//  ChatApp
//
//  Created by Charlie Brush on 12/9/20.
//

import UIKit
import SnapKit

class LogIn: UIViewController {
    var usernameLabel: UILabel!
    var usernameField: UITextField!
    var usernameError: UILabel!
    var passwordLabel: UILabel!
    var passwordField: UITextField!
    var passwordError: UILabel!
    var loginButton: UIButton!
    
    
    weak var delegate: Login?

    var user: User!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = backColor
        title = "Log In"
                
        setupViews()
        setupConstraints()
    }
    
    
    func setupViews() {
        usernameLabel = UILabel()
        usernameLabel.text = "Netid:"
        usernameLabel.font = UIFont.systemFont(ofSize: 25)
        usernameLabel.textColor = labelColor
        usernameLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(usernameLabel)

        usernameField = UITextField()
        usernameField.translatesAutoresizingMaskIntoConstraints = false
        usernameField.backgroundColor = .white
        usernameField.layer.borderWidth = 1
        usernameField.layer.cornerRadius = 10
        usernameField.layer.borderColor = UIColor.black.cgColor
        usernameField.textAlignment = .center
        usernameField.textColor = .black
        usernameField.attributedPlaceholder = NSAttributedString(string:"netid", attributes: [NSAttributedString.Key.foregroundColor: UIColor.black])
        view.addSubview(usernameField)
        
        passwordLabel = UILabel()
        passwordLabel.text = "Password:"
        passwordLabel.font = UIFont.systemFont(ofSize: 25)
        passwordLabel.textColor = labelColor
        passwordLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(passwordLabel)
        
        usernameError = UILabel()
        usernameError.font = UIFont.systemFont(ofSize: 15)
        usernameError.textColor = .red
        usernameError.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(usernameError)
        
        passwordField = UITextField()
        passwordField.translatesAutoresizingMaskIntoConstraints = false
        passwordField.backgroundColor = .white
        passwordField.layer.borderWidth = 1
        passwordField.layer.cornerRadius = 10
        passwordField.layer.borderColor = UIColor.black.cgColor
        passwordField.textAlignment = .center
        passwordField.textColor = .black
        passwordField.attributedPlaceholder = NSAttributedString(string:"password", attributes: [NSAttributedString.Key.foregroundColor: UIColor.black])
        view.addSubview(passwordField)
        
        loginButton = UIButton()
        loginButton.setTitle("Log In", for: .normal)
        loginButton.titleLabel?.adjustsFontSizeToFitWidth = true
        loginButton.setTitleColor(buttonLabelColor, for: .normal)
        loginButton.translatesAutoresizingMaskIntoConstraints = false
        loginButton.backgroundColor = buttonColor
        loginButton.layer.cornerRadius = 5
        loginButton.addTarget(self, action: #selector(loginTapped), for: .touchUpInside)
        view.addSubview(loginButton)
        
        passwordError = UILabel()
        passwordError.font = UIFont.systemFont(ofSize: 15)
        passwordError.textColor = .red
        passwordError.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(passwordError)
        
        
        
        
    }
    
    
    func setupConstraints() {
        let offset: CGFloat = 10
       
        usernameLabel.snp.makeConstraints{make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset(-100)
        }
        
        usernameField.snp.makeConstraints{ make in
            make.top.equalTo(usernameLabel.snp.bottom).offset(offset)
            make.centerX.equalToSuperview()
            make.width.equalTo(200)
            make.height.equalTo(30)
        }
        
        usernameError.snp.makeConstraints{make in
            make.top.equalTo(usernameField.snp.bottom).offset(offset)
            make.centerX.equalToSuperview()
        }
        
        passwordLabel.snp.makeConstraints{make in
            make.centerX.equalToSuperview()
            make.top.equalTo(usernameError.snp.bottom).offset(offset)
        }

        passwordField.snp.makeConstraints{ make in
            make.top.equalTo(passwordLabel.snp.bottom).offset(offset)
            make.centerX.equalToSuperview()
            make.width.equalTo(200)
            make.height.equalTo(30)
        }
        
        passwordError.snp.makeConstraints{make in
            make.top.equalTo(passwordField.snp.bottom).offset(offset)
            make.centerX.equalToSuperview()
        }
        
        loginButton.snp.makeConstraints{make in
            make.top.equalTo(passwordError.snp.bottom).offset(offset)
            make.centerX.equalToSuperview()
            make.width.equalTo(200)
            make.height.equalTo(30)
        }
        
    }
    
    
    @objc func loginTapped() {
        if usernameField.text=="" {
            usernameError.text="Invalid Netid"
        }
        else if passwordField.text=="" {
            passwordError.text="Invalid Password"
        }
        else {
            
            NetworkManager.getUser(netid: usernameField.text!) { user2 in
                if !(self.usernameField.text==user2.netid) {
                    self.usernameError.text="Invalid Netid"
                }
                else if !(self.usernameField.text==user2.netid) {
                    self.passwordError.text="Invalid Password"
                }
                else {
                    self.delegate?.createUser(i: User(netid: user2.netid, name: user2.name, password: self.usernameField.text!, socialAccount: user2.socialAccount, id: user2.id))
                }
            }
         //  delegate?.getUserFromUsername(i: usernameField.text!)
        
            navigationController?.popViewController(animated: true)
        }
    }
    
}
