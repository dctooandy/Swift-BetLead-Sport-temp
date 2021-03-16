//
//  Int+util.swift
//  BetLead-Sport
//
//  Created by Andy Chen on 2019/8/12.
//  Copyright © 2019 lismart. All rights reserved.
//

import Foundation

extension Int {
    func prefixZero(_ digit:Int) -> String {
        let count = "\(self)".count
        guard count <=  digit else { return self.toString() }
        return "\((digit - count).repeatWith("0"))\(self)"
    }
    
    func repeatWith(_ str:String) -> String{
        return (0..<self).reduce("", { (result, _) -> String in
            return result + "\(str)"
        })
    }
    
    func toString() -> String {
        return "\(self)"
    }
    
}
