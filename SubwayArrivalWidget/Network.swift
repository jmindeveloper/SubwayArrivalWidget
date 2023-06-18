//
//  Network.swift
//  SubwayArrivalWidget
//
//  Created by J_Min on 2023/06/18.
//

import Foundation
import Combine

enum SubwayArrivalError: Error {
    case wrongURL
    case response(code: Int)
    case decodingError(error: DecodingError)
    case wrappedError(error: Error)
}

protocol SubwayArrivalProtocol {
    func getArrivalData(_ subway: String) -> AnyPublisher<SubwayArrival, SubwayArrivalError>
}

final class SubwayArrivalManager: SubwayArrivalProtocol {
    private let session = URLSession(configuration: .default)
    private let apiKey = APIKey.apiKey
    private lazy var baseURLString: String = "http://swopenapi.seoul.go.kr/api/subway/\(apiKey)/json/realtimeStationArrival/0/5/"
    
    func getArrivalData(_ subway: String) -> AnyPublisher<SubwayArrival, SubwayArrivalError> {
        guard let urlString = (baseURLString + subway).encodeUrl(),
              let url = URL(string: urlString) else {
            return Fail(error: SubwayArrivalError.wrongURL).eraseToAnyPublisher()
        }
        
        return URLSession.shared.dataTaskPublisher(for: url)
            .tryMap { (data, response) -> Data in
                if let response = response as? HTTPURLResponse {
                    if response.statusCode != 200 {
                        throw SubwayArrivalError.response(code: response.statusCode)
                    } else {
                        return data
                    }
                } else {
                    throw SubwayArrivalError.response(code: -1)
                }
            }
            .decode(type: SubwayArrival.self, decoder: JSONDecoder())
            .mapError { error in
                if let error = error as? DecodingError {
                    return SubwayArrivalError.decodingError(error: error)
                } else if let error = error as? SubwayArrivalError {
                    return error
                } else {
                    return SubwayArrivalError.wrappedError(error: error)
                }
            }
            .retry(3)
            .eraseToAnyPublisher()
    }
    
}
