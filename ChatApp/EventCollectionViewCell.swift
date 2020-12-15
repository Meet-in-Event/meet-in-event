//
//  EventCollectionViewCell.swift
//  ChatApp
//
//  Created by Charlie Brush on 12/6/20.
//

import UIKit

let months = ["January","February","March","April","May","June","July","August","September","October","November","December"]

class EventCollectionViewCell: UICollectionViewCell {
    
    
    var imageView: UIImageView!
    var nameLabel: UILabel!
    var dateLabel: UILabel!
    var locationLabel: UILabel!
    var star: UIButton!
    var user: User!
    var isFav: Bool!
    var favs: [Event]?
    var event: Event!
    
    weak var delegate: View?
    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = eventColor
        contentView.layer.cornerRadius = 10

        
        imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.clipsToBounds = true
        imageView.layer.masksToBounds = true
        imageView.contentMode = .scaleAspectFill
        
        
        
        
        

        imageView.layer.cornerRadius = 10
        contentView.addSubview(imageView)
        
        nameLabel = UILabel()
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.font = .systemFont(ofSize: 20)
        nameLabel.textColor = labelColor
        contentView.addSubview(nameLabel)
        
        dateLabel = UILabel()
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        dateLabel.font = .systemFont(ofSize: 15)
        dateLabel.textColor = labelColor
        contentView.addSubview(dateLabel)
        
        locationLabel = UILabel()
        locationLabel.translatesAutoresizingMaskIntoConstraints = false
        locationLabel.font = .systemFont(ofSize: 15)
        locationLabel.textColor = labelColor
        contentView.addSubview(locationLabel)
        
        star = UIButton()
        star.setImage(UIImage(named: "star"), for: .normal)
        star.translatesAutoresizingMaskIntoConstraints = false
        star.backgroundColor = eventColor
        star.layer.cornerRadius = 5
        star.addTarget(self, action: #selector(starTapped), for: .touchUpInside)
        contentView.addSubview(star)
        
        
        
        setupConstraints()
    }
    
    func setupConstraints() {
        
        let offset: CGFloat = 5
        let width: CGFloat = contentView.frame.width
        
        imageView.snp.makeConstraints{make in
            make.height.equalTo(125)
            make.width.equalTo(width)
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.top.equalToSuperview()
        }
        
        nameLabel.snp.makeConstraints{make in
            make.leading.equalToSuperview().offset(offset)
            make.top.equalTo(imageView.snp.bottom).offset(offset)
            make.height.equalTo(25)
        }
        
        dateLabel.snp.makeConstraints{make in
            make.leading.equalToSuperview().offset(offset)
            make.top.equalTo(nameLabel.snp.bottom)
            make.height.equalTo(20)
        }
        
        locationLabel.snp.makeConstraints{make in
            make.leading.equalToSuperview().offset(offset)
            make.top.equalTo(dateLabel.snp.bottom)
            make.height.equalTo(20)
        }
        
        star.snp.makeConstraints{make in
            make.top.equalToSuperview()
            make.leading.equalToSuperview()
            make.height.width.equalTo(30)
        }
       

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func starTapped() {
        if isFav==false {
            star.setImage(UIImage(named: "star2"), for: .normal)
            delegate?.setFav(i: event)
        }
        else {
            star.setImage(UIImage(named: "star"), for: .normal)
            delegate?.removeFav(i: event)
        }
    }
    
    
    
    func configure(for event: Event) {
        nameLabel.text = event.name
        dateLabel.text = event.date.getDate()
        locationLabel.text = event.location
        imageView.image = UIImage(named: event.image)
        self.isFav=false
        self.user = delegate?.getUser()
        //self.favs = user.favs
        self.event = event
      //  print(user.favs)
        if let f = user.favs {
            var pos = 0
            for i in f {
                if i.name==event.name {
                    self.isFav=true
                    star.setImage(UIImage(named: "star2"), for: .normal)
                }
                pos+=1
            }
        }
        if self.isFav==false {
            star.setImage(UIImage(named: "star"), for: .normal)
        }
        print(self.isFav)
        
        
    }
}
