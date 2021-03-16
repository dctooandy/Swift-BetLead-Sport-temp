//
//  KeychainManager.swift
//  ProjectT
//
//  Created by Victor on 2019/4/22.
//  Copyright © 2019 Andy Chen. All rights reserved.
//

import Foundation
import KeychainSwift

class KeychainManager {
    
    enum KeychainKey: String {
        case fingerID = "finger_id"
        case account = "betlead_account"
        case accList = "betlead_acc_list"
    }
    
    static let share = KeychainManager()
    
    private func setString(_ value: String, at type: KeychainKey) -> Bool {
        return KeychainSwift().set(value, forKey: type.rawValue)
    }
    
    private func setData(_ value: Data, at type: KeychainKey) -> Bool {
        return KeychainSwift().set(value, forKey: type.rawValue)
    }
    
    private func getString(from type: KeychainKey) -> String? {
        return KeychainSwift().get(type.rawValue)
    }
    
    private func getData(from type: KeychainKey) -> Data? {
        return KeychainSwift().getData(type.rawValue)
    }
    
    func deleteValue(at type: KeychainKey) {
        KeychainSwift().delete(type.rawValue)
    }
    
    /// 儲存帳號到keychain
    ///
    /// - Parameter value: 帳號
    @discardableResult
    func setLastAccount(_ value: String) -> Bool {
        let success = self.setString(value, at: .account)
        print("keychain set \(value) status: \(success)")
        return success
    }
    
    func getLastAccount() -> LoginPostDto? {
        guard let accInKeychain = self.getString(from: .account) else { return nil }
        let accList = getAccList()
        guard let accPwdString = accList.filter({$0.contains(accInKeychain)}).first else { return nil }
        let accArr = accPwdString.components(separatedBy: ".")
        let acc = accArr[0]
        let pwd = accArr[1]
        let tel = accArr[2]
        return LoginPostDto(account: acc.isEmpty ? tel : acc, password: pwd, loginMode: .account)
    }
    
    /// 儲存帳號密碼電話 格式: acc.pwd.tel
    /// 遵循此格式： "acc.pwd.tel"
    /// - Parameters:
    ///   - acc: 帳號
    ///   - pwd: 密碼
    ///   - tel: 電話
    func saveAccPwd(acc: String, pwd: String, tel: String) {
        let arr = getAccList()
        var isNewAccount = true
        print("save acc list: \(arr)")
        var newArr = arr.map { (str) -> String in // update
            let accArr = str.components(separatedBy: ".")
            if accArr.contains(acc) || accArr.contains(tel) {
                isNewAccount = false
                let finalAcc = acc.isEmpty ? accArr[0] : acc
                let finalTel = tel.isEmpty ? accArr[2] : tel
                let finalPwd = pwd.isEmpty ? accArr[1] : pwd
                print("old acc: \(acc).\(accArr[1]).\(tel)\nnew acc: \(finalAcc).\(finalPwd).\(finalTel)")
                return "\(finalAcc).\(finalPwd).\(finalTel)"
            
            } else {
                return str
            }
        }
        
        let accString = "\(acc).\(pwd).\(tel)"
        print("save acc string: \(accString) , isnew: \(isNewAccount)")
        if isNewAccount { // if false == new account
            newArr.append(accString)
        }
        print("save acc new final array: \(newArr)")
        saveAccList(newArr)
    }
    
    func updateAccount(acc: String, pwd: String) {
        var isNewAccount = true
        let arr = getAccList()
        var newArr = arr.map { (str) -> String in // update
            let accArr = str.components(separatedBy: ".")
            print("update map account: \(str)")
            if accArr.contains(acc) {
                isNewAccount = false
                let phone = accArr[2]
                print("update old account: \(accArr[0]).\(accArr[1]).\(accArr[2])")
                print("new account: \(acc).\(pwd).\(phone)")
                return "\(acc).\(pwd).\(phone)"
            } else {
                return str
            }
        }
        if isNewAccount {
            print("update.. is new account")
            newArr.append("\(acc).\(pwd).")
        }
        print("update new array: \(newArr)")
        saveAccList(newArr)
    }
    
    func saveAccList(_ list: [String]) {
        print("save account list: \(list)")
        let data = NSKeyedArchiver.archivedData(withRootObject: list)
        let success = setData(data, at: .accList)
        print("save account list status: \(success)")
    }
    
    
    private func getAccList() -> [String] {
        guard let data = getData(from: .accList) else { return [] }
        guard let arr = NSKeyedUnarchiver.unarchiveObject(with: data) as? [String] else { return [] }
        print("get account list: \(arr)")
        return arr
    }
    
    func accountExist(_ acc: String) -> Bool {
        var isExist = false
        getAccList().forEach { (accInfo) in
            isExist = (accInfo.hasPrefix(acc) && !accInfo.components(separatedBy: ".")[1].isEmpty)
        }
        return isExist
    }
    
    //
    func getFingerID() -> String? {
        
        if let fingerID = getString(from: .fingerID) {
            print("has fingerID: \(fingerID)")
            return fingerID
        } else {
            let uuid = UUID().uuidString
            print("no fingerID create one")
            if setString(uuid, at: .fingerID) {
                print("saveo fingerID: \(uuid)")
                return uuid
            } else {
                print("create fingerID fail.")
                return nil
            }
        }
    }
}
