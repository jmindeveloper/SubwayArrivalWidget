//
//  UPDNLine.swift
//  SubwayArrivalWidget
//
//  Created by J_Min on 2023/07/02.
//

import Foundation

enum UPDNLine: String, Codable {
    case up1 = "상행"
    case up2 = "내선"
    case dn1 = "하행"
    case dn2 = "외선"
    
    var isUp: Bool {
        switch self {
        case .up1, .up2:
            return true
        case .dn1, .dn2:
            return false
        }
    }
    
    var code: String {
        switch self {
        case .up1, .up2:
            return "1"
        case .dn1, .dn2:
            return "2"
        }
    }
}
