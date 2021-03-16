//
// Created by 黃智聖 on 2018/6/19.
// Copyright (c) 2018 Pomelo Network PTE. LTD. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift
import Toaster

extension ObservableType {
    public func subscribeSuccess(_ callback:((Element) -> Void)? = nil) -> Disposable {
        return subscribe(onNext: callback, onError: { (error) in
            ErrorHandler.show(error: error)
            })
    }
    //
    //  func subscribeResultSuccess<T>(onNext: ((T) -> Void)? = nil)
    //          -> Disposable {
    //    return subscribe(onNext:{ result in
    //      if let result = result as? Result<T> {
    //        switch result {
    //        case .success(let value):
    //          onNext?(value)
    //        case .failure(let error):
    //          if let error = error as? ApiServiceError {
    //            switch error {
    //            case .domainError(let msg):
    //              Toast.show(msg:"domainError: \(msg ?? "")")
    //            case .networkError(let msg):
    //              Toast.show(msg:"networkError: \(msg ?? "")")
    //            case .unknownError(let msg):
    //              Toast.show(msg:"unknownError: \(msg ?? "")")
    //            }
    //          } else {
    //            Toast.show(msg:"unDefine error type")
    //          }
    //        }
    //      }
    //
    //
    //    }, onError:{ error in
    //      if let error = error as? ApiServiceError {
    //        switch error {
    //        case .domainError(let msg):
    //          Toast.show(msg:"domainError: \(msg ?? "")")
    //        case .networkError(let msg):
    //          Toast.show(msg:"networkError: \(msg ?? "")")
    //        case .unknownError(let msg):
    //          Toast.show(msg:"unknownError: \(msg ?? "")")
    //        }
    //      } else {
    //        Toast.show(msg:"unDefine error type")
    //      }
    //
    //    })
    //  }
}
