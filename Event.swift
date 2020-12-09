//
//  Event.swift
//  ChatApp
//
//  Created by Charlie Brush on 12/6/20.
//

import Foundation

class Event {
    var name: String
    var image: String
    var desc: String
    var date: Date
    var people: [User]
    var creator: User
    var max: Int

    init(name: String, desc: String, date: Date, creator: User, people: [User], max: Int = 10, image: String = "blank") {
        self.name = name
        self.image = image
        self.desc = desc
        self.date = date
        self.people = people
        self.creator = creator
        self.max = max
    }
}


class Date {
    var year: Int
    var mon: Int
    var day: Int
    var hour: Int
    var min: Int
    var suf: String

    init(year: Int, mon: Int, day: Int, hour: Int, min: Int, suf: String) {
        self.year = year
        self.mon = mon
        self.day = day
        self.hour = hour
        self.min = min
        self.suf = suf
    }
    
    func getDate() -> String {
        if min<10 {
            return "\(months[mon]) \(day), \(hour):0\(min) \(suf)"
        }
        else {
            return "\(months[mon]) \(day), \(hour):\(min) \(suf)"
        }
    }
    
    func lessthan(other: Date) -> Bool {
        if self.year==other.year {
            if self.mon==other.mon {
                if self.day==other.day {
                    if self.hour==other.hour {
                        if self.min==other.min{
                            return false
                        }
                        return self.min<other.min
                    }
                    return self.hour<other.hour
                }
                return self.day<other.day
            }
            return self.mon<other.mon
        }
        return self.year<other.year
    }
    
    
    
}
