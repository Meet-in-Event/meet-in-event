//
//  FriendTableViewCell.swift
//  ChatApp
//
//  Created by Charlie Brush on 12/10/20.
//

import UIKit

class FriendTableViewCell: UITableViewCell {
    var nameLabel: UILabel!
    var socialLabel: UILabel!
    var profileImage: UIImageView!
        
    var imageName: String!
    
  //  weak var delegate: Fr?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = backColor
        
        selectionStyle = .none
        
        
        nameLabel = UILabel()
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.font = .systemFont(ofSize: 20, weight: .bold)
        nameLabel.textColor = labelColor
        contentView.addSubview(nameLabel)
        
        socialLabel = UILabel()
        socialLabel.translatesAutoresizingMaskIntoConstraints = false
        socialLabel.font = .systemFont(ofSize: 20)
        socialLabel.textColor = labelColor
        contentView.addSubview(socialLabel)
        
        
        profileImage = UIImageView()
        profileImage.translatesAutoresizingMaskIntoConstraints = false
        profileImage.contentMode = .scaleAspectFit
        contentView.addSubview(profileImage)

        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupConstraints() {
        
        let padding: CGFloat = 8
        let offset: CGFloat = 10
        let labelHeight: CGFloat = 16
        
        profileImage.snp.makeConstraints{make in
            make.height.width.equalTo(90)
            make.leading.equalToSuperview().offset(5)
            make.centerY.equalToSuperview()
        }
        
        nameLabel.snp.makeConstraints{make in
            make.leading.equalTo(profileImage.snp.trailing).offset(offset)
            make.top.equalToSuperview().offset(padding+5)
            make.height.equalTo(labelHeight)
        }
        
        socialLabel.snp.makeConstraints{make in
            make.leading.equalTo(profileImage.snp.trailing).offset(offset)
            make.top.equalTo(nameLabel.snp.bottom).offset(padding)
            make.height.equalTo(labelHeight)
        }

    }
    
    
    func configure(for friend: User) {
        nameLabel.text = friend.name
        socialLabel.text = friend.socialAccount
        profileImage.image = UIImage(named: "blankprofile")
        
    //    delegate?.getColor(u: friend)

    }
}
