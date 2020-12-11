//
//  Friends.swift
//  ChatApp
//
//  Created by Charlie Brush on 12/10/20.
//

import UIKit
import SnapKit

class Friends: UIViewController {
    
    var tableView: UITableView!
    
    var currentFriend: User!
    var currentIndex: Int!
//    var currentCell: FriendTableViewCell!
    
    let reuseIdentifier = "friendCellReuse"
    
    var user: User!
    var friends: [User]!
    
    var add: UIBarButtonItem!
    
    weak var delegate: Profile?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = backColor
        title = "Friends"
        self.navigationController?.navigationBar.barTintColor = barColor
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        
        user = self.delegate?.getUser()
        self.friends = user.friends
        
        tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(FriendTableViewCell.self, forCellReuseIdentifier: reuseIdentifier)
        tableView.backgroundColor = backColor
        view.addSubview(tableView)
        

        setupConstraints()
        
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
}

extension Friends: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return friends.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! FriendTableViewCell
        let friend = friends[indexPath.row]
        cell.configure(for: friend)
        cell.backgroundColor = backColor
        return cell
    }
    
}

extension Friends: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }

    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        currentFriend = friends[indexPath.row]
//        currentIndex = indexPath.row
        let cell = tableView.cellForRow(at: indexPath) as! FriendTableViewCell
        cell.backgroundColor = eventColor
//        currentCell = cell
        
//        let newViewController = EditData()
//        newViewController.delegate = self
//        navigationController?.pushViewController(newViewController, animated: true)
    }
    
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        currentIndex = indexPath.row
        currentFriend = friends[currentIndex]
        self.delegate?.removeFriend(i: currentIndex)
        friends.remove(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .fade)
    }
    

}





