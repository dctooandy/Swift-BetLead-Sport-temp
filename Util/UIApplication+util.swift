//
//  UIApplication+util.swift
//  agency.ios
//
//  Created by Andy Chen on 2019/5/16.
//  Copyright © 2019 Andy Chen. All rights reserved.
//

import Foundation
import UIKit
extension UIApplication{
    static func getTopBaseViewController() -> BaseViewController?
    {
//        if let viewController = (UIApplication.shared.windows.first?.rootViewController as? AgencyNavigationController)
//        {
//            return (viewController.viewControllers.first as? BaseViewController)
//        }else
//        {
//            return (UIApplication.shared.windows.first?.rootViewController as? BaseViewController)
//        }
        return UIApplication.shared.keyWindow?.topViewController() as? BaseViewController
    }
}
extension UIWindow {
    func topViewController() -> UIViewController? {
        var top = self.rootViewController
        while true {
            if let presented = top?.presentedViewController {
                top = presented
            } else if let nav = top as? UINavigationController {
                top = nav.visibleViewController
            } else if let tab = top as? UITabBarController {
                top = tab.selectedViewController
            } else {
                break
            }
        }
        return top
    }
}
