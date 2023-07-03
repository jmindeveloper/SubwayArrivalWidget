//
//  Date+.swift
//  SubwayArrivalWidget
//
//  Created by J_Min on 2023/07/01.
//

import Foundation

extension Date {
    /// HH:mm
    func timeToString() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return formatter.string(from: self)
    }
    
    static func getTimeTableDay() -> TimeTableDay {
        let date = Date()
        let calendar = Calendar.current
        let component = calendar.component(.weekday, from: date)
        
        if component == 1 {
            return .Sundays
        } else if component == 7 {
            return .Saturdays
        } else {
            return .Weekdays
        }
    }
}
