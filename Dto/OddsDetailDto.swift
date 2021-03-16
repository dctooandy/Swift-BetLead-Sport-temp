//
//  OddsDetailDto.swift
//  BetLead-Sport
//
//  Created by Andy Chen on 2019/8/16.
//  Copyright © 2019 lismart. All rights reserved.
//

import Foundation

class OddsDetailDto:Codable {
    let information:OddsDetailInfoDto
    let competitionId:Int
    let competitionName:String
    let events:[OddsDetailEventDto]
    var score:String {
        return "\((information.homeTeamScore ?? 0).toString()):\((information.awayTeamScore ?? 0).toString())"
    }
    
}

class OddsDetailInfoDto:Codable {
    let eventDate:String
    let eventTime:String
    let liveShowUrl:String?
    let homeTeamScore:Int?
    let awayTeamScore:Int?
    let isInPlay:Bool
}

class OddsDetailEventDto:Codable {
    let eventId:Int
    let commonOdds:[CommonOddsDto]?
    let propositionOdds:[CommonOddsDto]?
    let information:OddsDetailEventInfoDto
    var CommonOddsWithIdDtos:[CommonOddsWithIdDto] {
        return (commonOdds ?? []).map{CommonOddsWithIdDto(eventId: eventId, commonOddsDto: $0)} + (propositionOdds ?? []).map{CommonOddsWithIdDto(eventId: eventId, commonOddsDto: $0)}
    }
}

class OddsDetailEventInfoDto:Codable {
    let homeTeamName:String
    let awayTeamName:String
    let isLiveShow:String
    let eventDate:String
    let eventTime:String
    let isBet:String
    let homeTeamScore:String
    let awayTeamScore:String
    let homeTeamImage:String
    let awayTeamImage:String
    var homeTeamUrl:URL? {
        return URL(string: homeTeamImage.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")
    }
    var awayTeamUrl:URL? {
        return URL(string: awayTeamImage.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")
    }
}
class CommonOddsDto:Codable {
    let oddsMode:String?
    let name:String
    let oddsList:[OddValuesDto]
    var isWave:Bool {
        return oddsMode?.contains("cs") ?? false
    }
    init(oddsMode:String?,name:String,oddsList:[OddValuesDto]) {
        self.oddsMode = oddsMode
        self.name = name
        self.oddsList = oddsList
    }
    
}
 
class CommonOddsWithIdDto: CommonOddsDto{
    let eventId:Int
    init( eventId:Int , commonOddsDto:CommonOddsDto) {
        self.eventId = eventId
        super.init(oddsMode: commonOddsDto.oddsMode, name: commonOddsDto.name, oddsList: commonOddsDto.oddsList)
    }
    required init(from decoder: Decoder) throws {
        fatalError("init(from:) has not been implemented")
    }
    var oddValuesWithIdDto:[OddValuesWithIdDto] {
        return oddsList.map{ OddValuesWithIdDto(eventId: eventId, oddValuesDto: $0)}
    }
}
class OddValuesWithIdDto: OddValuesDto{
    let eventId:Int
    init( eventId:Int , oddValuesDto:OddValuesDto) {
        self.eventId = eventId
        super.init(orderId: oddValuesDto.orderId, hadicap: oddValuesDto.hadicap, ouValue: oddValuesDto.ouValue, oddValue: oddValuesDto.oddValue, oddTitle: oddValuesDto.oddTitle)
    }
    
    required init(from decoder: Decoder) throws {
        fatalError("init(from:) has not been implemented")
    }
    override func transOddTitleWith(homeTeamName:String , awayTeamName:String) -> OddValuesWithIdDto {
        guard self.oddTitle == "homeTeam" || self.oddTitle == "awayTeam" else { return self }
        let oddValuesDto = OddValuesDto(orderId: self.orderId, hadicap: self.hadicap, ouValue: self.ouValue, oddValue: self.oddValue,
                                        oddTitle: self.oddTitle == "homeTeam" ?  homeTeamName : awayTeamName)
        return OddValuesWithIdDto(eventId: eventId, oddValuesDto: oddValuesDto)
    }
}

class OddValuesDto:Codable {
    let orderId:String
    let hadicap:String?
    let ouValue:String?
    let oddValue:String
    let oddTitle:String
    var homeScore:Int {
        if oddTitle == "other" {return 999}
        return Int(String(oddTitle.split(separator: ":").first ?? "0")) ?? 0
    }
    var awayScore:Int {
        return Int(String(oddTitle.split(separator: ":").last ?? "0")) ?? 0
    }
    var disPlayTitle:String {
        if let hadicapStr = hadicap {
            return "\(hadicapStr)  |"
        }
        if let ouValueStr = ouValue {
            return "\(ouValueStr)  |"
        }
        return ""
    }
    var selectionId:String {
        return orderId.digits
    }
    var isLock:Bool {
        return oddValue.isEmpty || oddValue.digits.allSatisfy{$0 == "0"}
    }
    init(orderId:String ,hadicap:String?,ouValue:String?,oddValue:String ,oddTitle:String){
        self.orderId = orderId
        self.hadicap = hadicap
        self.ouValue = ouValue
        self.oddValue = oddValue
        self.oddTitle = oddTitle
    }
    
    func transOddTitleWith(homeTeamName:String , awayTeamName:String) -> OddValuesDto{
        guard self.oddTitle == "homeTeam" || self.oddTitle == "awayTeam" else { return self }
        return OddValuesDto(orderId: self.orderId, hadicap: self.hadicap, ouValue: self.ouValue, oddValue: self.oddValue,
                            oddTitle: self.oddTitle == "homeTeam" ?  homeTeamName : awayTeamName)
    }
    
}

extension Array where Element:OddValuesWithIdDto {
    
    func homeWin() -> [OddValuesWithIdDto] {
      return  filter{$0.homeScore > $0.awayScore}.sorted { (old , new) -> Bool in
            if old.homeScore == new.homeScore {
                return old.awayScore < new.awayScore
            }
            return old.homeScore < new.homeScore
        }
    }
    func draw() -> [OddValuesWithIdDto] {
        return filter{$0.homeScore == $0.awayScore}.sorted { (old , new) -> Bool in
            return old.homeScore < new.homeScore
        }
    }
    func awayWin() -> [OddValuesWithIdDto] {
        return  filter{$0.homeScore < $0.awayScore}.sorted { (old , new) -> Bool in
            if old.awayScore == new.awayScore {
                return old.homeScore < new.homeScore
            }
            return old.awayScore < new.awayScore
        }
    }
}





class MockOddsDetailDto:Codable {
//    let information:MockOddsDetailInfoDto
    let competitionId:Int
//    let competitionName:String
//    let events:[MockOddsDetailEventDto]
    
}

class MockOddsDetailInfoDto:Codable {
    let eventDate:String
    let eventTime:String
    let liveShowUrl:String?
    let homeTeamScore:String?
    let awayTeamScore:String?
    let isInPlay:Bool
}

class MockOddsDetailEventDto:Codable {
    let eventId:Int
    let commonOdds:[MockCommonOddsDto]?
    let propositionOdds:[MockCommonOddsDto]?
    let information:MockOddsDetailEventInfoDto
    var CommonOddsWithIdDtos:[MockCommonOddsWithIdDto] {
        return (commonOdds ?? []).map{MockCommonOddsWithIdDto(eventId: eventId, commonOddsDto: $0)} + (propositionOdds ?? []).map{MockCommonOddsWithIdDto(eventId: eventId, commonOddsDto: $0)}
    }
}

class MockOddsDetailEventInfoDto:Codable {
    let homeTeamName:String
    let awayTeamName:String
    let isLiveShow:String
    let eventDate:String
    let eventTime:String
    let isBet:String
    let homeTeamScore:String
    let awayTeamScore:String
}
class MockCommonOddsDto:Codable {
    let oddsMode:String?
    let name:String
    let oddsList:[MockOddValuesDto]
    var isWave:Bool {
        return oddsMode?.contains("cs") ?? false
    }
    init(oddsMode:String?,name:String,oddsList:[MockOddValuesDto]) {
        self.oddsMode = oddsMode
        self.name = name
        self.oddsList = oddsList
    }
    
}

class MockCommonOddsWithIdDto: MockCommonOddsDto{
    let eventId:Int
    init( eventId:Int , commonOddsDto:MockCommonOddsDto) {
        self.eventId = eventId
        super.init(oddsMode: commonOddsDto.oddsMode, name: commonOddsDto.name, oddsList: commonOddsDto.oddsList)
    }
    required init(from decoder: Decoder) throws {
        fatalError("init(from:) has not been implemented")
    }
    var oddValuesWithIdDto:[MockOddValuesWithIdDto] {
        return oddsList.map{ MockOddValuesWithIdDto(eventId: eventId, oddValuesDto: $0)}
    }
}
class MockOddValuesWithIdDto: MockOddValuesDto{
    let eventId:Int
    init( eventId:Int , oddValuesDto:MockOddValuesDto) {
        self.eventId = eventId
        super.init(orderId: oddValuesDto.orderId, hadicap: oddValuesDto.hadicap, ouValue: oddValuesDto.ouValue, oddValue: oddValuesDto.oddValue, oddTitle: oddValuesDto.oddTitle)
    }
    
    required init(from decoder: Decoder) throws {
        fatalError("init(from:) has not been implemented")
    }
    override func transOddTitleWith(homeTeamName:String , awayTeamName:String) -> MockOddValuesWithIdDto {
        guard self.oddTitle == "homeTeam" || self.oddTitle == "awayTeam" else { return self }
        let oddValuesDto = MockOddValuesDto(orderId: self.orderId, hadicap: self.hadicap, ouValue: self.ouValue, oddValue: self.oddValue,
                                        oddTitle: self.oddTitle == "homeTeam" ?  homeTeamName : awayTeamName)
        return MockOddValuesWithIdDto(eventId: eventId, oddValuesDto: oddValuesDto)
    }
}

class MockOddValuesDto:Codable {
    let orderId:String
    let hadicap:String?
    let ouValue:String?
    let oddValue:String
    let oddTitle:String
    var homeScore:Int {
        if oddTitle == "other" {return 999}
        return Int(String(oddTitle.split(separator: ":").first ?? "0")) ?? 0
    }
    var awayScore:Int {
        return Int(String(oddTitle.split(separator: ":").last ?? "0")) ?? 0
    }
    var disPalyValue:String {
        if let hadicapStr = hadicap {
            return "\(hadicapStr)  |  \(oddValue)"
        }
        if let ouValueStr = ouValue {
            return "\(ouValueStr)  |  \(oddValue)"
        }
        return oddValue
    }
    var selectionId:String {
        return orderId.digits
    }
    var isLock:Bool {
        return oddValue.isEmpty || oddValue.digits.allSatisfy{$0 == "0"}
    }
    init(orderId:String ,hadicap:String?,ouValue:String?,oddValue:String ,oddTitle:String){
        self.orderId = orderId
        self.hadicap = hadicap
        self.ouValue = ouValue
        self.oddValue = oddValue
        self.oddTitle = oddTitle
    }
    
    func transOddTitleWith(homeTeamName:String , awayTeamName:String) -> MockOddValuesDto{
        guard self.oddTitle == "homeTeam" || self.oddTitle == "awayTeam" else { return self }
        return MockOddValuesDto(orderId: self.orderId, hadicap: self.hadicap, ouValue: self.ouValue, oddValue: self.oddValue,
                            oddTitle: self.oddTitle == "homeTeam" ?  homeTeamName : awayTeamName)
    }
    
}

extension Array where Element:MockOddValuesWithIdDto {
    
    func homeWin() -> [MockOddValuesWithIdDto] {
        return  filter{$0.homeScore > $0.awayScore}.sorted { (old , new) -> Bool in
            if old.homeScore == new.homeScore {
                return old.awayScore < new.awayScore
            }
            return old.homeScore < new.homeScore
        }
    }
    func draw() -> [MockOddValuesWithIdDto] {
        return filter{$0.homeScore == $0.awayScore}.sorted { (old , new) -> Bool in
            return old.homeScore < new.homeScore
        }
    }
    func awayWin() -> [MockOddValuesWithIdDto] {
        return  filter{$0.homeScore < $0.awayScore}.sorted { (old , new) -> Bool in
            if old.awayScore == new.awayScore {
                return old.homeScore < new.homeScore
            }
            return old.awayScore < new.awayScore
        }
    }
}
