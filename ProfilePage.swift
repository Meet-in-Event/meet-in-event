//
//  ProfilePage.swift
//  ChatApp
//
//  Created by Charlie Brush on 12/6/20.
//

import UIKit

class ProfilePage: UIViewController {
    weak var delegate: Profile?
    weak var delegate2: Events?

    var user: User!
    
    var profileImage: UIImageView!
    var usernameLabel: UILabel!
    var displaynameLabel: UILabel!
    var password: UILabel!
    
    var eventsButton: UIButton!
    var myeventsButton: UIButton!
    var friendsButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = backColor
        
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
        
        eventsButton = UIButton()
        eventsButton.setTitle("My Events", for: .normal)
        eventsButton.titleLabel?.adjustsFontSizeToFitWidth = true
        eventsButton.setTitleColor(.white, for: .normal)
        eventsButton.translatesAutoresizingMaskIntoConstraints = false
        eventsButton.backgroundColor = buttonColor
        eventsButton.layer.cornerRadius = 5
        eventsButton.addTarget(self, action: #selector(eventsTapped), for: .touchUpInside)

        view.addSubview(eventsButton)
        
        
        myeventsButton = UIButton()
        myeventsButton.setTitle("Created Events", for: .normal)
        myeventsButton.titleLabel?.adjustsFontSizeToFitWidth = true
        myeventsButton.setTitleColor(.white, for: .normal)
        myeventsButton.translatesAutoresizingMaskIntoConstraints = false
        myeventsButton.backgroundColor = buttonColor
        myeventsButton.layer.cornerRadius = 5
        myeventsButton.addTarget(self, action: #selector(myeventsTapped), for: .touchUpInside)
        view.addSubview(myeventsButton)
        
        friendsButton = UIButton()
        friendsButton.setTitle("Friends", for: .normal)
        friendsButton.titleLabel?.adjustsFontSizeToFitWidth = true
        friendsButton.setTitleColor(.white, for: .normal)
        friendsButton.translatesAutoresizingMaskIntoConstraints = false
        friendsButton.backgroundColor = buttonColor
        friendsButton.layer.cornerRadius = 5
        friendsButton.addTarget(self, action: #selector(friendsTapped), for: .touchUpInside)
        view.addSubview(friendsButton)
        
    }
    
    
    func setupConstraints() {
        let offset: CGFloat = 15
        
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
            eventsButton.snp.makeConstraints{ make in
                make.top.equalTo(password.snp.bottom).offset(offset)
                make.centerX.equalToSuperview()
                make.width.equalTo(150)
                make.height.equalTo(50)
            }
            myeventsButton.snp.makeConstraints{ make in
                make.top.equalTo(eventsButton.snp.bottom).offset(offset)
                make.centerX.equalToSuperview()
                make.width.equalTo(150)
                make.height.equalTo(50)
            }
        
       
        
        
        
        friendsButton.snp.makeConstraints{ make in
            make.top.equalTo(myeventsButton.snp.bottom).offset(offset)
            make.centerX.equalToSuperview()
            make.width.equalTo(150)
            make.height.equalTo(50)
        }
        
    }
    
    @objc func eventsTapped() {
        print("events tapped")
        if !(user.events?.count==0) {
            let newViewController = MyEvents()
            newViewController.which=0
            newViewController.delegate = self.delegate2
            delegate?.pushNewView(viewController: newViewController)
        }
        
        }
    
    @objc func myeventsTapped() {
        print("my events tapped")
        if !(user.createdEvents?.count==0) {
            let newViewController = MyEvents()
            newViewController.which=1
            newViewController.delegate = self.delegate2
            delegate?.pushNewView(viewController: newViewController)
        }
    }
    
    @objc func friendsTapped() {
        print("friends tapped")
        let newViewController = Friends()
        newViewController.delegate = self.delegate
        delegate?.pushNewView(viewController: newViewController)
        }
    

}


