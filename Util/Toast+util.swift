//
// Created by liq on 2018/6/12.
// Copyright (c) 2018 Pomelo Network PTE. LTD. All rights reserved.
//

import Foundation
import Toaster
import RxSwift
import RxCocoa

extension Toast {
    
  static let subject = PublishSubject<String>()
  
    static func show(msg:String) {
    subject.onNext(msg)
  }
    
    static func bindSubject() {
        subject.throttle(2.5, latest:false, scheduler: MainScheduler.instance).subscribeSuccess { (msg) in
            let toast = Toast(text: msg)
            toast.duration = 2.5
            toast.show()
            }.disposed(by: disposeBag)
    }
    static let disposeBag = DisposeBag()
    static func showSuccess(msg:String) {
        let toast = Toast(text: msg)
        toast.view.textColor = Themes.trueGreenLayerColor
        toast.view.bottomOffsetPortrait = Views.screenHeight/2 - 100
        toast.show()
    }
    
}
