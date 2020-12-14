//
//  UserCollectionViewCell.swift
//  ChatApp
//
//  Created by Charlie Brush on 12/8/20.
//

import UIKit
import SnapKit

class UserCollectionViewCell: UICollectionViewCell {
    
    
    var userLabel: UILabel!
    var addButton: UIButton!
    var isOn: Bool!
    var user: User!
    weak var delegate: UserCollection?
    var friends: [User]!
    
    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.layer.cornerRadius = 5

        contentView.backgroundColor = barColor
        
        userLabel = UILabel()
        userLabel.textColor = .white
        userLabel.translatesAutoresizingMaskIntoConstraints = false
        userLabel.font = .systemFont(ofSize: 14)
        contentView.addSubview(userLabel)
        
        
        addButton = UIButton()
        addButton.setTitle("add", for: .normal)
        addButton.titleLabel?.adjustsFontSizeToFitWidth = true
        addButton.setTitleColor(buttonLabelColor, for: .normal)
        addButton.translatesAutoresizingMaskIntoConstraints = false
        addButton.backgroundColor = buttonColor
        addButton.layer.cornerRadius = 5
        addButton.addTarget(self, action: #selector(addTapped), for: .touchUpInside)
        contentView.addSubview(addButton)
        
        

        
        
        
        setupConstraints()
    }
    
    func setupConstraints() {
        let offset: CGFloat = 10
        
        userLabel.snp.makeConstraints{make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().offset(offset)
            make.height.equalTo(contentView.frame.height-2*offset)
            make.width.equalTo(contentView.frame.width*2/3)
        }
        
        addButton.snp.makeConstraints{make in
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview()
            make.height.equalTo(contentView.frame.height)
            make.width.equalTo(40)
            
        }
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(for user: User) {
        self.user = user
        userLabel.text = user.name
        friends = delegate?.getFriends()
        isOn=false
        var pos=0
        if let f = friends {
            for i in f {
                if i.netid==user.netid {
                    addButton.backgroundColor = eventColor
                    isOn=true
                }
                pos+=1
            }
        }
        if isOn==false {
            addButton.backgroundColor = buttonColor
        }

    }
    
    @objc func addTapped() {
        if isOn==false {
            addButton.backgroundColor = eventColor
            delegate?.setFriend(i: user)
        }
    }
}

