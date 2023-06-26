//
//  SubwayStation.swift
//  SubwayArrivalWidget
//
//  Created by J_Min on 2023/06/18.
//

import SwiftUI

struct SubwayStation: Codable {
    let stationList: [Station]

    enum CodingKeys: String, CodingKey {
        case stationList = "DATA"
    }
}

// MARK: - Datum
struct Station: Codable, Hashable {
    /// 호선
    let lineNum: LineNum
    /// 전철역 코드
    let stationCode: String
    /// 전철역 이름
    let stationName: String
    /// 외부코드
    let frCode: String

    enum CodingKeys: String, CodingKey {
        case lineNum = "line_num"
        case stationCode = "station_cd"
        case stationName = "station_nm"
        case frCode = "fr_code"
    }
}

enum LineNum: String, Codable {
    case lineFirst = "01호선"
    case lineSecond = "02호선"
    case lineThird = "03호선"
    case lineFour = "04호선"
    case lineFive = "05호선"
    case lineSix = "06호선"
    case lineSeven = "07호선"
    case lineEighth = "08호선"
    case lineNine = "09호선"
    case 경강선 = "경강선"
    case 경의선 = "경의선"
    case 경춘선 = "경춘선"
    case 공항철도 = "공항철도"
    case 김포도시철도 = "김포도시철도"
    case 서해선 = "서해선"
    case 수인분당선 = "수인분당선"
    case 신림선 = "신림선"
    case 신분당선 = "신분당선"
    case 용인경전철 = "용인경전철"
    case 우이신설경전철 = "우이신설경전철"
    case 의정부경전철 = "의정부경전철"
    case 인천2호선 = "인천2호선"
    case 인천선 = "인천선"
    
    var str: String {
        return self.rawValue.replacingOccurrences(of: "0", with: "")
    }
    
    var lineColor: Color? {
        switch self {
        case .lineFirst:
            return Color(hex: "#0052A4")
        case .lineSecond:
            return Color(hex: "#00A84D")
        case .lineThird:
            return Color(hex: "#EF7C1C")
        case .lineFour:
            return Color(hex: "#00A5DE")
        case .lineFive:
            return Color(hex: "#996CAC")
        case .lineSix:
            return Color(hex: "#CD7C2F")
        case .lineSeven:
            return Color(hex: "#747F00")
        case .lineEighth:
            return Color(hex: "#E6186C")
        case .lineNine:
            return Color(hex: "#BB8336")
        case .경강선:
            return Color(hex: "#003DA5")
        case .경의선:
            return Color(hex: "#77C4A3")
        case .경춘선:
            return Color(hex: "#0C8E72")
        case .공항철도:
            return Color(hex: "#0065B3")
        case .김포도시철도:
            return Color(hex: "#A17800")
        case .서해선:
            return Color(hex: "#81A914")
        case .수인분당선:
            return Color(hex: "#F5A200")
        case .신림선:
            return Color(hex: "#6789CA")
        case .신분당선:
            return Color(hex: "#D4003B")
        case .용인경전철:
            return Color(hex: "#509F22")
        case .우이신설경전철:
            return Color(hex: "#B7C452")
        case .의정부경전철:
            return Color(hex: "#FDA600")
        case .인천2호선:
            return Color(hex: "#ED8B00")
        case .인천선:
            return Color(hex: "#7CA8D5")
        }
    }
}
