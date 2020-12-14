//
//  EventPage.swift
//  ChatApp
//
//  Created by Charlie Brush on 12/6/20.
//

import UIKit
import SnapKit


protocol View: class {
    func getEvent() -> Event?
    func getUser() -> User
    func setFriend2(i: User)
    func setEvent(i: Event)
    func removeEvent(i: Event)
    func setFav(i: Event)
    func removeFav(i: Event)
    func removeFromView(i: Event)
    func addToView(i: Event)
    func deleteEvent(i: Event)
}


class EventPage: UIViewController {
    var eventCollectionView: UICollectionView!
    let eventCellReuseIdentifier = "eventCellReuseIdentifier"
    let padding: CGFloat = 8
    
    weak var delegate: Events?
    
    var currentEvent: Event!
    var currentIndex: Int!
    
    
    

    var events: [Event]!
    var allEvents: [Event]!
    
    


    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor=backColor
        
        allEvents = delegate?.getEvents()
        events = []
        for i in allEvents {
            events.append(i)
        }
        
        
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
            make.top.equalTo(view.safeAreaLayoutGuide).offset(45)
            make.leading.equalToSuperview().offset(padding)
            make.bottom.equalToSuperview()
            make.trailing.equalToSuperview().offset(-padding)
        }
        
        
    }
}


extension EventPage: UICollectionViewDataSource {
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





extension EventPage: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
            let size = (collectionView.frame.width - padding*2)
        return CGSize(width: size, height: collectionView.frame.height/3.5)

        
    }
    


}

extension EventPage: View {
    func setFriend2(i: User) {

        delegate?.setFriend3(i: i)
    }
    
    func removeEvent(i: Event) {
        delegate?.removeuserEvent(event: i)
        events = delegate?.getEvents()
    }
    
    func setEvent(i: Event) {
        delegate?.setuserEvent(event: i)
        currentEvent.people.append((delegate?.getUser())!)
        events=delegate?.getEvents()
        eventCollectionView.reloadData()
    }
    
    func getUser() -> User {
        return (delegate?.getUser())!
    }
    
    func getEvent() -> Event? {
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
        var pos=(-1)
        for j in events {
            if j.name==i.name {
                pos=1
            }
        }
        if pos == -1 {
            events.append(i)
        }
        eventCollectionView.reloadData()
    }
    
    func deleteEvent(i: Event) {
        
        delegate?.deleteEvent(event: i)
        events=delegate?.getEvents()
        delegate?.pop()
    }
    
    
}


extension EventPage: UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        currentEvent = events[indexPath.row]
        currentIndex = indexPath.row
        
        let newViewController = ViewEvent()
        newViewController.delegate = self
        delegate?.pushView(event: currentEvent, viewConroller: newViewController)
        
        
        
    collectionView.reloadData()

    }
}



    
    

