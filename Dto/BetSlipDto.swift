//
//  BetSlipDto.swift
//  BetLead-Sport
//
//  Created by Andy Chen on 2019/8/19.
//  Copyright © 2019 lismart. All rights reserved.
//

import Foundation

class BetSlipDto:Codable {
    let betEntriesResponse:[BetEntriesResponseDto]
    let oddsType:Int
    let currencyCode:String
    let bets:[BetDetailDto]
    let ticketResult:Int
    let oddsAcception:Int
    let allowEachWay:Bool
    let ticketResultName:String?
    var isBetSuccess:Bool {
        return ticketResult == 8888
    }
    var isOddsChange:Bool {
        return betEntriesResponse.contains(where: {$0.status == 24 || $0.status == 20})
    }
    var errorMessage:String {
        return betEntriesResponse.reduce("", { (result, betEntriesResponseDto) -> String in
            return result + betEntriesResponseDto.errorMessgae
        }) + bets.reduce("", { (result, betDetailDto) -> String in
            return result + betDetailDto.errorMessgae
        })
    }
}

class BetEntriesResponseDto:Codable {
    let parentEventId:Int
    let eventId:Int
    let selectionId:Int
    let betTypeName:String
    let selectionName:String
    let leagueName:String
    let odds:Double
    let euroOdds:Double
    let baseOddsType:Int
    let flat:FlatDto
    let status:Int
    let result:String?
    let dangerId:Int
    let isDanger:Bool
    let eventDate:String
    let eventTime:String
    let homeTeamName:String
    let awayTeamName:String
    let statusName:String?
    
    var errorMessgae:String {
        if let error = result {
            return selectionName + betTypeName + error
        }
        return ""
    }
    var renewOdds:Double {
        return  UserDefaults.SportInfo.oddsType == OddsType.hongKong ? odds : euroOdds
    }
}

class FlatDto:Codable {
    let isInPlay:Bool
    let isDisplayScore:Bool
}

class BetDetailDto:Codable {
    let betSetting:BetSettingDto
    let odds:Double
    let isPlaceWager:Bool
    let oddsDecimalPlaces:Int?
    let stakeAmount:Int
    let stakeAmounts:String
    let wagerType:String?
    let wagerNo:Int
    let numberOfCombination:Int
    let status:Int
    let statusName:String?
    let result:String?
    
    var errorMessgae:String {
        if let error = result {
            return error
        }
        return ""
    }
}

class BetSettingDto:Codable {
    let minBet:Double
    let maxBet:Double
}

class AddBetSlipPostDto {
    let eventId:String
    let isInPlay:Bool
    let odds:Double
    let selectionId:String
    let handicap:String?
    let score:String?
    init(eventId:String ,isInPlay:Bool, odds:Double ,selectionId:String ,handicap:String? = nil , score:String? = nil) {
        self.eventId = eventId
        self.isInPlay = isInPlay
        self.odds = odds
        self.selectionId = selectionId
        self.handicap = handicap
        self.score = score
    }
}

class BetAmountsPostDto {
    let type:String
    let amount:String
    init(type:String,amount:String) {
        self.type = type
        self.amount = amount
    }
    
    
}

class BetBottomSheetInitDto {
    let oddsName:String
    let oddsTitle:String
    let addBetSlipPostDto:AddBetSlipPostDto
    init(oddsName:String ,oddsTitle:String ,addBetSlipPostDto:AddBetSlipPostDto ) {
        self.oddsName = oddsName
        self.oddsTitle = oddsTitle
        self.addBetSlipPostDto = addBetSlipPostDto
    }
}

class ParleyBetDto {
    let competitionName:String
    let information:OddsInfoDto
    let oddsName:String
    let oddsTitle:String
    let addBetSlipPostDto:AddBetSlipPostDto
    init(competitionName:String , information:OddsInfoDto ,oddsName:String , oddsTitle:String,addBetSlipPostDto:AddBetSlipPostDto) {
        self.competitionName = competitionName
        self.information = information
        self.oddsName = oddsName
        self.oddsTitle = oddsTitle
        self.addBetSlipPostDto = addBetSlipPostDto
    }
}

extension AddBetSlipPostDto {
    func toDict() -> [String:Any] {
        var dict:[String:Any] = ["eventId":eventId ,
                                 "isInPlay":isInPlay,
                                 "odds":odds,
                                 "selectionId":selectionId
        ]
        if let handicap = handicap {
            dict["handicap"] = handicap
        }
        if let score = score {
            dict["score"] = score
        }
        return dict
    }
}
extension BetAmountsPostDto {
    func toDict() -> [String:Any] {
        return ["type":type ,
                "amount":amount
        ]
    }
}

