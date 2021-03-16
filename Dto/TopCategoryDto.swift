//
//  TopCategoryDto.swift
//  BetLead-Sport
//
//  Created by Andy Chen on 2019/8/1.
//  Copyright © 2019 lismart. All rights reserved.
//

import Foundation

class CategoryDto:Codable {
    let earlyMenuItems:CategoryDetailDto
    let inPlayMenuItems:CategoryDetailDto
    let parlayMenuItems:CategoryDetailDto
    let todayMenuItems:CategoryDetailDto
}

class CategoryDetailDto:Codable {
    let pageTypeId:String
    let pageTypeName:String
    let allEventCount:Int
    let sports:[SportDto]
    
    var sortedSportById:[SportDto] {
        return sports.sorted(by: { (old, new) -> Bool in
            old.sportId < new.sportId
        })
    }
    
}

class SportDto:Codable {
    let sportId:Int
    let sportName:String
    let eventCount:Int
    let hasInPlayEvent:Bool
    var countLabelColor:UIColor {
        return eventCount == 0 ? Themes.unSelectedGray : .red
    }
}

extension SportDto {
    func transToSportType() -> SportTypeDto {
        return SportTypeDto(value: self.sportId, display: self.sportName, enDisplay: "loss Eng info during transfer")
    }
}
