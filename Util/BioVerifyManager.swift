//
//  BiologicalVerifyManager.swift
//  betlead
//
//  Created by Victor on 2019/6/13.
//  Copyright © 2019 Andy Chen. All rights reserved.
//

import Foundation
import UIKit
import LocalAuthentication

class BioVerifyManager {
    
    static let share = BioVerifyManager()
    
    private var logedInList = [String]() {
        didSet {
            UserDefaults.Verification.set(value: logedInList, forKey: .loged_in)
        }
    }
    
    private var bioList = [String]() {
        didSet {
            UserDefaults.Verification.set(value: bioList, forKey: .BIOList)
        }
    }
    
    init() {
        self.bioList = UserDefaults.Verification.stringArray(forKey: .BIOList)
        self.logedInList = UserDefaults.Verification.stringArray(forKey: .loged_in)
        print("login list: \(logedInList)")
        print("bio list: \(bioList)")
    }
   
    func bioVerify(_ done: @escaping (Bool, Error?) -> ())  {
        let context = LAContext()
        context.localizedCancelTitle = "取消"
        context.touchIDAuthenticationAllowableReuseDuration = 0
        var error: NSError?
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) { // face id
            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: "通过FaceID/TouchID验证", reply: done)
        } else if context.canEvaluatePolicy(.deviceOwnerAuthentication,error: &error) { // touch id
            context.evaluatePolicy(.deviceOwnerAuthentication, localizedReason: "通过密码鉴验证", reply: done)
        } else {
            done(false, nil)
        }
    }
    
    func usedBIOVeritfy(_ acc: String) -> Bool {
        return self.bioList.contains(acc)
    }
    
    func applyMemberInBIOList(_ account: String) {
        bioList.append(account)
        UserDefaults.Verification.set(value: bioList, forKey: .BIOList)
    }
    
    func removeMemberFromBIOList(_ account: String) {
        if let index = self.bioList.firstIndex(of: account) {
            self.bioList.remove(at: index)
        }
    }
    
    func didLoginAccount(_ acc: String) -> Bool {
        return self.logedInList.contains(acc)
    }
    
    func applyLogedinAccount(_ acc: String) {
        logedInList.append(acc)
    }
    
    func updateLogedInList(by acc: String, oldAcc: String) {
        if acc.isEmpty { return }
        if oldAcc.isEmpty { return }
        if acc == oldAcc { return }
        if !logedInList.contains(oldAcc) {
            logedInList.append(acc.lowercased())
        }
    }
    
    /// 確認此帳號是否曾經登入
    func checkDidLoginList(acc: String, tel: String) {
        let accLogedIn = logedInList.contains(acc)
        let telLogedIn = logedInList.contains(tel)
        if accLogedIn && !telLogedIn {
            logedInList.append(tel)
        } else if !accLogedIn && telLogedIn {
            logedInList.append(acc)
        }
        
    }
    
    /// 測試用
    func testFunctionRemoveAllBioList() {
       testPrint(str: "testFunctionRemoveAllBioList")
        KeychainManager.share.deleteValue(at: .account)
        self.logedInList.removeAll()
        self.bioList.removeAll()
    }
    
    func testListLog() {
        testPrint(str: "testListLog")
        print("bio list: \(bioList)")
        print("loged in list: \(logedInList)")
    }
    
    func testPrint(str: String) {
        print("""
　　　┏┓　　　┏┓
　　┏┛　┻━━━┛ ┻┓
　　┃　　　　   ┃ 注意注意: \(str)
　　┃　　ㄦ　   ┃
　　┃ ┳┛　┗┳   ┃
　　┃　　　　   ┃
　　┃　　┻　　  ┃
　　┃　　　　   ┃
　　┗━┓ 　　 ┏━┛
　　　 ┃　　　┃
　　　 ┃　　　┃
　　　 ┃　　　┗━━━┓
　　　 ┃　　　　　 ┣┓
　　　 ┃　　　　　 ┏┛
　　　 ┗┓┓ ┏━┳┓ ┏┛
　　　　　┃┫┫　┃┫┫
　　　　　┗┻┛　┗┻┛
""")
    }
}
