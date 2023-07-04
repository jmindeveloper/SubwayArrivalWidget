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
    var subwayArrivalInfo: SubwayArrival? { get set }
    var upSubwayArrivalInfo: [RealtimeArrivalInfo] { get set }
    var downSubwayArrivalInfo: [RealtimeArrivalInfo] { get set }
    var fetchTime: Date { get set }
    var subwayTimeTableInfo: [Dictionary<String, [TimeTableRow]>.Element] { get set }
    var isUp: Bool { get set }
    var isRealtimeArrival: Bool { get set }
    var station: Station { get set }
    var lineColor: Color { get }
    var stationName: String { get }
}

final class SubwayArrivalViewModel: SubwayArrivalViewModelInterface {
    @Published var subwayArrivalInfo: SubwayArrival?
    @Published var upSubwayArrivalInfo: [RealtimeArrivalInfo] = []
    @Published var downSubwayArrivalInfo: [RealtimeArrivalInfo] = []
    @Published var subwayTimeTableInfo: [Dictionary<String, [TimeTableRow]>.Element] = []
    private var upSubwayTimeTableInfo: SubwayTimeTable? = nil {
        didSet {
            subwayTimeTableInfo = groupTimeTableByHour(upSubwayTimeTableInfo?.timeTable.row ?? [])
        }
    }
    private var downSubwayTimeTableInfo: SubwayTimeTable? = nil {
        didSet {
            subwayTimeTableInfo = groupTimeTableByHour(downSubwayTimeTableInfo?.timeTable.row ?? [])
        }
    }
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
                    } else {
                        subwayTimeTableInfo = groupTimeTableByHour(upSubwayTimeTableInfo?.timeTable.row ?? [])
                    }
                } else {
                    if downSubwayTimeTableInfo == nil {
                        getSubwayTimeTableData(station.stationCode)
                    } else {
                        subwayTimeTableInfo = groupTimeTableByHour(downSubwayTimeTableInfo?.timeTable.row ?? [])
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
    
    private func groupTimeTableByHour(_ row: [TimeTableRow]) -> [Dictionary<String, [TimeTableRow]>.Element] {
        var rowDic = [String: [TimeTableRow]]()
        
        for r in row {
            let arrivalTime: String = {
                if r.arrivetime == "00:00:00" {
                    return r.lefttime
                } else {
                    return r.arrivetime
                }
            }()
            
            let prefix = String(arrivalTime.prefix(2))
            var timeTable = rowDic[prefix] ?? []
            timeTable.append(r)
            rowDic[prefix] = timeTable
        }
        let rowDicArr = rowDic.sorted { $0.key < $1.key }
        
        return rowDicArr
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
