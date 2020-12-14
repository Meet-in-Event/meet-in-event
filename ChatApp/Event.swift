//
//  Event.swift
//  ChatApp
//
//  Created by Charlie Brush on 12/6/20.
//

struct EventsDataResponse: Codable {
    var success: Bool
    var events: [Event2]
}

struct Event2: Codable {
    let title: String
    let location: String
    let time: Date
    let description: String
    let publicity: Bool
    let people: [User]
    let creator: User
}

struct Event: Codable {
    var name: String
    var image: String
    var desc: String
    var date: Date
    var people: [User]
    var creator: User
    var location: String
    var publ: Bool
    var tags: [Tag]!

    init(name: String, desc: String, date: Date, creator: User, location: String, people: [User] = [], publ: Bool = true, image: String = "blank") {
        self.name = name
        self.image = image
        self.desc = desc
        self.date = date
        self.people = people
        self.creator = creator
        self.location = location
        self.publ = publ
    }
}


class Date: Codable {
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
