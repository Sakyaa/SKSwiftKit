//
//  SKDateExtensions.swift
//  GZCanLian
//
//  Created by Sakya on 2018/1/25.
//  Copyright © 2018年 Sakya. All rights reserved.
//



import Foundation

public extension Date {
    public enum SKDateStyle {
        case yearMonthDay
        case yearMonthDayHourMinSecond
        
    }

    public func sk_dateStringFormatter(ofStyle style:SKDateStyle) ->String {
        struct DateStatic {
            static let dateFormatter = DateFormatter()
        }
        switch style {
        case .yearMonthDayHourMinSecond:
            DateStatic.dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            break
        default:
            break
        }
        
        return DateStatic.dateFormatter.string(from: self)
    }

}
