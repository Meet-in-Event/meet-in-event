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
    let time: Int
    let description: String
    let publicity: Bool
    let people: [User]
    let creator: User
    let tag: [String]
    let id: Int
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
    var id: Int

    init(name: String, desc: String, date: Date, creator: User, location: String, tags: [Tag] = [], people: [User] = [], publ: Bool = true, image: String = "blank") {
        self.name = name
        self.image = image
        self.desc = desc
        self.date = date
        self.people = people
        self.creator = creator
        self.location = location
        self.publ = publ
        self.id = 0
        self.tags = tags
    }
    
    init(event2: Event2) {
        self.name = event2.title
//        self.image = image
        self.desc = event2.description
        
        //turn this into a date object
        //self.date = event2.time
      //  self.people = event2.people
//        var l: [User] = []
//        for i in event2.people {
//            l.append(User(user2: i))
//        }
        self.people = event2.people
     //   self.people = l
       // self.creator = User(user2: event2.creator)
        self.creator = event2.creator
        self.location = event2.location
        self.publ = event2.publicity
        self.image = "blank"
        self.id = event2.id
        
        var l: [Tag] = []
        for i in event2.tag {
            l.append(Tag(tag: i))
        }
        self.tags = l
        
        self.date = Date.decodeTimeStamp(i: event2.time)
        
    }
    
    func getTags() -> [String] {
        var l: [String] = []
        for i in self.tags {
            l.append(i.tag)
        }
        return l
    }
    
    func getPublicity() -> String {
        if self.publ {
            return "True"
        }
        return "False"
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
    
    func getTimeStamp() -> Int {
        //year?
        if self.suf == "AM" {
            return (self.mon+1)*1000000 + self.day*10000 + self.hour*100 + self.min
        }
        else {
            return (self.mon+1)*1000000 + self.day*10000 + (self.hour+12)*100 + self.min
        }
    }
    
    static func decodeTimeStamp(i: Int) -> Date {
        var time = i
        var mon = 0
        var day = 0
        var hour = 0
        var min = 0
        mon = time/1000000
        time-=1000000*mon
        day = time/10000
        time-=10000*day
        hour = time/100
        time-=100*hour
        min = time
        if hour>12 {
            return (Date(year: 21, mon: mon-1, day: day, hour: hour-12, min: min, suf: "PM"))
        }
        else {
            return (Date(year: 21, mon: mon-1, day: day, hour: hour, min: min, suf: "AM"))
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
