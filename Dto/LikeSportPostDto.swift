//
//  LikeSportPostDto.swift
//  BetLead-Sport
//
//  Created by Andy Chen on 2019/8/8.
//  Copyright © 2019 lismart. All rights reserved.
//

import Foundation


class LikeSportDto:Codable {
    let sport_id:Int
    let competitions:[CompetitionPosDto]
}

class CompetitionPosDto:Codable {
    let competition_id:Int
    init(competition_id:Int){
        self.competition_id = competition_id
    }
}

class LikeSportPostDto:Codable {
    let sport_id:String
    let competitions:[CompetitionPosDto]
    init(sport_id:String , competitions:[CompetitionPosDto]) {
        self.sport_id = sport_id
        self.competitions = competitions
    }
}


extension LikeSportDto {
    func transToLikeSportPostDto() -> LikeSportPostDto {
        return LikeSportPostDto(sport_id: "\(sport_id)", competitions: competitions)
    }
    
}

extension LikeSportPostDto {
    func toDict() -> [String:Any] {
        return ["sport_id":sport_id ,
                "competitions":competitions.map{["competition_id":$0.competition_id.toString()]}]
    }
}
