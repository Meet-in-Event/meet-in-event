//
//  ProfilePage.swift
//  ChatApp
//
//  Created by Charlie Brush on 12/6/20.
//

import UIKit

class ProfilePage: UIViewController {
    weak var delegate: Profile?

    var user: User!
    
    var profileImage: UIImageView!
    var usernameLabel: UILabel!
    var displaynameLabel: UILabel!
    var password: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = backgroundColor
        
        user = delegate?.getUser()
        print(user.username)

                
        setupViews()
        setupConstraints()
    }
    
    
    func setupViews() {
        profileImage = UIImageView()
        profileImage.translatesAutoresizingMaskIntoConstraints = false
        profileImage.clipsToBounds = true
        profileImage.layer.masksToBounds = true
        profileImage.contentMode = .scaleAspectFill
        profileImage.image = UIImage(named: user.image)
        view.addSubview(profileImage)

        
        usernameLabel = UILabel()
        usernameLabel.text = "Username: \(user.username)"
        usernameLabel.font = UIFont.systemFont(ofSize: 25)
        usernameLabel.textColor = .white
        usernameLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(usernameLabel)
        
        
        displaynameLabel = UILabel()
        displaynameLabel.text = "Display Name: \(user.displayname)"
        displaynameLabel.font = UIFont.systemFont(ofSize: 25)
        displaynameLabel.textColor = .white
        displaynameLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(displaynameLabel)

        
        password = UILabel()
        password.text = "Password: \(user.password)"
        password.font = UIFont.systemFont(ofSize: 25)
        password.textColor = .white
        password.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(password)
        
    }
    
    
    func setupConstraints() {
        let offset: CGFloat = 25
        
        profileImage.snp.makeConstraints{ make in
            make.height.width.equalTo(360)
            make.centerX.equalTo(view.snp.centerX)
            make.top.equalTo(view.safeAreaLayoutGuide).offset(55)
        }
        
        
        usernameLabel.snp.makeConstraints{ make in
            make.top.equalTo(profileImage.snp.bottom).offset(offset)
            make.centerX.equalToSuperview()
        }
        
        displaynameLabel.snp.makeConstraints{ make in
            make.top.equalTo(usernameLabel.snp.bottom).offset(offset)
            make.centerX.equalToSuperview()
        }
        
        password.snp.makeConstraints{ make in
            make.top.equalTo(displaynameLabel.snp.bottom).offset(offset)
            make.centerX.equalToSuperview()
        }
        
    }
    

}


