//
//  TimeInterval+Helpers.swift
//  Freshly
//
//  Created by Sergey Pugach on 23.05.21.
//

import Foundation

public extension TimeInterval {

    static let nanoSecond: TimeInterval = microSecond / 1000
    static let microSecond: TimeInterval = milliSecond / 1000
    static let milliSecond: TimeInterval = second / 1000
    static let second: TimeInterval = 1
    static let minute: TimeInterval = second * 60
    static let hour: TimeInterval = minute * 60
    static let day: TimeInterval = hour * 24
    static let week: TimeInterval = day * 7

    static let month28Days: TimeInterval = day * 28
    static let month29Days: TimeInterval = day * 29
    static let month30Days: TimeInterval = day * 30
    static let month31Days: TimeInterval = day * 31

    static let year: TimeInterval = day * 365
    static let leapYear: TimeInterval = day * 366
}

extension TimeInterval {
    var milliseconds: DispatchTimeInterval {
        return .milliseconds(Int(self * 1000))
    }
}
