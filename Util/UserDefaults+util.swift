//
//  UserDefaults+util.swift
//  Pre18tg
//
//  Created by Andy Chen on 2019/4/9.
//  Copyright © 2019 Andy Chen. All rights reserved.
//

import Foundation


protocol UserDefaultsSettable
{
    associatedtype defaultKeys: RawRepresentable
}

extension UserDefaults
{
    // 驗證用
    struct Verification: UserDefaultsSettable {
        enum defaultKeys: String {
            case status
            case data
            case jwt_token
            case message
            case other
            case error_message
            case error_code
            case agency_pro_tag
            case agency_stage_tag
            case launchBefore
            case BIOList
            case loged_in
        }
       
    }
    
    // 登录信息
    struct LoginInfo: UserDefaultsSettable {
        enum defaultKeys: String {
            case token
            case userId
        }
    }
    
    // 登录信息
    struct readNews: UserDefaultsSettable {
        enum defaultKeys: String {
            case sn
        }
    }
    
    // SVG
    struct SVGInfo: UserDefaultsSettable {
        enum defaultKeys: String {
            case isLoadBefore
        }
    }
    
    // Avatar
    struct Avatar: UserDefaultsSettable {
        enum defaultKeys: String {
            case image
        }
    }
    
    // Sport
    struct SportInfo: UserDefaultsSettable {
        enum defaultKeys: String {
            // 1 : "歐洲盤" 2 : "香港盤"
            case oddsType
        }
    }
    struct FavoriteSportInfo: UserDefaultsSettable {
        enum defaultKeys: String {
            case favoriteSportPosts
            case needUpdateToService
            case favoritePrice
        }
    }
   
}

extension UserDefaultsSettable where defaultKeys.RawValue==String {
    static func set(value: String?, forKey key: defaultKeys) {
        let aKey = key.rawValue
        UserDefaults.standard.set(value, forKey: aKey)
    }
    static func set(value: [String]?, forKey key: defaultKeys) {
        let aKey = key.rawValue
        UserDefaults.standard.set(value, forKey: aKey)
    }
    static func set(value: Bool, forKey key: defaultKeys) {
        let aKey = key.rawValue
        UserDefaults.standard.set(value, forKey: aKey)
    }
    static func set(value: Any, forKey key: defaultKeys) {
        let aKey = key.rawValue
        UserDefaults.standard.set(value, forKey: aKey)
    }
    static func setEncodeData<T:Codable>(value: T, forKey key: defaultKeys) {
        let aKey = key.rawValue
        let encoder = JSONEncoder()
        let encoded = try? encoder.encode(value)
        UserDefaults.standard.set(encoded, forKey: aKey)
    }
    
    static func string(forKey key: defaultKeys) -> String {
        let aKey = key.rawValue
        if let value = UserDefaults.standard.string(forKey: aKey) {
            return value
        }
        return ""
    }
    static func bool(forKey key: defaultKeys) -> Bool {
        let aKey = key.rawValue
        if let value = UserDefaults.standard.value(forKey: aKey) as? Bool {
            return value
        }
        return false
    }
    static func decoderData<T:Codable>(type: T.Type,forKey key: defaultKeys) -> T? {
        let aKey = key.rawValue
        if let data =  UserDefaults.standard.data(forKey: aKey) {
            let decoder = JSONDecoder()
           return try? decoder.decode(type, from: data)
        }
        return nil
    }
    
    static func stringArray(forKey key: defaultKeys) -> [String] {
        let aKey = key.rawValue
        if let value = UserDefaults.standard.stringArray(forKey: aKey) {
            return value
        }
        return [String]()
    }
    
    static func delete(forKey key: defaultKeys) {
        UserDefaults.standard.removeObject(forKey: key.rawValue)
    }
}

extension UserDefaults.SportInfo {
    static var oddsType : OddsType {
        let aKey = UserDefaults.SportInfo.defaultKeys.oddsType.rawValue
        let rawvalue = UserDefaults.standard.string(forKey: aKey)  ??  "1"
        return OddsType(rawValue : rawvalue) ?? OddsType.europe
    }
}

extension UserDefaults.FavoriteSportInfo {
    static var betPrices : [Double] {
        let aKey = UserDefaults.FavoriteSportInfo.defaultKeys.favoritePrice.rawValue
        if let rawvalue = UserDefaults.standard.value(forKey: aKey) as? [Double] {
            return rawvalue
        } else {
          UserDefaults.FavoriteSportInfo .set(value: [10,50,100,300,500], forKey: .favoritePrice)
          return  [10,50,100,300,500]
        }
    }
    
    static func addBetPrice(_ price:Double) {
        set(value: [price] + betPrices.dropLast(), forKey: .favoritePrice)
    }
}
