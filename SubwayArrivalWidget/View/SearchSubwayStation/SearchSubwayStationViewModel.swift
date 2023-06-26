//
//  SearchSubwayStationViewModel.swift
//  SubwayArrivalWidget
//
//  Created by J_Min on 2023/06/18.
//

import Foundation
import Combine

protocol SearchSubwayStationViewModelInterface: ObservableObject {
    var searchSubwayStationName: String { get set }
    var allStationList: [String: [Station]] { get set }
    var searchStationList: [String: [Station]] { get set }
    var lineNumbers: [String] { get set }
}

class SearchSubwayStationViewModel: SearchSubwayStationViewModelInterface {
    @Published var searchSubwayStationName: String = ""
    private var allStation: [Station] = []
    @Published var allStationList: [String: [Station]] = [:]
    @Published var searchStationList: [String: [Station]] = [:]
    @Published var lineNumbers: [String] = []
    
    private var subscriptions = Set<AnyCancellable>()
    
    init() {
        binding()
        fetchSubwayStationList()
    }
    
    private func binding() {
        $searchSubwayStationName
            .debounce(for: 1.5, scheduler: DispatchQueue.main)
            .sink { [weak self] text in
                guard let self = self else { return }
                let filterStation = self.allStation.filter { station in
                    station.stationName.contains(text)
                }
                if !filterStation.isEmpty {
                    self.searchStationList = splitToLineNum(stations: filterStation)
                } else {
                    self.lineNumbers = self.allStationList.keys.sorted()
                }
            }.store(in: &subscriptions)
    }
    
    private func fetchSubwayStationList() {
        guard let dataURL = Bundle.main.url(forResource: "subway_station", withExtension: "json") else {
            return
        }
        let decoder = JSONDecoder()
        do {
            let data = try Data(contentsOf: dataURL)
            let subwayStation = try decoder.decode(SubwayStation.self, from: data)
            
            allStation = subwayStation.stationList
            allStationList = splitToLineNum(stations: allStation)
            print(allStationList)
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func splitToLineNum(stations: [Station]) -> [String: [Station]] {
        var dic: [String: [Station]] = [:]
        for station in stations {
            let lineNum = station.lineNum.str
            if var stations = dic[lineNum] {
                stations.append(station)
                dic[lineNum] = stations
            } else {
                dic[lineNum] = [station]
            }
        }
        lineNumbers = dic.keys.sorted()
        return dic
    }
}
