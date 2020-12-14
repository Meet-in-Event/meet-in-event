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
    let eventCreated: [Event]
    let eventInterested: [Event]
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

}
