//
//  FilterCollectionViewCell.swift
//  MeetInEvent
//
//  Created by Gloria Cai on 12/8/20.
//  Copyright © 2020 Gloria Cai. All rights reserved.
//

import UIKit
import SnapKit

class FilterCollectionViewCell: UICollectionViewCell {
    var filterLabel: UILabel!
    let myColor =  UIColor(red: 151/255, green: 136/255, blue: 206/255, alpha: 1.0)

    override init(frame: CGRect) {
            super.init(frame: frame)
            filterLabel = UILabel()
            filterLabel.translatesAutoresizingMaskIntoConstraints = false

        filterLabel.layer.borderColor = myColor.cgColor
        filterLabel.font = .systemFont(ofSize: 22)

        filterLabel.layer.cornerRadius = 5.0
         filterLabel.layer.borderWidth = 2.0
        contentView.addSubview(filterLabel)
            
            setupConstraints()
        }
        
        func setupConstraints() {
//            NSLayoutConstraint.activate([
//                filterLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 3),
//                filterLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant:8),
//                filterLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
//                filterLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -3)
//            ])
            filterLabel.snp.makeConstraints{ make in
                make.centerX.equalToSuperview()
                make.centerY.equalToSuperview()

            }
        }
        
        func configure(for filter: Tag) {
            filterLabel.text = filter.tag
            filterLabel.textAlignment = .center
            if(filter.isOn)
            {
                filterLabel.backgroundColor = myColor
                filterLabel.textColor = .white
            }
            else{
                filterLabel.backgroundColor = .white
                filterLabel.textColor = myColor
            }
            
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
    }

    

