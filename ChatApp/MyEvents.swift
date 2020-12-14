//
//  MyEvents.swift
//  ChatApp
//
//  Created by Charlie Brush on 12/10/20.
//

import UIKit
import SnapKit



class MyEvents: UIViewController {
    var eventCollectionView: UICollectionView!
    let eventCellReuseIdentifier = "eventCellReuseIdentifier"
    let padding: CGFloat = 8
    
    weak var delegate: Events?
    
    var currentEvent: Event!
    var currentIndex: Int!
    var user: User!

    var events: [Event]!
    
    var which: Int!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.barTintColor = barColor
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        view.backgroundColor = backColor
        if which==0 {
            self.title = "My Events"
        }
        else {
            self.title = "Created Events"
        }
        
        
        user = delegate?.getUser()
     //   print(user)
        events = []
        if which==0 {
            if let e = user.eventInterested {
                for i in e {
                    events.append(i)
                    events[events.count-1].people.append(user)
                }
            }
        }
        if which==1 {
            if let e = user.eventCreated {
                for i in e {
                    events.append(i)
                }
            }
        }
        
       // print(events[0].people.count)
        
        
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = padding*2
        layout.sectionInset.top = padding
        
        eventCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        eventCollectionView.register(EventCollectionViewCell.self, forCellWithReuseIdentifier: eventCellReuseIdentifier)
        eventCollectionView.dataSource = self
        eventCollectionView.delegate = self
        eventCollectionView.backgroundColor = backColor
        eventCollectionView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(eventCollectionView)
        
        
        
        
        setupConstraints()
        
    }
    
    func setupConstraints() {
        
        
        eventCollectionView.snp.makeConstraints{ make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(5)
            make.leading.equalToSuperview().offset(padding)
            make.bottom.equalToSuperview()
            make.trailing.equalToSuperview().offset(-padding)
        }
        
        
    }
}


extension MyEvents: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return events.count
            
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: eventCellReuseIdentifier, for: indexPath) as! EventCollectionViewCell
            cell.delegate=self

            cell.configure(for: events[indexPath.item])
            collectionView.backgroundColor = backColor
            return cell

    }

}





extension MyEvents: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
            let size = (collectionView.frame.width - padding*2)
        return CGSize(width: size, height: view.frame.height/4)

        
    }
    


}

extension MyEvents: View {
    func setFriend2(i: User) {

        delegate?.setFriend3(i: i)
    }
    
    func removeEvent(i: Event) {
        delegate?.removeuserEvent(event: i)
        var pos=0
        var pos2=0
        for j in i.people {
            if j.netid==user.netid {
                pos2=pos
            }
            pos+=1
        }
        pos=0
        var pos3=0
        for j in events {
            if j.name==i.name {
                pos3=pos
            }
            pos+=1
        }
        events[pos3].people.remove(at: pos2)
        events.remove(at: pos3)
      //  print(currentEvent)
     //   user=delegate?.getUser()
        eventCollectionView.reloadData()
        navigationController?.popViewController(animated: true)

    }
    
    func deleteEvent(i: Event) {
        
        delegate?.deleteEvent(event: i)
      //  events=delegate?.getEvents()
        var pos=0
        var pos3=0
        for j in events {
            if j.name==i.name {
                pos3=pos
            }
            pos+=1
        }
        events.remove(at: pos3)
      //  print(currentEvent)
        user=delegate?.getUser()
        eventCollectionView.reloadData()
        navigationController?.popViewController(animated: true)
    }
    
    func setEvent(i: Event) {
        delegate?.setuserEvent(event: i)
    }
    
    func getUser() -> User {
        return (delegate?.getUser())!
    }
    
    func getEvent() -> Event? {
       // print("getting event")
       // print(currentEvent.people.count)
        return currentEvent
    }
    
    func setFav(i: Event) {
        delegate?.setFav2(i: i)
        eventCollectionView.reloadData()
    }
    func removeFav(i: Event) {
        delegate?.removeFav2(i: i)
        eventCollectionView.reloadData()
    }
    
    func removeFromView(i: Event) {
        var pos=0
        var e: [Event] = []
        for j in events {
            if !(j.name==i.name) {
                e.append(j)
            }
            pos+=1
        }
        events = e
        eventCollectionView.reloadData()
    }
    func addToView(i: Event) {
        var pos=0
        var l=0
        for j in events {
            if j.name==i.name {
                l=pos
            }
            pos+=1
        }
        events.remove(at: l)
        eventCollectionView.reloadData()
        
       // print("addToView running")
        
       // self.delegate?.addEvent(i: i)
    }
    
    
}


extension MyEvents: UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        currentEvent = events[indexPath.row]
        currentIndex = indexPath.row
        
        let newViewController = ViewEvent()
        newViewController.delegate = self
        delegate?.pushView(event: currentEvent, viewConroller: newViewController)
        
        
        
    collectionView.reloadData()

    }
}

