//
//  StationBookMark.swift
//  SubwayArrivalWidget
//
//  Created by J_Min on 2023/07/04.
//

import Foundation

struct StationBookMark {
    static let key = "StationBookMark"
    
    private init() { }
    
    static func getStationBookMark() -> [String] {
        UserDefaults.standard.array(forKey: StationBookMark.key) as? [String] ?? []
    }
    
    static func setStateionBookMark(stationCode: String) {
        var stations = StationBookMark.getStationBookMark()
        if stations.contains(stationCode) {
            stations.removeAll { $0 == stationCode }
        } else {
            stations.append(stationCode)
        }
        UserDefaults.standard.set(stationCode, forKey: StationBookMark.key)
    }
    
    static func isStationBookMark(stationCode: String) -> Bool {
        getStationBookMark().contains(stationCode)
    }
}
