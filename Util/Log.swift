//
// Created by liq on 2018/6/13.
// Copyright (c) 2018 Pomelo Network PTE. LTD. All rights reserved.
//

import Foundation
import SwiftyBeaver

//Log.v("not so important")  // prio 1, VERBOSE in silver
//Log.d("something to debug")  // prio 2, DEBUG in green
//Log.i("a nice information")   // prio 3, INFO in blue
//Log.w("oh no, that wonât be good")  // prio 4, WARNING in yellow
//Log.e("ouch, an error did occur!")  // prio 5, ERROR in red

class Log {
  let log = SwiftyBeaver.self
  private let console = ConsoleDestination()
  private let file = FileDestination()
  static let share = Log()

  init() {
    console.format = "\n$DHH:mm:ss$d $M" //$L
    log.addDestination(console)
    log.addDestination(file)
  }

  static func v(_ message:@autoclosure () -> Any, _
  file:String = #file, _ function:String = #function, line:Int = #line, context:Any? = nil) {
    let path = (file as NSString).lastPathComponent.split(separator: ".").first!
    Log.share.log.verbose("ð [\(path).\(function), Line:\(line)]:\n\t\(message())")
  }

  static func d(_ message:@autoclosure () -> Any, _
  file:String = #file, _ function:String = #function, line:Int = #line, context:Any? = nil) {
    let path = (file as NSString).lastPathComponent.split(separator: ".").first!
    Log.share.log.debug("ð [\(path).\(function), Line:\(line)]:\n\t\(message())")
  }

  static func i(_ message:@autoclosure () -> Any, _
  file:String = #file, _ function:String = #function, line:Int = #line, context:Any? = nil) {
    let path = (file as NSString).lastPathComponent.split(separator: ".").first!
    Log.share.log.info("â¹ï¸ [\(path).\(function), Line:\(line)]:\n\t\(message())")
  }

  static func w(_ message:@autoclosure () -> Any, _
  file:String = #file, _ function:String = #function, line:Int = #line, context:Any? = nil) {
    let path = (file as NSString).lastPathComponent.split(separator: ".").first!
    Log.share.log.warning("â ï¸ [\(path).\(function), Line:\(line)]:\n\t\(message())")
  }

  static func e(_ message:@autoclosure () -> Any, _
  file:String = #file, _ function:String = #function, line:Int = #line, context:Any? = nil) {
    let path = (file as NSString).lastPathComponent.split(separator: ".").first!
    Log.share.log.error("ð [\(path).\(function), Line:\(line)]\n\t\(message())")
  }

  static func errorAndCrash(_ message:@autoclosure () -> Any, _
  file:String = #file, _ function:String = #function, line:Int = #line, context:Any? = nil) -> Never {
    let path = (file as NSString).lastPathComponent.split(separator: ".").first!
    Log.share.log.error("ð [\(path). \(function), Line:\(line)]:\n\t\(message())")
    fatalError()
  }
}
