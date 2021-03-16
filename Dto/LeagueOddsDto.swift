//
//  OddsListDto.swift
//  BetLead-Sport
//
//  Created by Andy Chen on 2019/8/5.
//  Copyright © 2019 lismart. All rights reserved.
//

import Foundation

typealias LeagueOddsDict = [String:[LeagueOddsDto]]

class LeagueOddsDto:Codable {
    let events:[OddsDto]
    let competitionId:Int
    let competitionName:String
    let eventCount:Int
    var eventsWithCompetitioName:[OddsWithCompetitionNameDto]{
        return events.map{OddsWithCompetitionNameDto(competitionName: competitionName, oddsDto: $0)}
    }
}

class OddsDto:Codable {
    let eventGroupId:Int
    let eventGroundType:String
    let information:OddsInfoDto
    let eventId:Int
    let isInPlay:Bool
    let isParlay:Bool
    let homeTeamWin:OddsValueDto
    let awayTeamWin:OddsValueDto
    let evenTeamWin:OddsValueDto
    let handicapHomeTeam:WinsValueDto
    let handicapAwayTeam:WinsValueDto
    var homeTeamScore:String {
        return isInPlay ? information.homeTeamInPlayScore: ""
    }
    var awayTeamScore:String {
        return isInPlay ? information.awayTeamInPlayScore: ""
    }
    var score:String? {
        return isInPlay ? "\(information.homeTeamInPlayScore):\(information.awayTeamInPlayScore)" : nil
    }
    init(oddsDto:OddsDto) {
        self.eventGroupId = oddsDto.eventGroupId
        self.eventGroundType = oddsDto.eventGroundType
        self.information = oddsDto.information
        self.eventId = oddsDto.eventId
        self.isInPlay = oddsDto.isInPlay
        self.isParlay = oddsDto.isParlay
        self.homeTeamWin = oddsDto.homeTeamWin
        self.awayTeamWin = oddsDto.awayTeamWin
        self.evenTeamWin = oddsDto.evenTeamWin
        self.handicapHomeTeam = oddsDto.handicapHomeTeam
        self.handicapAwayTeam = oddsDto.handicapAwayTeam
    }
}
class OddsWithCompetitionNameDto:OddsDto {
    let competitionName:String
    init (competitionName:String,oddsDto:OddsDto ){
        self.competitionName = competitionName
        super.init(oddsDto:oddsDto)
    }
    
    required init(from decoder: Decoder) throws {
        fatalError("init(from:) has not been implemented")
    }
    
}

class OddsInfoDto:Codable {
    let homeTeamName:String
    let awayTeamName:String
    let moreOddsCount:String
    let isLiveShow:String
    let eventDate:String
    let eventTime:String
    let moreBetTypeCount:String
    let isBet:String
    let homeTeamRedCard:String
    let awayTeamRedCard:String
    let homeTeamScore:String
    let awayTeamScore:String
    let periodText:String
    let isToday:String
    let mainGameId:String
    let homeTeamLastScore:String?
    let awayTeamLastScore:String?
    let eventPeriodType:Int
    let isScoreBoard:String
    let homeTeamImage:String
    let awayTeamImage:String
    
    var homeTeamInPlayScore:String {
        return homeTeamScore.isEmpty ? "0" :  homeTeamScore
    }
    var awayTeamInPlayScore:String {
        return awayTeamScore.isEmpty ? "0" :  awayTeamScore
    }
    var dateWithoutSpacing:String {
        return eventDate.replacingOccurrences(of: " ", with: "")
    }
    var betDate:String {
        let calendar = Calendar.current
        let year = calendar.component(.year, from: Date())
        return "\(year.toString())/\(eventDate.removeSpacing) \(eventTime)"
    }
    var homeTeamUrl:URL? {
        return URL(string: homeTeamImage.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")
    }
    var awayTeamUrl:URL? {
        return URL(string: awayTeamImage.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")
    }
    
}

class OddsValueDto:Codable {
   
    let name:String 
    let oddsTitle:String
    let orderid:String
    let oddvalue:String
    var isLock:Bool {
        return oddvalue.isEmpty || oddvalue.digits.allSatisfy{$0 == "0"}
    }
    var selectionId:String {
        return orderid.digits
    }
}

class WinsValueDto:Codable {
    let name:String
    let oddsTitle:String
    let orderid:String
    let handicap:String
    let oddvalue:String
    var selectionId:String {
        return orderid.digits
    }
    var isLock:Bool {
        return oddvalue.isEmpty || oddvalue.digits.allSatisfy{$0 == "0"}
    }
}

extension Array where Element:LeagueOddsDto {
    
    func getSortedOddsDto() -> [OddsDto] {
        var result = [OddsDto]()
       return flatMap{$0.events}.sorted { (old , new) -> Bool in
            return old.information.eventTime < new.information.eventTime
        }
    }
}
