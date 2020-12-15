//
//  User.swift
//  ChatApp
//
//  Created by Charlie Brush on 12/6/20.
//

struct UserDataResponse: Codable {
    var success: Bool
    var data: User2
}

struct User2: Codable {
    let id: Int
    let name: String
    let netid: String
    let socialAccount: String
    let eventCreated: [Event2]
    let eventInterested: [Event2]
    let friend: [User2]
  //  let password: String
}


struct User: Codable {
    var netid: String
    var name: String
    var password: String
 //   var image: String
    var socialAccount: String
    var friends: [User]?
    var eventInterested: [Event]?
    var eventCreated: [Event]?
    var favs: [Event]?
    var id: Int?
    

    init(netid: String, name: String, password: String, socialAccount: String = "None", id: Int = 0) {
        self.netid = netid
        self.name = name
        self.password = password
    //    self.image = image
        self.friends = []
        self.eventInterested = []
        self.favs = []
        self.eventCreated = []
        self.socialAccount = socialAccount
        self.id = id
    }
    
    init(user2: User2) {
        self.netid = user2.netid
        self.name = user2.name
       // self.password = user2.password
    //    self.image = image
        var l: [User] = []
        for i in user2.friend {
            l.append(User(user2: i))
        }
        self.friends = l
        var k: [Event] = []
        for i in user2.eventInterested {
            k.append(Event(event2: i))
        }
        self.eventInterested = k
       // self.eventInterested = user2.eventInterested
        self.favs = []
        var g: [Event] = []
        for i in user2.eventCreated {
            g.append(Event(event2: i))
        }
        self.eventCreated = g
       // self.eventCreated = user2.eventCreated
        self.socialAccount = user2.socialAccount
        self.id = user2.id
        
        self.eventCreated = []
        self.eventInterested = []
        self.password = "pass"
    }
    

}
