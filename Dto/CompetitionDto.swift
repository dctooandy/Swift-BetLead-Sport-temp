//
//  CompetitionDto.swift
//  BetLead-Sport
//
//  Created by Andy Chen on 2019/8/13.
//  Copyright © 2019 lismart. All rights reserved.
//

import Foundation


class CompetitionDto:Codable {
    let sportId:Int
    let sportName:String
    let groups:[CompetitionGroupDto]
}

class CompetitionGroupDto:Codable {
    let groupId:Int
    let groupName:String
    let sortOrder:Int
    let competitions:[CompetitionInfoDto]
    
}

class CompetitionInfoDto:Codable,Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(competitionId)
    }
    
    static func == (lhs: CompetitionInfoDto, rhs: CompetitionInfoDto) -> Bool {
        return lhs.competitionId == rhs.competitionId
    }
    
    let competitionId:Int
    let competitionName:String
}
