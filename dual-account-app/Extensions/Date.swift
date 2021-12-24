//
//  Date.swift
//  BaseProject
//
//  Created by user.name on 7/17/20.
//  Copyright © 2020 user.name. All rights reserved.
//

import Foundation

let calendar = Calendar(identifier: .gregorian)

extension DateFormatter {
    static let defaultCalendar = Calendar(identifier: Calendar.Identifier.gregorian)
    static let defaultLocale = Locale(identifier: "en_US_POSIX")
    
    enum Format: String {
        case iso8601 = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        case notification = "E MMM dd yyyy HH:mm:ss 'GMT'Z"
        case dateAndTime = "yyyy-MM-dd HH:mm:ss"
        case date = "yyyy-MM-dd"
        case dayAndMonth = "M/d"
        case hourAndMinutes = "HH:mm"
        case yearMonthDay = "yyyy/MM/dd"
        case yearMonthDayHourMinute = "yyyy/MM/dd HH:mm"
        case dateAndWeekDay = "yyyy/MM/dd(E)"
        case monthDay = "MM/dd"
        case MMMMdayMonthYear = "EEEE, dd MMM yyyy"
        case MMMMdayMonthYearHourMinutes = "EEEE, dd MMM yyyy HH:mm"
        case hourMinuteDayMonthYear = "HH:mm, dd MMM yyyy"
    
//        var instance: DateFormatter {
//            switch self {
//            default:
//                return DateFormatter().then {
//                    $0.dateFormat = self.rawValue
//                    $0.calendar = DateFormatter.defaultCalendar
//                    $0.locale = DateFormatter.defaultLocale
//                }
//            }
//        }
    }
}

extension Date {
    
    var zeroSeconds: Date? {
        let calendar = Calendar.current
        let dateComponents = calendar.dateComponents([.year, .month, .day, .hour, .minute], from: self)
        return calendar.date(from: dateComponents)
    }
    
    func toGMT(_ format: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: self)
    }

    func convertToTimeZone(from fromTimeZone: TimeZone, to toTimeZone: TimeZone) -> Date {
         let delta = TimeInterval(toTimeZone.secondsFromGMT(for: self) - fromTimeZone.secondsFromGMT(for: self))
         return addingTimeInterval(delta)
    }
}

extension Date {
    func toString(_ format: String) -> String {
        let formatter = DateFormatter().then {
            $0.dateFormat = format
            $0.calendar = Calendar(identifier: .gregorian)
            $0.timeZone = TimeZone(secondsFromGMT: TimeZone.current.secondsFromGMT())
        }
        return formatter.string(from: self)
    }
}

extension Date {
    func getComponent(_ component: Calendar.Component) -> Int {
        let calendar = Calendar.current
        return calendar.component(component, from: self)
    }
}

extension Date {
    static func dates(from fromDate: Date, to toDate: Date, component: Calendar.Component = .day) -> [Date] {
        var dates: [Date] = []
        var date = fromDate
        while date <= toDate {
            dates.append(date)
            guard let newDate = Calendar.current.date(byAdding: .day, value: 1, to: date) else { break }
            date = newDate
        }
        return dates
    }
}

extension Date {
    func isBetween(date date1: Date, andDate date2: Date) -> Bool {
        return date1.compare(self).rawValue * self.compare(date2).rawValue >= 0
    }
    
    var startOfMonth: Date {
        let calendar = Calendar(identifier: .gregorian)
        let components = calendar.dateComponents([.year, .month], from: self)
        return calendar.date(from: components) ?? Date()
    }
    
    var endOfMonth: Date {
        var components = DateComponents()
        components.month = 1
        components.second = -1
        return Calendar(identifier: .gregorian).date(byAdding: components, to: startOfMonth) ?? Date()
    }
    
    var startOfDay: Date {
        return Calendar.current.startOfDay(for: self)
    }
    
    var endOfDay: Date {
        var components = DateComponents()
        components.day = 1
        components.second = -1
        return Calendar.current.date(byAdding: components, to: startOfDay) ?? Date()
    }
}
