//
//  SubwayArrivalViewModel.swift
//  SubwayArrivalWidget
//
//  Created by J_Min on 2023/06/28.
//

import Foundation
import Combine

protocol SubwayArrivalViewModelInterface: ObservableObject {
    func getSubwayArrivalData(_ stationName: String)
    var subwayArrivalInfo: SubwayArrival? { get set }
}

final class SubwayArrivalViewModel: SubwayArrivalViewModelInterface {
    @Published var subwayArrivalInfo: SubwayArrival?
    private let subwayArrivalManager: SubwayArrivalProtocol = SubwayArrivalManager()
    private var subscriptions = Set<AnyCancellable>()
    
    func getSubwayArrivalData(_ stationName: String) {
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
                print("sakdlfjsd --> ", arrival.realtimeArrivalList.first?.trainLineNm)
            }.store(in: &subscriptions)

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