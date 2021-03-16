//
//  Delay.swift
//  betlead
//
//  Created by Andy Chen on 2019/7/15.
//  Copyright © 2019 Andy Chen. All rights reserved.
//

import Foundation

class Delay {
    static func perform(time:TimeInterval, action:@escaping ()->()){
        DispatchQueue.main.asyncAfter(deadline: .now() + time) {
            action()
        }
    }
}
