//
//  Date+util.swift
//  betlead
//
//  Created by Victor on 2019/6/6.
//  Copyright © 2019 Andy Chen. All rights reserved.
//

import Foundation
enum DateFormat: String
{
    case slashDate = "YYYY/MM/dd"
    case Date = "YYYY-MM-dd"
    case DateTime = "YYYY-MM-dd HH:mm:ss"
}

extension Date {
    
    // This Month Start
    func getThisMonthStart() -> Date {
        let comps = Calendar.current.dateComponents([.year, .month], from: self)
        let startMonth = Calendar.current.date(from: comps)
        return startMonth!
    }
    
    func getThisMonthEnd() -> Date {
        var comps = DateComponents()
        comps.month = 1
        comps.day = -1
        let endMonth = Calendar.current.date(byAdding: comps, to: getThisMonthStart())
        return endMonth!
    }
    
    func getLastMonthStart() -> Date {
        var comps = Calendar.current.dateComponents([.year, .month], from: self)
        comps.month = comps.month! - 1
        let startMonth = Calendar.current.date(from: comps)
        return startMonth!
    }
    
    func getLastMonthEnd() -> Date {
        var comps = DateComponents()
        comps.day = -1
        let endMonth = Calendar.current.date(byAdding: comps, to: getThisMonthStart())
        return endMonth!
    }
    
    func getThisMonthRange() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let startDate = dateFormatter.string(from: getThisMonthStart())
        let endDate = dateFormatter.string(from: getThisMonthEnd())
        return "\(startDate) ~ \(endDate)"
    }
    
    func getLastMonthRange() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let startDate = dateFormatter.string(from: getLastMonthStart())
        let endDate = dateFormatter.string(from: getLastMonthEnd())
        return "\(startDate) ~ \(endDate)"
    }
    static func timestamp() -> Int {
        return Int(Date().timeIntervalSince1970)
    }
    
    static var today: Date {
        return Calendar.current.date(bySettingHour: 0, minute: 0, second: 0, of: Date())!
    }
    
    func addDay(day: Int) -> Date {
        let d = Calendar.current.date(byAdding: .day, value: day, to: self)!
        return Calendar.current.date(bySettingHour: 0, minute: 0, second: 0, of: d)!
    }
    
    func startOfWeek() -> Date {
        let gregorian = Calendar(identifier: .gregorian)
        return gregorian.date(from: gregorian.dateComponents([.yearForWeekOfYear, .weekOfYear], from: self))!
    }
    
    func endOfWeek() -> Date {
        return Calendar(identifier: .gregorian).date(byAdding: .day, value: 6, to: self.startOfWeek())!
    }
    
    func startOfMonth() -> Date {
        let dateComponents = Calendar.current.dateComponents([.year, .month], from: Calendar.current.startOfDay(for: self))
        let firstDate = Calendar.current.date(from: dateComponents)
        return firstDate!
    }
    
    func toString(format: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: self)
    }
    
    static func daysBetweenDate(from d1: Date, to d2: Date) -> Int {
        return Calendar.current.dateComponents([.day], from: d1, to: d2).day!
    }
    
}
