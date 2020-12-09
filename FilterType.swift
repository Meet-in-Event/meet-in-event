//
//  FilterType.swift
//  MeetInEvent
//
//  Created by Gloria Cai on 12/8/20.
//  Copyright © 2020 Gloria Cai. All rights reserved.
//

class FilterType{
    var filtertype: String = ""
    var isSelected: Bool = false
    init(filtertype: String, isSelected: Bool){
        self.filtertype = filtertype
        self.isSelected = isSelected
    }
}
