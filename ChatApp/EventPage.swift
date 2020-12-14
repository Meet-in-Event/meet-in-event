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
    var filterCV: UICollectionView!
    let tagCellReuseIdentifier = "tagCellReuseIdentifier"
    var eventCollectionView: UICollectionView!
    let eventCellReuseIdentifier = "eventCellReuseIdentifier"
    let padding: CGFloat = 8
    
    weak var delegate: Events?
    
    var currentEvent: Event!
    var currentIndex: Int!
    
    
    

    var events: [Event]!
    var allEvents: [Event]!
    
    var filter1 = Tag(tag: "Sports")
      var filter2 = Tag(tag: "Music")
      var filter3 = Tag(tag: "Study")
    var filter4 = Tag(tag: "Outdoors")
    var filter5 = Tag(tag: "Shopping")
    var filter6 = Tag(tag: "Other")
    
    var filters: [Tag] = []
    


    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor=backColor
        
        allEvents = delegate?.getEvents()
        events = []
        for i in allEvents {
            events.append(i)
        }
        
        filters = [filter1, filter2, filter3, filter4, filter5, filter6]
        
        
        let filterLayout = UICollectionViewFlowLayout()
        filterLayout.scrollDirection = .horizontal
        filterLayout.minimumInteritemSpacing = padding
       // filterLayout.minimumLineSpacing = 0
        
        
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
        
        
        filterCV = UICollectionView(frame: .zero, collectionViewLayout: filterLayout)
        filterCV.backgroundColor = backColor
        filterCV.register(FilterCollectionViewCell.self, forCellWithReuseIdentifier: tagCellReuseIdentifier)
        filterCV.dataSource = self
        filterCV.delegate = self
        filterCV.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(filterCV)
        
        
        setupConstraints()
        
    }
    
    func setupConstraints() {
        
//        filterCV.snp.makeConstraints{make in
//            make.top.equalTo(view.)
//            make.leading.equalToSuperview().offset(padding)
//            make.height.equalTo(100)
//            make.trailing.equalToSuperview().offset(-padding)
//        }
        NSLayoutConstraint.activate([
                     filterCV.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 50),
                     filterCV.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
                     filterCV.heightAnchor.constraint(equalToConstant: 40),
                     filterCV.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding)
                            ]);
        
        eventCollectionView.snp.makeConstraints{ make in
            make.top.equalTo(filterCV.snp.bottom).offset(10)
            make.leading.equalToSuperview().offset(padding)
            make.bottom.equalToSuperview()
            make.trailing.equalToSuperview().offset(-padding)
        }
        
        
    }
}


extension EventPage: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if(collectionView == filterCV){
                      return filters.count}
                  else{
                      return events.count
                  }
            
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
//            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: eventCellReuseIdentifier, for: indexPath) as! EventCollectionViewCell
//            cell.delegate=self
//
//            cell.configure(for: events[indexPath.item])
//            collectionView.backgroundColor = backColor
//            return cell
        if(collectionView == filterCV){
                 let cell = filterCV.dequeueReusableCell(withReuseIdentifier: tagCellReuseIdentifier, for: indexPath) as! FilterCollectionViewCell
                                     
            cell.configure(for: filters[indexPath.item], color1: eventColor, color2: UIColor(red: 253/255.0, green: 120/255.0, blue: 200/255.0, alpha: 1))
                 return cell
             }
             else{
                 let cell = collectionView.dequeueReusableCell(withReuseIdentifier: eventCellReuseIdentifier, for: indexPath) as! EventCollectionViewCell
                 cell.delegate=self

                 cell.configure(for: events[indexPath.item])
                 collectionView.backgroundColor = backColor
                 return cell
             }

    }
    
    func sort() {
        var falseCount = 0
           events.removeAll()
            for filter in filters{
                      if (filter.isOn == false)
                      {falseCount+=1}
                                              
                  }
                  if(falseCount == filters.count){
                      for e in allEvents{
                          events.append(e)
                      }}
                  else{
                  for e in allEvents{
                   if let i = e.tags {
                      for f in i{
                          if(f.isOn)
                          { events.append(e)}
                      }
                   }
                          }}
       filterCV.reloadData()
       eventCollectionView.reloadData()
    }

}





extension EventPage: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
            
        if(collectionView == filterCV){
//            let size = (filterCV.frame.width - 2 * padding)/4.0
//            return CGSize(width: size, height: 40)
            
            let size = (collectionView.frame.width - padding*3) / 2.5
            return CGSize(width: size, height: 30)

        }else{
            let size = (collectionView.frame.width - padding*2)
        return CGSize(width: size, height: collectionView.frame.height/3.4)
        }
        
        
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
            if !(j.id==i.id) {
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
            if j.id==i.id {
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
//        currentEvent = events[indexPath.row]
//        currentIndex = indexPath.row
//
//        let newViewController = ViewEvent()
//        newViewController.delegate = self
//        delegate?.pushView(event: currentEvent, viewConroller: newViewController)
//
//
//
//    collectionView.reloadData()
        if(collectionView==filterCV){
                   let f = filters[indexPath.item]
                        if(f.isOn){
                            filters[indexPath.item].isOn = false
                        }
                        else{
                            filters[indexPath.item].isOn = true
                        }
                         sort()
                   
                   
                   
                   
                   
               }
               else{
               currentEvent = events[indexPath.row]
               currentIndex = indexPath.row
               
               let newViewController = ViewEvent()
               newViewController.delegate = self
               delegate?.pushView(event: currentEvent, viewConroller: newViewController)
               }
               
               
           collectionView.reloadData()

    }
}



    
    

