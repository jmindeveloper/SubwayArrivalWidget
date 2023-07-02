//
//  Network.swift
//  SubwayArrivalWidget
//
//  Created by J_Min on 2023/06/18.
//

import Foundation
import Combine

enum NetworkError: Error {
    case wrongURL
    case response(code: Int)
    case decodingError(error: DecodingError)
    case wrappedError(error: Error)
}

protocol RealTimeArrivalProtocol {
    func getArrivalData(_ subway: String) -> AnyPublisher<SubwayArrival, NetworkError>
}

final class RealTimeArrivalManager: RealTimeArrivalProtocol {
    private let session = URLSession(configuration: .default)
    private let apiKey = APIKey.apiKey
    private lazy var baseURLString: String = "http://swopenapi.seoul.go.kr/api/subway/\(apiKey)/json/realtimeStationArrival/0/10/"
    
    func getArrivalData(_ subway: String) -> AnyPublisher<SubwayArrival, NetworkError> {
        guard let urlString = (baseURLString + subway).encodeUrl(),
              let url = URL(string: urlString) else {
            return Fail(error: NetworkError.wrongURL).eraseToAnyPublisher()
        }
        
        return session.dataTaskPublisher(for: url)
            .tryMap { (data, response) -> Data in
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
            .decode(type: SubwayArrival.self, decoder: JSONDecoder())
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
