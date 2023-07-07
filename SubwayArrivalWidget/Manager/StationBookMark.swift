//
//  StationBookMark.swift
//  SubwayArrivalWidget
//
//  Created by J_Min on 2023/07/04.
//

import Foundation
import Combine

struct StationBookMark {
    static let key = "StationBookMark"
    static let chaingeStationBookMarkListPublisher = PassthroughSubject<Void, Never>()
    
    private init() { }
    
    static func getStationBookMark() -> [Station] {
        guard let data = UserDefaults.standard.data(forKey: StationBookMark.key) else {
            return []
        }
        
        do {
            return try JSONDecoder().decode([Station].self, from: data)
        } catch {
            return []
        }
    }
    
    @discardableResult
    static func setStationBookMark(station: Station) -> Bool {
        var currentBookMarkStations = StationBookMark.getStationBookMark()
        var isAppend: Bool = false
        
        if currentBookMarkStations.contains(where: {
            $0.stationCode == station.stationCode
        }) {
            currentBookMarkStations.removeAll { $0.stationCode == station.stationCode }
        } else {
            currentBookMarkStations.append(station)
            isAppend = true
        }
        
        do {
            let data = try JSONEncoder().encode(currentBookMarkStations)
            UserDefaults.standard.set(data, forKey: StationBookMark.key)
            StationBookMark.chaingeStationBookMarkListPublisher.send()
        } catch {
            return false
        }
        
        return isAppend
    }
    
    static func isStationBookMark(station: Station) -> Bool {
        getStationBookMark().contains {
            $0.stationCode == station.stationCode
        }
    }
}
