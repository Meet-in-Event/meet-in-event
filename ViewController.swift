//
//  ViewController.swift
//  ChatApp
//
//  Created by Charlie Brush on 12/6/20.
//

import UIKit
import SnapKit


let eventColor: UIColor = UIColor(red: 237/255.0, green: 116/255.0, blue: 223/255.0, alpha: 0.93)
let color2: UIColor = UIColor(red: 220/255.0, green: 247/255.0, blue: 247/255.0, alpha: 0.97)
let barColor: UIColor = UIColor(red: 175/255.0, green: 121/255.0, blue: 224/255.0, alpha: 0.88)
let backColor: UIColor = UIColor(red: 219/255.0, green: 178/255.0, blue: 245/255.0, alpha: 1)
let buttonColor: UIColor = UIColor(red: 116/255.0, green: 120/255.0, blue: 237/255.0, alpha: 0.93)

protocol Events: class {
    func getEvents() -> [Event]?
    func getUser() -> User
    func pushView(event: Event, viewConroller: UIViewController)
    func setuserEvent(event: Event)
    func removeuserEvent(event: Event)
    func setFriend3(i: User)
    func setFav2(i: Event)
    func removeFav2(i: Event)
    func addEvent(i: Event)
}

protocol Profile: class {
    func setUser(i: User)
    func getUser() -> User
    func removeFriend(i: Int)
    func pushNewView(viewController: UIViewController)
}

protocol Login: class {
    func getUserFromUsername(i: String)
    func createUser(i: User)
    
}


class ViewController: UIViewController {

    var edit: UIBarButtonItem!
    
    var tab: UITabBarController!
    var eventPage: EventPage!
    var addPage: AddPage!
    var profilePage: ProfilePage!
    
    var user: User!
    var events: [Event]!
    
    var loginButton: UIButton!
    var signupButton: UIButton!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = backColor
        
        
        user=User(username: "user", displayname: "default user", password: "password")
        events=[Event(name: "Event 1", desc: "this is an event", date: Date(year: 2020, mon: 1, day: 1, hour: 10, min: 30, suf: "AM"), creator: user, people: [User(username: "user1", displayname: "user1", password: "password")]),Event(name: "Event 2", desc: "this is an eventthis is an eventthis is an eventthis is an eventthis is an eventthis is an eventthis is an eventthis is an eventthis is an eventthis is an eventthis is an event", date: Date(year: 2020, mon: 1, day: 1, hour: 10, min: 45, suf: "AM"), creator: user,people: [User(username: "user1", displayname: "user1", password: "password")],max:10)]
        for i in 1...8 {
            events[0].people.append(User(username: "user\(i)", displayname: "user\(i)", password: "password"))
            }
        for _ in 1...3 {
            events.append(events[0])
        }
        events.append(Event(name: "Event 3", desc: "this is an event", date: Date(year: 2020, mon: 2, day: 1, hour: 10, min: 30, suf: "AM"), creator: user, people: [User(username: "user1", displayname: "user1", password: "password")]))
        
        
        loginButton = UIButton()
        loginButton.setTitle("Log In", for: .normal)
        loginButton.titleLabel?.adjustsFontSizeToFitWidth = true
        loginButton.setTitleColor(.white, for: .normal)
        loginButton.translatesAutoresizingMaskIntoConstraints = false
        loginButton.backgroundColor = buttonColor
        loginButton.layer.cornerRadius = 5
        loginButton.addTarget(self, action: #selector(loginTapped), for: .touchUpInside)
        view.addSubview(loginButton)
        
        signupButton = UIButton()
        signupButton.setTitle("Sign Up", for: .normal)
        signupButton.titleLabel?.adjustsFontSizeToFitWidth = true
        signupButton.setTitleColor(.white, for: .normal)
        signupButton.translatesAutoresizingMaskIntoConstraints = false
        signupButton.backgroundColor = buttonColor
        signupButton.layer.cornerRadius = 5
        signupButton.addTarget(self, action: #selector(signupTapped), for: .touchUpInside)
        view.addSubview(signupButton)
        
        
        self.navigationController?.navigationBar.barTintColor = barColor
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        
        setUpConstraints()
            
        
        

        
    }
    
    func setUpConstraints() {
        
        loginButton.snp.makeConstraints{make in
            make.centerX.equalToSuperview()
            make.width.equalTo(150)
            make.height.equalTo(75)
            make.centerY.equalToSuperview().offset(-50)
        }
        signupButton.snp.makeConstraints{make in
            make.centerX.equalToSuperview()
            make.width.equalTo(150)
            make.height.equalTo(75)
            make.centerY.equalToSuperview().offset(50)
        }
        
    }
    
    @objc func loginTapped() {
//        loginButton.backgroundColor = eventColor
        let newViewController = LogIn()
        newViewController.delegate = self
        navigationController?.pushViewController(newViewController, animated: true)
    }
    @objc func signupTapped() {
    //    signupButton.backgroundColor = eventColor
        let newViewController = SignUp()
        newViewController.delegate = self
        navigationController?.pushViewController(newViewController, animated: true)
    }
    
    
    func setUpTabBar() {

        view.backgroundColor = .white
        tab = UITabBarController()
        tab.tabBar.barTintColor = barColor
        self.navigationController?.navigationBar.barTintColor = barColor
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        
        
        eventPage = EventPage()

        addPage = AddPage()
        profilePage = ProfilePage()
       // self.addChild(eventPage)
        self.addChild(addPage)
        self.addChild(profilePage)

        eventPage.delegate = self
        profilePage.delegate = self
        profilePage.delegate2 = self
       // addPage.delegate = self
        
        let eventItem = UITabBarItem(title: nil, image: UIImage(named: "event")?.withRenderingMode(UIImage.RenderingMode.alwaysOriginal), tag: 0)
        let addItem = UITabBarItem(title: nil, image: UIImage(named: "add")?.withRenderingMode(UIImage.RenderingMode.alwaysOriginal), tag: 1)
        let profileItem = UITabBarItem(title: nil, image: UIImage(named: "profile")?.withRenderingMode(UIImage.RenderingMode.alwaysOriginal), tag: 2)
        
        eventPage.tabBarItem = eventItem
        addPage.tabBarItem = addItem
        profilePage.tabBarItem = profileItem
        
        eventPage.tabBarItem.imageInsets = UIEdgeInsets(top: 20, left: 0, bottom: 0, right: 0)
        addPage.tabBarItem.imageInsets = UIEdgeInsets(top: 15, left: 0, bottom: 0, right: 0)
        profilePage.tabBarItem.imageInsets = UIEdgeInsets(top: 20, left: 0, bottom: 0, right: 0)
        
        
        
        tab.setViewControllers([eventPage,addPage,profilePage], animated: false)
        tab.selectedIndex = 0
        self.navigationItem.title="Events"
        eventPage.tabBarItem.image = eventPage.tabBarItem.image?.withTintColor(.cyan)
        tab.delegate = self

        
        
        view.addSubview(tab.view)
    }
    
    
    func editButton() {
        edit = UIBarButtonItem()
        edit.title = "Edit"
        edit.style = .plain
      //  edit.tintColor = .cyan
        edit.target = self
        edit.action = #selector(editTapped)
        navigationItem.rightBarButtonItem = edit

    }
    
    
    @objc func editTapped() {
      //  edit.tintColor = .magenta

        let newViewController = ProfilePageEdit()
        newViewController.delegate = self
        navigationController?.pushViewController(newViewController, animated: true)
        }
    

}


extension ViewController: UITabBarControllerDelegate{
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {

        if tab.selectedIndex==0 {
            self.navigationItem.title="Events"
            eventPage.tabBarItem.image = eventPage.tabBarItem.image?.withTintColor(.cyan)
            addPage.tabBarItem.image = addPage.tabBarItem.image?.withTintColor(.white)
            profilePage.tabBarItem.image = profilePage.tabBarItem.image?.withTintColor(.white)
            navigationItem.rightBarButtonItem = nil

        }
        if tab.selectedIndex==1 {
            self.navigationItem.title="Add Event"
            addPage.tabBarItem.image = addPage.tabBarItem.image?.withTintColor(.cyan)
            eventPage.tabBarItem.image = eventPage.tabBarItem.image?.withTintColor(.white)
            profilePage.tabBarItem.image = profilePage.tabBarItem.image?.withTintColor(.white)
            navigationItem.rightBarButtonItem = nil
        }
        if tab.selectedIndex==2 {
            self.navigationItem.title="Profile"
            profilePage.tabBarItem.image = profilePage.tabBarItem.image?.withTintColor(.cyan)
            eventPage.tabBarItem.image = eventPage.tabBarItem.image?.withTintColor(.white)
            addPage.tabBarItem.image = addPage.tabBarItem.image?.withTintColor(.white)
            editButton()
        }
        
        

        
    }
}










extension ViewController: Events, Profile, Login {
    func setFriend3(i: User) {
        user.friends?.append(i)
    }
    
    func removeuserEvent(event: Event) {
        var pos=0
        for i in event.people {
            if i.username==user.username {
                event.people.remove(at: pos)
            }
            pos+=1
        }
        pos=0
        for i in user.events! {
            if i.name==event.name {
                user.events?.remove(at: pos)
            }
            pos+=1
        }
    }
    
    func setuserEvent(event: Event) {
        user.events?.append(event)
        event.people.append(user)
    }
    
    func getUser() -> User {
        return user
    }
    
    func pushView(event: Event, viewConroller: UIViewController) {
        navigationController?.pushViewController(viewConroller, animated: true)
    }
    
    
    func getEvents() -> [Event]? {
        return events
    }
    
    func setFav2(i: Event) {
        user.favs?.append(i)
    }
    func removeFav2(i: Event) {
        var pos = 0
        for j in user.favs! {
            if j.name==i.name {
                user.favs?.remove(at: pos)
            }
            pos+=1
        }
        
    }
    
    func setUser(i: User) {
        self.user = i
       // self.edit.tintColor = .cyan
        profilePage=ProfilePage()
        profilePage.delegate = self
        let profileItem = UITabBarItem(title: nil, image: UIImage(named: "profile")?.withRenderingMode(UIImage.RenderingMode.alwaysOriginal), tag: 2)
        profilePage.tabBarItem = profileItem
        profilePage.tabBarItem.imageInsets = UIEdgeInsets(top: 20, left: 0, bottom: 0, right: 0)
        
        
        tab.setViewControllers([eventPage,addPage,profilePage], animated: false)
    }
    
    
    func getUserFromUsername(i: String) {
        self.user=User(username: i, displayname: "created user",password: "password")
        self.signupButton=nil
        self.loginButton=nil
        
        //remove later
        self.user.friends=[User(username: "username", displayname: "some user",password: "password",social: "@social"),User(username: "username2", displayname: "some other user",password: "password",social: "@social2")]
        self.user.createdEvents=[]
        self.user.createdEvents?.append(events[1])
        //
        setUpTabBar()
    }
    func createUser(i: User) {
        self.user = i
        self.signupButton=nil
        self.loginButton=nil
        setUpTabBar()
    }
    
    func removeFriend(i: Int) {
        user.friends?.remove(at: i)
    }
    
    func pushNewView(viewController: UIViewController) {
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    func addEvent(i: Event) {
        var pos=(-1)

        if i.people.count<i.max {
            if let e = eventPage.events {
                for j in e {
                    if j.name==i.name {
                        pos=0
                    }
                }
            }
        }
        if pos == -1 {
            eventPage.events.append(i)
            print("adding event")

        }
        eventPage.eventCollectionView.reloadData()
    }
}




