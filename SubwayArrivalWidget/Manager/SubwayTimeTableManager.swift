//
//  SubwayTimeTableManager.swift
//  SubwayArrivalWidget
//
//  Created by J_Min on 2023/07/02.
//

import Foundation
import Combine

protocol SubwayTimeTableProtocol {
    func getTimeTabel(_ code: String, day: TimeTableDay, isUp: UPDNLine) -> AnyPublisher<SubwayTimeTable, NetworkError>
}

final class SubwayTimeTableManager: SubwayTimeTableProtocol {
    private let session = URLSession(configuration: .default)
    private let apiKey = APIKey.apiKey
    private lazy var baseURLString: String = "http://openapi.seoul.go.kr:8088/\(apiKey)/json/SearchSTNTimeTableByFRCodeService/1/100/"
    
    func getTimeTabel(
        _ code: String,
        day: TimeTableDay,
        isUp: UPDNLine
    ) -> AnyPublisher<SubwayTimeTable, NetworkError> {
        let urlString = baseURLString + "\(code)/" + "\(day.code)/" + "\(isUp.code)"
        guard let url = URL(string: urlString) else {
            return Fail(error: NetworkError.wrongURL).eraseToAnyPublisher()
        }
        
        return session.dataTaskPublisher(for: url)
            .tryMap { (data, response) in
                if let response = response as? HTTPURLResponse {
                    if response.statusCode != 200 {
                        throw NetworkError.response(code: response.statusCode)
                    } else {
                        return data
                    }
                } else {
                    throw NetworkError.response(code: -1)
                }
            }
            .decode(type: SubwayTimeTable.self, decoder: JSONDecoder())
            .mapError { error in
                if let error = error as? DecodingError {
                    return NetworkError.decodingError(error: error)
                } else if let error = error as? NetworkError {
                    return error
                } else {
                    return NetworkError.wrappedError(error: error)
                }
            }
            .retry(3)
            .eraseToAnyPublisher()
    }
}
