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
    var friends: [User]?
    var events: [Event]?
    var favs: [Event]?

    init(username: String, displayname: String, password: String, image: String = "blankprofile") {
        self.username = username
        self.displayname = displayname
        self.password = password
        self.image = image
        self.friends = []
        self.events = []
        self.favs = []
    }

}
