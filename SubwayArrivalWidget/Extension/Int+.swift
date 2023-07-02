//
//  Int+.swift
//  SubwayArrivalWidget
//
//  Created by J_Min on 2023/07/02.
//

import Foundation

extension Int {
    // 0분0초
    func toMinSec() -> String {
        let min = self / 60
        let sec = self % 60
        
        if sec == 0 {
            return "\(min)분"
        } else if min == 0 {
            return "\(sec)초"
        } else {
            return "\(min)분\(sec)초"
        }
    }
}
