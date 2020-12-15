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

    override init(frame: CGRect) {
            super.init(frame: frame)
            filterLabel = UILabel()
            filterLabel.translatesAutoresizingMaskIntoConstraints = false
        
        filterLabel.font = .systemFont(ofSize: 22)

        contentView.layer.cornerRadius = 5
        contentView.addSubview(filterLabel)
            
            setupConstraints()
        }
        
        func setupConstraints() {

            filterLabel.snp.makeConstraints{ make in
                make.centerX.equalToSuperview()
                make.centerY.equalToSuperview()

            }
        }
        
    func configure(for filter: Tag, color1: UIColor, color2: UIColor) {
            filterLabel.text = filter.tag
           // filterLabel.textAlignment = .center
            if(filter.isOn)
            {
                contentView.backgroundColor = color2
                filterLabel.textColor = .white
            }
            else{
                contentView.backgroundColor = color1
                filterLabel.textColor = .black
            }
            
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
    }





    


