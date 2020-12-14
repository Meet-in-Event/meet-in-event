//
//  ProfilePageEdit.swift
//  ChatApp
//
//  Created by Charlie Brush on 12/8/20.
//

import UIKit





class ProfilePageEdit: UIViewController {
    var profileImage: UIImageView!
    var usernameField: UITextField!
    var displaynameField: UITextField!
    var passwordField: UITextField!

    var save: UIBarButtonItem!
    
    weak var delegate: Profile?

    var user: User!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = backColor
        title = "Edit Profile"
        
        user = delegate?.getUser()

                
        setupViews()
        setupConstraints()
    }
    
    
    func setupViews() {
        profileImage = UIImageView()
        profileImage.translatesAutoresizingMaskIntoConstraints = false
        profileImage.contentMode = .scaleAspectFit
        profileImage.image = UIImage(named: "blankprofile")
        view.addSubview(profileImage)

        
        
        usernameField = UITextField()
        usernameField.translatesAutoresizingMaskIntoConstraints = false
        usernameField.backgroundColor = textFieldColor
        usernameField.layer.borderWidth = 1
        usernameField.layer.cornerRadius = 10
        usernameField.layer.borderColor = UIColor.black.cgColor
        usernameField.textAlignment = .center
        usernameField.textColor = .black
        usernameField.attributedPlaceholder = NSAttributedString(string:user.netid, attributes: [NSAttributedString.Key.foregroundColor: UIColor.black])
        view.addSubview(usernameField)
        
        
        displaynameField = UITextField()
        displaynameField.translatesAutoresizingMaskIntoConstraints = false
        displaynameField.backgroundColor = textFieldColor
        displaynameField.layer.borderWidth = 1
        displaynameField.layer.cornerRadius = 10
        displaynameField.layer.borderColor = UIColor.black.cgColor
        displaynameField.textAlignment = .center
        displaynameField.textColor = .black
        displaynameField.attributedPlaceholder = NSAttributedString(string:user.name, attributes: [NSAttributedString.Key.foregroundColor: UIColor.black])
        view.addSubview(displaynameField)

        
        passwordField = UITextField()
        passwordField.translatesAutoresizingMaskIntoConstraints = false
        passwordField.backgroundColor = textFieldColor
        passwordField.layer.borderWidth = 1
        passwordField.layer.cornerRadius = 10
        passwordField.layer.borderColor = UIColor.black.cgColor
        passwordField.textAlignment = .center
        passwordField.textColor = .black
        passwordField.attributedPlaceholder = NSAttributedString(string:user.password, attributes: [NSAttributedString.Key.foregroundColor: UIColor.black])
        view.addSubview(passwordField)
        
        
        save = UIBarButtonItem()
        save.title = "Save"
        save.style = .plain
      //  save.tintColor = .cyan
        save.target = self
        save.action = #selector(saveTapped)
        navigationItem.rightBarButtonItem = save
        
    }
    
    
    func setupConstraints() {
        let offset: CGFloat = 25
        profileImage.snp.makeConstraints{ make in
            make.height.width.equalTo(360)
            make.centerX.equalTo(view.snp.centerX)
            make.top.equalTo(view.safeAreaLayoutGuide).offset(10)
        }

        
        usernameField.snp.makeConstraints{ make in
            make.top.equalTo(profileImage.snp.bottom).offset(offset)
            make.centerX.equalTo(view.snp.centerX)
            make.width.equalTo(200)
            make.height.equalTo(30)

        }

        displaynameField.snp.makeConstraints{ make in
            make.top.equalTo(usernameField.snp.bottom).offset(offset)
            make.centerX.equalTo(view.snp.centerX)
            make.width.equalTo(200)
            make.height.equalTo(30)
        }

        passwordField.snp.makeConstraints{ make in
            make.top.equalTo(displaynameField.snp.bottom).offset(offset)
            make.centerX.equalTo(view.snp.centerX)
            make.width.equalTo(200)
            make.height.equalTo(30)
        }
        
    }
    
    
    @objc func saveTapped() {
        save.tintColor = .magenta
        if usernameField.text=="" {
            usernameField.text = usernameField.placeholder
        }
        if displaynameField.text=="" {
            displaynameField.text = displaynameField.placeholder
        }
        if passwordField.text=="" {
            passwordField.text = passwordField.placeholder
        }
        
        usernameField.placeholder = usernameField.text
        displaynameField.placeholder = displaynameField.text
        passwordField.placeholder = passwordField.text
        delegate?.setUser(i: User(netid: usernameField.text!, name: displaynameField.text!, password: passwordField.text!))

        
        navigationController?.popViewController(animated: true)
        }
    
    
    
    
    
    
    
}

