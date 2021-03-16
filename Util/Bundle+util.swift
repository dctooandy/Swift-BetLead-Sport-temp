//
//  Bundle+util.swift
//  agency.ios
//
//  Created by Victor on 2019/5/21.
//  Copyright © 2019 Andy Chen. All rights reserved.
//

import Foundation

enum VersionType {
    case normal
    case forServer
    case stage
}

extension Bundle {
    static func getAppVersion(for type: VersionType) -> String {
        
        guard let versionString = self.main.infoDictionary?["CFBundleShortVersionString"] as? String else { return ""}
        switch type {
        case .normal:
            return versionString
        case .forServer:
            let versionArr = versionString.split(separator: ".").map{ String($0)}
            let firstVersion = versionArr.first!.paddingZeroBeforePrefix(2)
            let secVersion = versionArr[1].paddingZeroBeforePrefix(3)
            let lastVersion = versionArr.last!.paddingZeroBeforePrefix(3)
            let finalVersion = "1\(firstVersion)\(secVersion)\(lastVersion)"
            return finalVersion
        case .stage:
            return versionString + "." + getBuildNumber()
        }
    }
    
    static func getBuildNumber() -> String{
        return self.main.infoDictionary?["CFBundleVersion"] as? String ?? ""
    }
}
