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
}
