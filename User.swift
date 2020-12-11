//
//  User.swift
//  ChatApp
//
//  Created by Charlie Brush on 12/6/20.
//

import Foundation

class User {
    var username: String
    var displayname: String
    var password: String
    var image: String
    var social: String
    var friends: [User]?
    var events: [Event]?
    //should this rather be a list of ints, and a get event function added?
    var createdEvents: [Event]?
    var favs: [Event]?

    init(username: String, displayname: String, password: String, social: String = "None", image: String = "blankprofile") {
        self.username = username
        self.displayname = displayname
        self.password = password
        self.image = image
        self.friends = []
        self.events = []
        self.favs = []
        self.createdEvents = []
        self.social = social
    }

}
