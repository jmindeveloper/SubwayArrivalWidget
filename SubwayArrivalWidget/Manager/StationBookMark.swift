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
    
    @discardableResult
    static func setStationBookMark(stationCode: String) -> Bool {
        var stations = StationBookMark.getStationBookMark()
        var isAppend: Bool = false
        if stations.contains(stationCode) {
            stations.removeAll { $0 == stationCode }
        } else {
            stations.append(stationCode)
            isAppend = true
        }
        
        UserDefaults.standard.set(stations, forKey: StationBookMark.key)
        print("is this Station bookMark --> ", isStationBookMark(stationCode: stationCode))
        return isAppend
    }
    
    static func isStationBookMark(stationCode: String) -> Bool {
        getStationBookMark().contains(stationCode)
    }
}
