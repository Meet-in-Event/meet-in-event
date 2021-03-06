//
//  FilterType.swift
//  MeetInEvent
//
//  Created by Gloria Cai on 12/8/20.
//  Copyright © 2020 Gloria Cai. All rights reserved.
//

class Tag: Codable, Equatable {
    static func == (lhs: Tag, rhs: Tag) -> Bool {
        return lhs.tag == rhs.tag
    }

    
    var tag: String
    var isOn: Bool
    var pos: Int

    init(tag: String) {
        self.tag = tag
        self.isOn = false
        self.pos = -1
    }
}

