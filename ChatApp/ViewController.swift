//
//  ViewController.swift
//  ChatApp
//
//  Created by Charlie Brush on 12/6/20.
//

import UIKit
import SnapKit


let eventColor: UIColor = UIColor(red: 254/255.0, green: 208/255.0, blue: 209/255.0, alpha: 0.93)
let color2: UIColor = UIColor(red: 220/255.0, green: 247/255.0, blue: 247/255.0, alpha: 0.97)
let barColor: UIColor = UIColor(red: 160/255.0, green: 189/255.0, blue: 194/255.0, alpha: 0.88)
let backColor: UIColor = UIColor(red: 255/255.0, green: 244/255.0, blue: 234/255.0, alpha: 1)
let buttonColor: UIColor = UIColor(red: 186/255.0, green: 225/255.0, blue: 184/255.0, alpha: 0.93)
let labelColor: UIColor = .black
let buttonLabelColor: UIColor = .black
let textFieldColor: UIColor = UIColor(red: 253/255, green:213/255, blue: 174/255, alpha: 0.9)

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
    func deleteEvent(event: Event)
    func pop()
}

protocol Add: class {
    func getUser() -> User
    func addEvent(i: Event)
    func home()
}

protocol Profile: class {
    func setUser(i: User)
    func getUser() -> User
    func removeFriend(i: Int)
    func pushNewView(viewController: UIViewController)
    func getRequest() -> [User]
}

protocol Login: class {
    func createUser(i: User)
    
}





    
class ViewController: UIViewController {

    var edit: UIBarButtonItem!
    var starButton: UIBarButtonItem!
    var tapped: Bool!
    
    var tab: UITabBarController!
    var eventPage: EventPage!
    var addPage: AddPage!
    var profilePage: ProfilePage!
    
    var user: User!
    var events: [Event]!
    var allEvents: [Event]!
    
    var requested: [User]!
    
    
    var loginButton: UIButton!
    var signupButton: UIButton!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = backColor
        tapped=false
        
        
     //   NetworkManager.getFriendRequest() {
        
      //  }
        //get the friend requests
        
        
        loginButton = UIButton()
        loginButton.setTitle("Log In", for: .normal)
        loginButton.titleLabel?.adjustsFontSizeToFitWidth = true
        loginButton.setTitleColor(buttonLabelColor, for: .normal)
        loginButton.translatesAutoresizingMaskIntoConstraints = false
        loginButton.backgroundColor = buttonColor
        loginButton.layer.cornerRadius = 5
        loginButton.addTarget(self, action: #selector(loginTapped), for: .touchUpInside)
        view.addSubview(loginButton)
        
        signupButton = UIButton()
        signupButton.setTitle("Sign Up", for: .normal)
        signupButton.titleLabel?.adjustsFontSizeToFitWidth = true
        signupButton.setTitleColor(buttonLabelColor, for: .normal)
        signupButton.translatesAutoresizingMaskIntoConstraints = false
        signupButton.backgroundColor = buttonColor
        signupButton.layer.cornerRadius = 5
        signupButton.addTarget(self, action: #selector(signupTapped), for: .touchUpInside)
        view.addSubview(signupButton)
        
        
        self.navigationController?.navigationBar.barTintColor = barColor
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        
        setUpConstraints()
        

        
        

        
    }
    
    func getAllEvents() {
        NetworkManager.getEvents() { events2 in
            for i in events2 {
                if !(i.publicity) {
                    if let f = self.user.friends {
                        for j in f {
                            if j.netid==i.creator.netid {
                                self.events.append(Event(event2: i))
                            }
                        }
                    }
                }
                else {
                    self.events.append(Event(event2: i))
                }
            }
    }
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
        starButtonSetup()
        initialize()


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
        addPage.delegate = self
        
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
    
    func initialize() {
        getAllEvents()
        if events==nil {
            events=[(Event(name: "Blank", desc: "Nothing", date: Date(year: 20, mon: 1, day: 1, hour: 1, min: 1, suf: "AM"), creator: user, location: "Nowhere"))]
        }
        sortByDate()
        allEvents = events
    }
    
    
    func editButton() {
        edit = UIBarButtonItem()
        edit.title = "Edit"
        edit.style = .plain
        edit.tintColor = .white
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
    
    
    func starButtonSetup() {
        starButton = UIBarButtonItem()
        starButton.tintColor = .white
        starButton.style = .plain
        starButton.image = UIImage(named: "star")
        starButton.target = self
        starButton.action = #selector(starButtonTapped)
        navigationItem.leftBarButtonItem = starButton
    }
    
    @objc func starButtonTapped() {
        if tapped==false {
            tapped=true
            starButton.tintColor = .purple
            var e: [Event] = []
            for i in events {
                if let f = user.favs {
                    for j in f {
                        if i.id==j.id {
                            e.append(i)
                        }
                    }
                }
            }
            events=e
            eventPage.events = events
            eventPage.eventCollectionView.reloadData()
            
        }
        else {
            tapped=false
            starButton.tintColor = .white
            events=allEvents
            eventPage.events = events
            eventPage.eventCollectionView.reloadData()
            
        }
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
            starButtonSetup()

        }
        if tab.selectedIndex==1 {
            self.navigationItem.title="Add Event"
            addPage.tabBarItem.image = addPage.tabBarItem.image?.withTintColor(.cyan)
            eventPage.tabBarItem.image = eventPage.tabBarItem.image?.withTintColor(.white)
            profilePage.tabBarItem.image = profilePage.tabBarItem.image?.withTintColor(.white)
            navigationItem.rightBarButtonItem = nil
            navigationItem.leftBarButtonItem = nil
        }
        if tab.selectedIndex==2 {
            self.navigationItem.title="Profile"
            profilePage.tabBarItem.image = profilePage.tabBarItem.image?.withTintColor(.cyan)
            eventPage.tabBarItem.image = eventPage.tabBarItem.image?.withTintColor(.white)
            addPage.tabBarItem.image = addPage.tabBarItem.image?.withTintColor(.white)
            editButton()
            navigationItem.leftBarButtonItem = nil
        }
        
    }
    
    
    
    
    func sortByDate() {
        var temp: [Event] = []
        var pos=0
        var stop=0
      //  print(events.count)

        for i in events {
            pos=0
            stop=0
            if temp.count==0 {
                temp.append(i)
             //   print(temp.count)
            }
            else {
                for j in temp {
                    if stop==0 {
                        if i.date.lessthan(other: j.date) {
                            temp.insert(i, at: pos)
                            print(temp.count)
                         //   print(pos)
                            stop=1
                        }
                    }
                    pos+=1
                }
                if stop==0 {
                    temp.append(i)
                }
            }
        }
        events=temp
     //   print(events.count)
       // print(events)
    }
}










extension ViewController: Events, Add, Profile, Login {
    func setFriend3(i: User) {
        user.friends?.append(i)
    }
    
    func removeuserEvent(event: Event) {
        var pos=0
        var pos2=0
        for i in event.people {
            if i.netid==user.netid {
                pos2=pos
            }
            pos+=1
        }
        pos=0
        var pos3=0
        for i in events {
            if i.id==event.id {
                pos3=pos
            }
            pos+=1
        }
        events[pos3].people.remove(at: pos2)
       // event.people.remove(at: pos2)
        pos=0
        var pos4=0
        for i in user.eventInterested! {
            if i.id==event.id {
                pos4=pos
            }
            pos+=1
        }
        user.eventInterested?.remove(at: pos4)
        eventPage.events = self.events
        
        profilePage.user = self.user
        
        NetworkManager.removeSignUp(e: event, user: self.user)
    }
    
    func setuserEvent(event: Event) {
//        var pos=0
//        var ev: Event!
//        for i in events {
//            if i.name==event.name {
//                ev = events[pos]
//            }
//            pos+=1
//        }
//        user.events?.append(ev)
//        ev.people.append(user)
//        eventPage.currentEvent = ev
//        eventPage.events = self.events
//        eventPage.eventCollectionView.reloadData()
//        for i in self.events {
//            print(i.people.count)
        
        var pos=0
        var pos3=0
        for i in events {
            if i.id==event.id {
                pos3=pos
            }
            pos+=1
        }

        
        events[pos3].people.append(user)
        user.eventInterested?.append(event)
        
        profilePage.user = self.user
        
        NetworkManager.signUp(e: event, user: self.user)

    }
    
    func deleteEvent(event: Event) {
        var pos=0
        var pos3=0
        for i in events {
            if i.id==event.id {
                pos3=pos
            }
            pos+=1
        }
        events.remove(at: pos3)
       // event.people.remove(at: pos2)
        pos=0
        var pos4=0
        for i in user.eventCreated! {
            if i.id==event.id {
                pos4=pos
            }
            pos+=1
        }
        user.eventCreated?.remove(at: pos4)
        eventPage.events = self.events
        eventPage.eventCollectionView.reloadData()
        profilePage.user = self.user
        
        NetworkManager.deleteEvent(e: event)
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
        
        eventPage.eventCollectionView.reloadData()
    }
    func removeFav2(i: Event) {
        var pos = 0
        for j in user.favs! {
            if j.id==i.id {
                user.favs?.remove(at: pos)
            }
            pos+=1
        }
        eventPage.eventCollectionView.reloadData()
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
    
    
//    func getUserFromUsername(i: String) {
//        self.user=User(netid: i, name: "created user",password: "password")
//        self.signupButton=nil
//        self.loginButton=nil
//
//        //remove later
//        self.user.friends=[User(netid: "netid", name: "some user",password: "password",socialAccount: "@social"),User(netid: "net2", name: "some other user",password: "password",socialAccount: "@social2")]
//        self.user.eventCreated=[]
//        self.user.eventCreated?.append(events[1])
//        //
//        setUpTabBar()
//
//    }
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
      //  NetworkManager.createEvent(e: i, user: self.user)
        events.append(i)
        sortByDate()

        eventPage.events=events
       // eventPage.events.append(i)

        user.eventCreated?.append(i)
        
        eventPage.eventCollectionView.reloadData()
    }
    
    func home() {
        self.tab.selectedIndex=0
        eventPage.tabBarItem.image = eventPage.tabBarItem.image?.withTintColor(.cyan)
        addPage.tabBarItem.image = addPage.tabBarItem.image?.withTintColor(.white)
        profilePage.tabBarItem.image = profilePage.tabBarItem.image?.withTintColor(.white)
        
    }
    
    func pop() {
        navigationController?.popViewController(animated: false)
    }
    
    
    func getRequest() -> [User] {
        return requested
    }
 
}




