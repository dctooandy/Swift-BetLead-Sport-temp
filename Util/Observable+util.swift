//
// Created by liq on 2018/6/13.
// Copyright (c) 2018 Pomelo Network PTE. LTD. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

public protocol OptionalType {
  associatedtype Wrapped

  var optional:Wrapped? { get }
}

extension Optional: OptionalType {
  public var optional:Wrapped? {
    return self
  }
}

// Unfortunately the extra type annotations are required, otherwise the compiler gives an incomprehensible error.
extension Observable where Element: OptionalType {
  func ignoreNil() -> Observable<Element.Wrapped> {
    return flatMap { value in
      value.optional.map {
        Observable<Element.Wrapped>.just($0)
      } ?? Observable<Element.Wrapped>.empty()
    }
  }
}
