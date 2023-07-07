//
//  SubwayArrivalViewModel.swift
//  SubwayArrivalWidget
//
//  Created by J_Min on 2023/06/28.
//

import SwiftUI
import Combine

protocol SubwayArrivalViewModelInterface: ObservableObject {
    func getSubwayArrivalData()
    func getSubwayTimeTableData(_ stationCode: String)
    func setStationBookMark()
    var subwayArrivalInfo: SubwayArrival? { get set }
    var upSubwayArrivalInfo: [RealtimeArrivalInfo] { get set }
    var downSubwayArrivalInfo: [RealtimeArrivalInfo] { get set }
    var fetchTime: Date { get set }
    var upSubwayTimeTableInfo: SubwayTimeTable? { get set }
    var downSubwayTimeTableInfo: SubwayTimeTable? { get set }
    var isUp: Bool { get set }
    var isRealtimeArrival: Bool { get set }
    var station: Station { get set }
    var lineColor: Color { get }
    var stationName: String { get }
    var isStationBookMark: Bool { get set }
}

final class SubwayArrivalViewModel: SubwayArrivalViewModelInterface {
    @Published var subwayArrivalInfo: SubwayArrival?
    @Published var upSubwayArrivalInfo: [RealtimeArrivalInfo] = []
    @Published var downSubwayArrivalInfo: [RealtimeArrivalInfo] = []
    @Published var upSubwayTimeTableInfo: SubwayTimeTable? = nil
    @Published var downSubwayTimeTableInfo: SubwayTimeTable? = nil
    var fetchTime: Date = Date()
    private let subwayArrivalManager: RealTimeArrivalProtocol = RealTimeArrivalManager()
    private let subwayTimeTableManager: SubwayTimeTableProtocol = SubwayTimeTableManager()
    private var subscriptions = Set<AnyCancellable>()
    @Published var station: Station
    @Published var isUp: Bool = true {
        didSet {
            if !isRealtimeArrival {
                if isUp {
                    if upSubwayTimeTableInfo == nil {
                        getSubwayTimeTableData(station.stationCode)
                    }
                } else {
                    if downSubwayTimeTableInfo == nil {
                        getSubwayTimeTableData(station.stationCode)
                    }
                }
            }
        }
    }
    var stationName: String {
        return station.stationName
    }
    var lineColor: Color {
        return station.lineNum.lineColor ?? .init(uiColor: .label)
    }
    @Published var isStationBookMark: Bool
    @Published var isRealtimeArrival: Bool = true {
        willSet {
            if newValue == false {
                if isUp {
                    if upSubwayTimeTableInfo == nil {
                        getSubwayTimeTableData(station.stationCode)
                    }
                } else {
                    if downSubwayTimeTableInfo == nil {
                        getSubwayTimeTableData(station.stationCode)
                    }
                }
            }
        }
    }
    
    init(station: Station) {
        self.station = station
        self.isStationBookMark = StationBookMark.isStationBookMark(station: station)
    }
    
    func getSubwayArrivalData() {
        subwayArrivalManager.getArrivalData(stationName)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] subscribe in
                switch subscribe {
                case .finished:
                    break
                case .failure(.wrongURL):
                    print("잘못된 URL")
                case .failure(.response(code: let code)):
                    print("statusCode --> ", code)
                case .failure(.wrappedError(error: let error)):
                    print(error.localizedDescription)
                case .failure(.decodingError(error: let error)):
                    self?.decodingError(error: error)
                }
            } receiveValue: { [weak self] arrival in
                self?.subwayArrivalInfo = arrival
                self?.upSubwayArrivalInfo = arrival.realtimeArrivalList.filter {
                    $0.updnLine.isUp
                }
                self?.downSubwayArrivalInfo = arrival.realtimeArrivalList.filter {
                    !$0.updnLine.isUp
                }
                self?.fetchTime = Date()
            }.store(in: &subscriptions)
    }
    
    func getSubwayTimeTableData(_ stationCode: String) {
        subwayTimeTableManager.getTimeTabel(stationCode, day: Date.getTimeTableDay(), isUp: isUp)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] subscribe in
                switch subscribe {
                case .finished:
                    break
                case .failure(.wrongURL):
                    print("잘못된 URL")
                case .failure(.response(code: let code)):
                    print("statusCode --> ", code)
                case .failure(.wrappedError(error: let error)):
                    print(error.localizedDescription)
                case .failure(.decodingError(error: let error)):
                    self?.decodingError(error: error)
                }
            } receiveValue: { [weak self] table in
                if self?.isUp == true {
                    self?.upSubwayTimeTableInfo = table
                } else {
                    self?.downSubwayTimeTableInfo = table
                }
            }.store(in: &subscriptions)
    }
    
    func setStationBookMark() {
        isStationBookMark = StationBookMark.setStationBookMark(station: station)
    }
    
    private func decodingError(error: Error) {
        if let decodingError = error as? DecodingError {
            switch decodingError {
            case .typeMismatch(let type, let context):
                print("Type '\(type)' mismatch:", context.debugDescription)
                print("codingPath:", context.codingPath)
            case .valueNotFound(let value, let context):
                print("Value '\(value)' not found:", context.debugDescription)
                print("codingPath:", context.codingPath)
            case .keyNotFound(let key, let context):
                print("Key '\(key)' not found:", context.debugDescription)
                print("codingPath:", context.codingPath)
            case .dataCorrupted(_):
                break
            @unknown default:
                fatalError()
            }
        } else {
            print("this is not decodingError")
        }
    }
}
