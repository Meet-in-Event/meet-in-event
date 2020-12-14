//
//  SignUp.swift
//  ChatApp
//
//  Created by Charlie Brush on 12/9/20.
//

import UIKit
import SnapKit

class SignUp: UIViewController {
    var usernameLabel: UILabel!
    var usernameField: UITextField!
    var usernameError: UILabel!
    var passwordLabel: UILabel!
    var passwordField: UITextField!
    var passwordError: UILabel!
    var displaynameLabel: UILabel!
    var displaynameField: UITextField!
    var displaynameError: UILabel!
    var socialLabel: UILabel!
    var socialField: UITextField!
    var socialError: UILabel!
    var signupButton: UIButton!
    
    weak var delegate: Login?

    var user: User!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = backColor
        title = "Sign Up"
                
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
        
        displaynameLabel = UILabel()
        displaynameLabel.text = "Name:"
        displaynameLabel.font = UIFont.systemFont(ofSize: 25)
        displaynameLabel.textColor = labelColor
        displaynameLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(displaynameLabel)

        displaynameField = UITextField()
        displaynameField.translatesAutoresizingMaskIntoConstraints = false
        displaynameField.backgroundColor = .white
        displaynameField.layer.borderWidth = 1
        displaynameField.layer.cornerRadius = 10
        displaynameField.layer.borderColor = UIColor.black.cgColor
        displaynameField.textAlignment = .center
        displaynameField.textColor = .black
        displaynameField.attributedPlaceholder = NSAttributedString(string:"name", attributes: [NSAttributedString.Key.foregroundColor: UIColor.black])
        view.addSubview(displaynameField)
        
        displaynameError = UILabel()
        displaynameError.font = UIFont.systemFont(ofSize: 15)
        displaynameError.textColor = .red
        displaynameError.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(displaynameError)
        
        socialLabel = UILabel()
        socialLabel.text = "Social:"
        socialLabel.font = UIFont.systemFont(ofSize: 25)
        socialLabel.textColor = labelColor
        socialLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(socialLabel)

        socialField = UITextField()
        socialField.translatesAutoresizingMaskIntoConstraints = false
        socialField.backgroundColor = .white
        socialField.layer.borderWidth = 1
        socialField.layer.cornerRadius = 10
        socialField.layer.borderColor = UIColor.black.cgColor
        socialField.textAlignment = .center
        socialField.textColor = .black
        socialField.attributedPlaceholder = NSAttributedString(string:"social", attributes: [NSAttributedString.Key.foregroundColor: UIColor.black])
        view.addSubview(socialField)
        
        socialError = UILabel()
        socialError.font = UIFont.systemFont(ofSize: 15)
        socialError.textColor = .red
        socialError.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(socialError)
        
        signupButton = UIButton()
        signupButton.setTitle("Sign Up", for: .normal)
        signupButton.titleLabel?.adjustsFontSizeToFitWidth = true
        signupButton.setTitleColor(buttonLabelColor, for: .normal)
        signupButton.translatesAutoresizingMaskIntoConstraints = false
        signupButton.backgroundColor = buttonColor
        signupButton.layer.cornerRadius = 5
        signupButton.addTarget(self, action: #selector(signupTapped), for: .touchUpInside)
        view.addSubview(signupButton)
        
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
            make.centerY.equalToSuperview().offset(-200)
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
        
        displaynameLabel.snp.makeConstraints{make in
            make.centerX.equalToSuperview()
            make.top.equalTo(passwordError.snp.bottom).offset(offset)
        }
        
        displaynameField.snp.makeConstraints{ make in
            make.top.equalTo(displaynameLabel.snp.bottom).offset(offset)
            make.centerX.equalToSuperview()
            make.width.equalTo(200)
            make.height.equalTo(30)
        }
        
        displaynameError.snp.makeConstraints{make in
            make.top.equalTo(displaynameField.snp.bottom).offset(offset)
            make.centerX.equalToSuperview()
        }
        
        socialLabel.snp.makeConstraints{make in
            make.centerX.equalToSuperview()
            make.top.equalTo(displaynameError.snp.bottom).offset(offset)
        }
        
        socialField.snp.makeConstraints{ make in
            make.top.equalTo(socialLabel.snp.bottom).offset(offset)
            make.centerX.equalToSuperview()
            make.width.equalTo(200)
            make.height.equalTo(30)
        }
        
        socialError.snp.makeConstraints{make in
            make.top.equalTo(socialField.snp.bottom).offset(offset)
            make.centerX.equalToSuperview()
        }
        
        signupButton.snp.makeConstraints{make in
            make.top.equalTo(socialError.snp.bottom).offset(offset)
            make.centerX.equalToSuperview()
            make.width.equalTo(200)
            make.height.equalTo(30)
        }
        
    }
    
    
    @objc func signupTapped() {
        if usernameField.text=="" {
            usernameError.text="Invalid Netid"
        }
        else if passwordField.text=="" {
            passwordError.text="Invalid Password"
        }
        else if displaynameField.text=="" {
            displaynameError.text="Invalid Name"
        }
        else if socialField.text=="" {
            socialError.text="Invalid Password"
        }
        else {
            self.user = User(netid: usernameField.text!, name: displaynameField.text!, password: passwordField.text!, socialAccount: socialField.text!)
            NetworkManager.createUser(u: self.user) { user2, u in
                self.user=u
                self.user.id=user2.id
                self.delegate?.createUser(i: self.user)
                }
            navigationController?.popViewController(animated: true)
        }
            
        
          
        
    }
    
}
