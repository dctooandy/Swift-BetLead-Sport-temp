//
//  MarqueeDto.swift
//  betlead
//
//  Created by Andy Chen on 2019/5/31.
//  Copyright © 2019 Andy Chen. All rights reserved.
//

import Foundation

class MarqueeDto:Codable {
//    let id:Int
    let newsTitle:String
//    let newsGroupId:ValueIntDto
    let newsContent:String
//    let newsDevice:ValueStringDto
//    let newsTimeStart:String
//    let newsTimeEnd:String
//    let newsTop:ValueIntDto
//    let newsStatus:ValueIntDto
//    let userCreatedUser:ValueIntDto?
//    let userUpdatedUser:ValueIntDto?
//    let userCreatedAt:String?
//    let userUpdatedAt:String?
    let newsCreatedAt:String
//    let newsUpdatedAt:String
    
    init(newsTitle:String ,newsContent:String , newsCreatedAt:String) {
        self.newsTitle = newsTitle
        self.newsContent = newsContent
        self.newsCreatedAt = newsCreatedAt
    }
}
