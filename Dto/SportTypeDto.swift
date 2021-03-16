//
//  SportTypeDto.swift
//  BetLead-Sport
//
//  Created by Andy Chen on 2019/8/2.
//  Copyright © 2019 lismart. All rights reserved.
//

import Foundation

class SportTypeDto:Codable {
    let value:Int
    let display:String
    let enDisplay:String
    
    init(value:Int,display:String,enDisplay:String){
        self.value = value
        self.display = display
        self.enDisplay = enDisplay
    }
}

