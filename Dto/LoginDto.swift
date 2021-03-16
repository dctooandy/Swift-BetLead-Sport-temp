//
//  LoginDto.swift
//  betlead
//
//  Created by Victor on 2019/5/30.
//  Copyright © 2019 vanness wu. All rights reserved.
//

import Foundation

enum LoginMode {
    
    case phone
    
    case account
    
    func pwdPlaceholder() -> String {
        switch self {
        case .account:
            return "密码"
        case .phone:
            return "请输入验证码"
        }
    }
    
    func accountPlacehloder() -> String {
        switch self {
        case .account:
            return "输入手机号 or 会员帐号"
        case .phone:
            return "请输入手机号"
        }
    }
    
    func signupPwdPlaceholder() -> String {
        switch self {
        case .account:
            return "密码：输入8～20位英文和数字"
        case .phone:
            return "请输入验证码"
        }
    }
    
    func signupAccountPlacehloder() -> String {
        switch self {
        case .account:
            return "用户名：输入5～15位英文或数字"
        case .phone:
            return "请输入手机号"
        }
    }
    
    func signupSuccessTitles() -> SignupSuccessTitle {
        switch self {
        case .phone:
            return SignupSuccessTitle(title: "完善您的个人资料", doneButtonTitle: "立即修改", showAccount: true)
        case .account:
            return SignupSuccessTitle(title: "欢迎加入倍利 祝您畅玩倍利", doneButtonTitle: "开始投注", showAccount: false)
        }
    }
    
    
}

struct SignupSuccessTitle {
    let title: String
    let doneButtonTitle: String
    let showAccount: Bool
}

struct LoginPostDto {
    let account: String
    let password: String
    let loginMode: LoginMode
    let timestamp = Date.timestamp()
    let finger = KeychainManager.share.getFingerID()
    init(account: String, password: String, loginMode: LoginMode) {
        self.account = account
        self.password = password
        self.loginMode = loginMode
    }
}

class MemberAccount {
    static var share: MemberAccount?
    
    init(account: String, password: String, loginMode: LoginMode) {
        self.account = account
        self.password = password
        self.loginMode = loginMode
    }
    
    let account: String
    var password: String
    let loginMode: LoginMode
}
