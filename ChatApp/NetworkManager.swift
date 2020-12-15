//
//  NetworkManager.swift
//  ChatApp
//
//  Created by Charlie Brush on 12/12/20.
//

import Foundation
import Alamofire

class NetworkManager {

    private static let host = "https://meet-in-event.herokuapp.com"
    
    static func createUser(u: User, completion: @escaping (User2, User) -> Void) {
        let parameters: [String: Any] = [
            "name": u.name,
            "netid": u.netid,
            "social_account": u.socialAccount,
            "password": u.password
        ]
        
        let endpoint = "\(host)/api/users/"
        AF.request(endpoint, method: .post, parameters: parameters, encoding: JSONEncoding.default).validate().responseData { response in

            switch response.result {
            case .success(let data):
                print(String(decoding: data, as: UTF8.self))

                let jsonDecoder = JSONDecoder()
                jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
                if let userData = try? jsonDecoder.decode(UserDataResponse.self, from: data) {
                    print("creating user")
                    completion(userData.data, u)
                    
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    static func getUser(netid: String, completion: @escaping (User2) -> Void) {
        let endpoint = "\(host)/api/users/\(netid)/"
        AF.request(endpoint, method: .get).validate().responseData { response in
            switch response.result {
            case .success(let data):
                print(String(decoding: data, as: UTF8.self))
                let jsonDecoder = JSONDecoder()
                jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
                if let userData = try? jsonDecoder.decode(UserDataResponse.self, from: data) {
                    print("getting user")
                    print(userData)
                    completion(userData.data)
                    
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    
    static func getEvents(completion: @escaping ([Event2]) -> Void) {
        let endpoint = "\(host)/api/events/"
        AF.request(endpoint, method: .get).validate().responseData { response in
            switch response.result {
            case .success(let data):
                let jsonDecoder = JSONDecoder()
                jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
                if let eventsData = try? jsonDecoder.decode(EventsDataResponse.self, from: data) {
                    print("getting all events")
                    completion(eventsData.events)
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }

    static func createEvent(e: Event, user: User, completion: @escaping (Event2) -> Void) {
        let parameters: [String: Any] = [
            "title": e.name,
            "location": e.location,
            "time": e.date.getTimeStamp(),
            "description": e.desc,
            "publicity": e.getPublicity(),
            "Tags": e.getTags()

        ]
        print(parameters)
        let endpoint = "\(host)/api/event/\(user.netid)/"
        AF.request(endpoint, method: .post, parameters: parameters, encoding: JSONEncoding.default).validate().responseData { response in
            switch response.result {
            case .success(let data):
                let jsonDecoder = JSONDecoder()
                jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
                if let eventData = try? jsonDecoder.decode(Event2.self, from: data) {
                    completion(eventData)
                }
            
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    
    static func deleteEvent(e: Event) {
        let endpoint = "\(host)/api/events/\(e.id)/"
        AF.request(endpoint, method: .delete).validate().responseData { response in
            switch response.result {
            case .success(let data):
                let jsonDecoder = JSONDecoder()
                jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase

            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    static func signUp(e: Event, user: User) {
        let parameters: [String: Any] = [
            "user_netid": user.netid
        ]
        let endpoint = "\(host)/api/interestevent/\(e.id)/"
        AF.request(endpoint, method: .post, parameters: parameters, encoding: JSONEncoding.default).validate().responseData { response in
            switch response.result {
            case .success(let data):
                let jsonDecoder = JSONDecoder()
                jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase

            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    static func removeSignUp(e: Event, user: User) {
        let parameters: [String: Any] = [
            "user_netid": user.netid
        ]
        let endpoint = "\(host)/api/event/\(e.id)/"
        AF.request(endpoint, method: .delete, parameters: parameters, encoding: JSONEncoding.default).validate().responseData { response in
            switch response.result {
            case .success(let data):
                let jsonDecoder = JSONDecoder()
                jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase

            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    

}
