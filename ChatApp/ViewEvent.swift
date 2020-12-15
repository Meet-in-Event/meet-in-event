//
//  ViewEvent.swift
//  ChatApp
//
//  Created by Charlie Brush on 12/7/20.
//

import UIKit
import SnapKit


protocol UserCollection: class {
    func getFriends() -> [User]?
    func setFriend(i: User)
}

class ViewEvent: UIViewController {
    weak var delegate: View?
    
    var eventImage: UIImageView!

    var nameLabel: UILabel!
    var dateLabel: UILabel!
    var desc: UITextView!
    var locationLabel: UILabel!
    
    var signUp: UIButton!

    var creatorLabel: UILabel!
    var usersLabel: UILabel!

    var event: Event!
    var user: User!
    var users: [User]!
    var users2: [User]!
    var added: [User]!
    
    var sign: Int!
    
    var isadded: Bool!
    
    var signUpButton: UIButton!
    var del: UIBarButtonItem!
    
    var userCollectionView: UICollectionView!
    let userCellReuseIdentifier = "userCellReuseIdentifier"
    
    let offset: CGFloat = 8

    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = backColor
 
        
        event = delegate?.getEvent()
        user = delegate?.getUser()
        users = event.people
        
        users2 = users
        var pos=0
        for i in users{
            if i.netid==user.netid {
                users2.remove(at: pos)
            }
            pos+=1
        }
        
        isadded=false
        for i in event.people {
            if i.netid==user.netid {
                isadded=true
            }
        }

                
        setupViews()
        if user.netid==event.creator.netid {
            signUpButton=nil
            del = UIBarButtonItem()
            del.title = "Delete"
            del.style = .plain
            del.target = self
            del.action = #selector(delTapped)
            navigationItem.rightBarButtonItem = del
        }
        setupConstraints()
        
        
        
        
        
        
    }
    
    func setupViews() {
        
        eventImage = UIImageView()
        eventImage.translatesAutoresizingMaskIntoConstraints = false
        eventImage.clipsToBounds = true
        eventImage.layer.masksToBounds = true
        eventImage.contentMode = .scaleAspectFill
        eventImage.image = UIImage(named: event.image)
        view.addSubview(eventImage)

        
        nameLabel = UILabel()
        nameLabel.text = event.name
        nameLabel.font = UIFont.boldSystemFont(ofSize: 30)
        nameLabel.textColor = labelColor
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(nameLabel)
        
        dateLabel = UILabel()
        dateLabel.text = event.date.getDate()
        dateLabel.textColor = labelColor
        dateLabel.font = UIFont.systemFont(ofSize: 20)
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(dateLabel)
        
        locationLabel = UILabel()
        locationLabel.text = event.location
        locationLabel.textColor = labelColor
        locationLabel.font = UIFont.systemFont(ofSize: 20)
        locationLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(locationLabel)
        
        desc = UITextView()
        desc.text = event.desc
        desc.textColor = .white
        desc.backgroundColor = barColor
        desc.font = UIFont.systemFont(ofSize: 20)
        desc.translatesAutoresizingMaskIntoConstraints = false
        desc.isEditable = false
        desc.layer.cornerRadius = 10
        desc.textAlignment = .center
        view.addSubview(desc)
        
        creatorLabel = UILabel()
        creatorLabel.text = "Created by: \(event.creator.name)"
        creatorLabel.textColor = labelColor
        creatorLabel.font = UIFont.systemFont(ofSize: 20)
        creatorLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(creatorLabel)
        
        usersLabel = UILabel()
        usersLabel.text = "Signed up: "
        usersLabel.textColor = labelColor
        usersLabel.font = UIFont.systemFont(ofSize: 20)
        usersLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(usersLabel)
        
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumInteritemSpacing = 10

        userCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        userCollectionView.register(UserCollectionViewCell.self, forCellWithReuseIdentifier: userCellReuseIdentifier)
        userCollectionView.dataSource = self
        userCollectionView.delegate = self
        userCollectionView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(userCollectionView)
        
        signUpButton = UIButton()
        signUpButton.setTitle("Sign Up", for: .normal)
        signUpButton.titleLabel?.adjustsFontSizeToFitWidth = true
        signUpButton.setTitleColor(buttonLabelColor, for: .normal)
        signUpButton.translatesAutoresizingMaskIntoConstraints = false
        if isadded==false {
            signUpButton.backgroundColor = buttonColor
        }
        else {
            signUpButton.backgroundColor = eventColor
        }
        signUpButton.layer.cornerRadius = 10
        signUpButton.addTarget(self, action: #selector(signUpTapped), for: .touchUpInside)
        view.addSubview(signUpButton)
        
        sign=0
        if let c = user.eventCreated {
            for i in c {
                if i.name==event.name {
                    signUpButton=nil
                    sign=1
                }
            }
        }
        
        

    }
    
    
    
    func setupConstraints() {
        
        let width: CGFloat = view.frame.width
        
//        eventImage.snp.makeConstraints{make in
//            make.height.width.equalTo(250)
//            make.width.equalToSuperview()
//            make.centerX.equalToSuperview()
//            make.top.equalTo(view.safeAreaLayoutGuide)
//        }
        
//        nameLabel.snp.makeConstraints{make in
//            make.top.equalTo(eventImage.snp.bottom)
//            make.center.equalToSuperview()
//        }
        NSLayoutConstraint.activate([
            eventImage.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            eventImage.widthAnchor.constraint(equalTo: view.widthAnchor),
            eventImage.heightAnchor.constraint(equalToConstant: view.frame.height/3.5),
            eventImage.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor)
        ])
        
        NSLayoutConstraint.activate([
            nameLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            nameLabel.topAnchor.constraint(equalTo: eventImage.bottomAnchor, constant: offset)
        ])
        
        NSLayoutConstraint.activate([
            dateLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            dateLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor),
        ])
        
        NSLayoutConstraint.activate([
            locationLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            locationLabel.topAnchor.constraint(equalTo: dateLabel.bottomAnchor),
        ])
        
//        NSLayoutConstraint.activate([
//            desc.topAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant: offset),
//            desc.topAnchor.constraint(equalTo: nameLabel.bottomAnchor),
//        ])
        
        desc.snp.makeConstraints{make in
            make.top.equalTo(locationLabel.snp.bottom).offset(offset)
            make.leading.equalToSuperview().offset(offset)
            make.width.equalTo(((width-offset*3)*2/3))
            make.height.equalTo(view.frame.height/4.5)
        }
        
        creatorLabel.snp.makeConstraints{make in
            make.top.equalTo(desc.snp.bottom).offset(offset*2)
            make.leading.equalToSuperview().offset(offset)
        }
        
        usersLabel.snp.makeConstraints{make in
            make.top.equalTo(creatorLabel.snp.bottom).offset(offset*2)
            make.leading.equalToSuperview().offset(offset)
        }
        
        userCollectionView.snp.makeConstraints{make in
            make.top.equalTo(creatorLabel.snp.bottom).offset(offset*2)
            make.left.equalTo(usersLabel.snp.right).offset(offset)
            make.bottom.equalToSuperview().offset(-offset)
            make.width.equalTo(((width)*1/2))
        }
        if sign==0 && !(signUpButton==nil) {
            signUpButton.snp.makeConstraints{make in
                make.top.equalTo(desc.snp.top)
                make.leading.equalTo(desc.snp.trailing).offset(offset)
                make.trailing.equalToSuperview().offset(-offset)
                make.height.equalTo(50)
            }
        }
        
        
    }
    
    @objc func signUpTapped() {
        if isadded==false {
            signUpButton.backgroundColor = eventColor
            delegate?.setEvent(i: event)
            isadded=true
            }
        else {
            isadded=false
            signUpButton.backgroundColor = buttonColor
            delegate?.removeEvent(i: event)
        }
        
        
    }
    
    @objc func delTapped() {
        delegate?.deleteEvent(i: event)

        }

    
    
}
extension ViewEvent: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if users2.count==0 {
            collectionView.backgroundColor=backColor
        }
        return users2.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = userCollectionView.dequeueReusableCell(withReuseIdentifier: userCellReuseIdentifier, for: indexPath) as! UserCollectionViewCell
        cell.delegate = self

        cell.configure(for: users2[indexPath.item])

        userCollectionView.backgroundColor = backColor
        return cell


    }

}





extension ViewEvent: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let size = (collectionView.frame.width)
        return CGSize(width: size, height: 30)
        
    }
    


}


extension ViewEvent: UserCollection {
    func getFriends() -> [User]? {
        return user.friends
    }
    
    func setFriend(i: User) {

        delegate?.setFriend2(i: i)
        user = delegate?.getUser()
        
    }
    
    
}

