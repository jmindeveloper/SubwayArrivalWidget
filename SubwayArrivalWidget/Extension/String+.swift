//
//  String+.swift
//  SubwayArrivalWidget
//
//  Created by J_Min on 2023/06/18.
//

import Foundation

extension String {
    func encodeUrl() -> String? {
        return self.addingPercentEncoding( withAllowedCharacters: .urlQueryAllowed)
    }
    func decodeUrl() -> String? {
        return self.removingPercentEncoding
    }
}
