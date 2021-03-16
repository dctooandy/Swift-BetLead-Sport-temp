//
//  JPushManager.swift
//  betlead
//
//  Created by Victor on 2019/7/9.
//  Copyright © 2019 Andy Chen. All rights reserved.
//

import Foundation
import UserNotifications
import RxSwift
import RxCocoa

class JPushManager: NSObject, JPUSHRegisterDelegate {
    
    static var share = JPushManager()
    let receivePush = PublishSubject<PushType>()
    enum PushType {
        case presentViewControler(String)
    }
    
    func launch(appKey: String, channel: String? = nil, option: [AnyHashable : Any]?) {
        if let regID = JPUSHService.registrationID(), !regID.isEmpty { return }
        let entity = JPUSHRegisterEntity()
        entity.types = Int(JPAuthorizationOptions.alert.rawValue |
                           JPAuthorizationOptions.badge.rawValue |
                           JPAuthorizationOptions.sound.rawValue)
        JPUSHService.register(forRemoteNotificationConfig: entity, delegate: self)
        JPUSHService.setup(withOption: option, appKey: appKey, channel: channel, apsForProduction: false)
    }
    
    func registerDeiveToken(_ token: Data) {
        JPUSHService.registerDeviceToken(token)
        JPUSHService.registrationIDCompletionHandler { (resCode, registerID) in
            guard let id = registerID else {
                print("[JPush] register fail.")
                return
            }
            print("[JPush] register ID : \(id)")
        }
    }
    
    func jpushNotificationCenter(_ center: UNUserNotificationCenter!, openSettingsFor notification: UNNotification?) {
       print("open setting for???")
    }
    
    func jpushNotificationCenter(_ center: UNUserNotificationCenter!, willPresent notification: UNNotification!, withCompletionHandler completionHandler: ((Int) -> Void)!) {
        print("will present notificaiton: \(notification.request.content.userInfo)")
        receivePush.onNext(PushType.presentViewControler("member"))
        completionHandler(Int(UNAuthorizationOptions.alert.rawValue))
    }
    
    func jpushNotificationCenter(_ center: UNUserNotificationCenter!, didReceive response: UNNotificationResponse!, withCompletionHandler completionHandler: (() -> Void)!) {
        print("did Receive notificaiton: \(response.notification.request.content)")
        JPUSHService.setBadge(0)
    }
}
