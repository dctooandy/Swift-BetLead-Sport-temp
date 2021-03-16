//
//  Views.swift
//  ProjectT
//
//  Created by Andy Chen on 2019/3/20.
//  Copyright © 2019 Andy Chen. All rights reserved.
//
import UIKit
import Foundation

func topOffset(_ mul: CGFloat) -> CGFloat {
    return Views.screenHeight * mul
}

func leftRightOffset(_ mul: CGFloat) -> CGFloat {
    return Views.screenWidth * mul
}

func sizeFrom(scale: CGFloat) -> CGFloat {
    return  Views.screenWidth * scale
}

func height(_ mul: CGFloat) -> CGFloat {
    return  Views.screenHeight * mul
}

func width(_ mul: CGFloat) -> CGFloat {
    return  Views.screenWidth * mul
}

class Views {
    static let screenWidth:CGFloat = UIScreen.main.bounds.size.width
    static let screenHeight:CGFloat = UIScreen.main.bounds.size.height
    static let betleadTabbarHeight:CGFloat = Views.isIPhoneWithNotch() ? 92 : 64
    static let navigationBarHeight:CGFloat = 44
    static let tabBarHeight:CGFloat = Views.isIPhoneWithNotch() ? 83 :49
    static let statusBarHeight:CGFloat = Views.isIPhoneWithNotch() ? 44 :20
    static let topOffset:CGFloat = Views.navigationBarHeight + Views.statusBarHeight
    static let bottomOffset:CGFloat = Views.isIPhoneWithNotch() ? 34 :0
    static let screenRect = CGRect(x:0, y:0, width:Views.screenWidth, height:Views.screenHeight)
    static let customNavigationBarHeight:CGFloat = 56
    static let customBottomViewHeight:CGFloat = 50
    
    static func isIPhoneSE() -> Bool {
        return UIScreen.main.bounds.size == CGSize(width:320, height:568)
    }
    
    static func isIPhone8() -> Bool {
        return UIScreen.main.bounds.size == CGSize(width:375, height:667)
    }
    
    static func isIPhone8Plus() -> Bool {
        return UIScreen.main.bounds.size == CGSize(width:414, height:736)
    }
    
    static func isIPad() -> Bool {
        return UIScreen.main.bounds.size.width >= 768
    }
    
    static func isIPhoneWithNotch() -> Bool {
        return UIScreen.main.bounds.size.height >= 812
    }
    static func isIPhoneXR() -> Bool {
        return UIScreen.main.bounds.size.height >= 896
    }
    
    static func contentHeiht() -> CGFloat {
        return screenHeight - betleadTabbarHeight - statusBarHeight + 30
    }
    
    static func tigerCellHeight(isFull:Bool) -> CGFloat {
        return isFull ? 250 + 90 : 90
    }
    
    static var launchImage:UIImage? {
        
        switch UIDevice.current.name {
        case "iPhone XR":
            return UIImage(named:"cover_page_iphone_xr")
        case "iPhone XS Max":
            return UIImage(named:"cover_page_iphone_xs_max")
        default:
            if isIPhoneWithNotch() {
                return UIImage(named:"cover_page_iphone_xs")
            } else if isIPhone8() {
                return UIImage(named:"cover_page_iphone_8")
            } else if isIPhone8Plus() {
                return UIImage(named:"cover_page_iphone_8plus")
            } else {
                return UIImage(named:"cover_page_iphone_se")
            }
        }
        
        
    }
    
    static let screenCGRect = CGRect(x:0, y:0, width:Views.screenWidth, height:Views.screenHeight)
}
