//
//  SubwayTimeTableInfoViewModel.swift
//  SubwayArrivalWidget
//
//  Created by J_Min on 2023/07/03.
//

import Foundation

protocol SubwayTimeTableInfoViewModelInterface: ObservableObject {
    var destination: String { get }
    var isExpress: Bool { get }
    var time: String { get }
}
 
final class SubwayTimeTableInfoViewModel: SubwayTimeTableInfoViewModelInterface {
    private var info: TimeTableRow
    var destination: String {
        return info.subwayename
    }
    
    var isExpress: Bool {
        return info.expressYn == "D"
    }
    
    var time: String {
        if info.arrivetime == "00:00:00" {
            return info.lefttime
        } else {
            return info.arrivetime
        }
    }
    
    init(info: TimeTableRow) {
        self.info = info
    }
    
}
