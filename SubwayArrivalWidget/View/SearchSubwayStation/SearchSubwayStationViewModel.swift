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
    var allStationList: [Station] { get set }
    var searchStationList: [Station] { get set }
}

class SearchSubwayStationViewModel: SearchSubwayStationViewModelInterface {
    @Published var searchSubwayStationName: String = ""
    @Published var allStationList: [Station] = []
    @Published var searchStationList: [Station] = [] {
        didSet {
            searchStationList.forEach {
                print($0.stationName)
            }
        }
    }
    
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
                let filterStation = self.allStationList.filter { station in
                    station.stationName.contains(text)
                }
                self.searchStationList = filterStation
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
            
            allStationList = subwayStation.stationList
        } catch {
            print(error.localizedDescription)
        }
    }
}
