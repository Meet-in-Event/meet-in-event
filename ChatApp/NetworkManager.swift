//
//  NetworkManager.swift
//  ChatApp
//
//  Created by Charlie Brush on 12/12/20.
//

import Foundation
import Alamofire

class NetworkManager {

    private static let host = "http://0.0.0.0:5000"
    
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
          //      print("-")
                print(String(decoding: data, as: UTF8.self))

                let jsonDecoder = JSONDecoder()
                jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
                if let userData = try? jsonDecoder.decode(UserDataResponse.self, from: data) {
                  //  print(userData.data)
                    completion(userData.data, u)
                    
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    static func getUser(netid: String, completion: @escaping (User2) -> Void) {
        let endpoint = "\(host)/api/event/\(netid)/"
        AF.request(endpoint, method: .get).validate().responseData { response in
            switch response.result {
            case .success(let data):
                let jsonDecoder = JSONDecoder()
                jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
                if let userData = try? jsonDecoder.decode(UserDataResponse.self, from: data) {
                    completion(userData.data)
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    
    static func getEvents(completion: @escaping ([Event2]) -> Void) {
        let endpoint = "\(host)/api/event/"
        AF.request(endpoint, method: .get).validate().responseData { response in
            switch response.result {
            case .success(let data):
                let jsonDecoder = JSONDecoder()
                jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
                if let eventsData = try? jsonDecoder.decode(EventsDataResponse.self, from: data) {
                    completion(eventsData.events)
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }

    static func createEvent(e: Event, user: User) {
        let parameters: [String: Any] = [
            "title": e.name,
            "location": e.location,
            //date object??
            "time": e.date.getDate(),
            "description": e.desc,
            "publicity": e.publ
            //creator?

        ]
        let endpoint = "\(host)/api/event/\(user.netid)/"
        AF.request(endpoint, method: .post, parameters: parameters, encoding: JSONEncoding.default).validate().responseData { response in
            switch response.result {
            case .success(let data):
                let jsonDecoder = JSONDecoder()
                jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
//                if let eventsData = try? jsonDecoder.decode(EventsDataResponse.self, from: data) {
//                    completion(eventsData)
//                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }

}
