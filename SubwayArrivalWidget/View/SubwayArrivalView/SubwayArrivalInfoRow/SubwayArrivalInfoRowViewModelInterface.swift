//
//  SubwayArrivalInfoRowViewModelInterface.swift
//  SubwayArrivalWidget
//
//  Created by J_Min on 2023/07/02.
//

import Foundation

protocol SubwayArrivalInfoRowViewModelInterface: ObservableObject {
    var destination: String { get }
    var arrivalInfo: String { get }
}

class SubwayArrivalInfoRowViewModel: SubwayArrivalInfoRowViewModelInterface {
    private var info: RealtimeArrivalInfo
    var destination: String {
        info.trainLineNm.replacingOccurrences(of: " ", with: "").components(separatedBy: "-").first ?? ""
    }
    
    var arrivalInfo: String {
        if info.barvlDt == "0" {
            return info.arvlMsg2
        } else {
            if let barvlDtInt = Int(info.barvlDt) {
                return "\(barvlDtInt.toMinSec()) 후 도착"
            } else {
                return info.arvlMsg2
            }
        }
    }
    
    init(info: RealtimeArrivalInfo) {
        self.info = info
    }
}
