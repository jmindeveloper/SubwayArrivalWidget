//
//  TimeTableDay.swift
//  SubwayArrivalWidget
//
//  Created by J_Min on 2023/07/02.
//

import Foundation

enum TimeTableDay {
    case Weekdays, Saturdays, Sundays, Holidays
    
    var code: String {
        switch self {
        case .Weekdays:
            return "1"
        case .Saturdays:
            return "2"
        case .Sundays, .Holidays:
            return "3"
        }
    }
}
