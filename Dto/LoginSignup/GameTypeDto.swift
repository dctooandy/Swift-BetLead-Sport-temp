//
//  GameTypeDto.swift
//  betlead
//
//  Created by Andy Chen on 2019/7/2.
//  Copyright © 2019 Andy Chen. All rights reserved.
//

import Foundation

class GameTypeDto: Codable {
    let id:Int
    let gameTypeName_Pc:String
    let gameTypeName_Mobile:String
    let gameTypeBackGround:String
    let gameCategory:Int
    let gameGroups:ResponseDto<GameGroupDto,[String:String]?>
   
}

class GameGroupDto:Codable {
    let id:Int
    let gameCompanyTag: String?
    let gameGroupName:String
    let gameLogo_Mobile:String
    let gameLogo_Pc:String
    let gameLogo_Recommend:String
    let gameVi_Before:String
    let gameVi_After:String
    //1:大廳,2:遊戲列表
    let gamePlayMode:Int
    
    var isEnterGameList:Bool {
        return gamePlayMode == 2
    }
    var isAvailable:Bool {
        return gamePlayMode == 1 || gamePlayMode == 2
    }
}
