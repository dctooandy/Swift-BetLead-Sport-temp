//
//  Reactive+util.swift
//  betlead
//
//  Created by Andy Chen on 2019/6/11.
//  Copyright © 2019 Andy Chen. All rights reserved.
//

import Foundation
import UIKit
import RxCocoa
import RxSwift
extension Reactive where Base:UIView {
    
    var click:Observable<Void> {
        let tap = base.gestureRecognizers?.filter{$0 is UITapGestureRecognizer}.first
        if tap != nil {
            return tap!.rx.event.map{ _ -> Void  in
                return
            }
        } else {
            let tap = UITapGestureRecognizer()
            base.addGestureRecognizer(tap)
            base.isUserInteractionEnabled = true
            return tap.rx.event.map{ _ -> Void  in
                return
            }
        }
    }
}
