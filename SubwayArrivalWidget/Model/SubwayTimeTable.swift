//
//  SubwayTimeTable.swift
//  SubwayArrivalWidget
//
//  Created by J_Min on 2023/07/02.
//

import Foundation

struct SubwayTimeTable: Codable {
    let timeTable: SearchSTNTimeTableByIDService

    enum CodingKeys: String, CodingKey {
        case timeTable = "SearchSTNTimeTableByIDService"
    }
}

struct SearchSTNTimeTableByIDService: Codable {
    let listTotalCount: Int
    let result: Result
    let row: [TimeTableRow]

    enum CodingKeys: String, CodingKey {
        case listTotalCount = "list_total_count"
        case result = "RESULT"
        case row
    }
}

struct Result: Codable {
    let code, message: String

    enum CodingKeys: String, CodingKey {
        case code = "CODE"
        case message = "MESSAGE"
    }
}

struct TimeTableRow: Codable, Identifiable {
    let id: String = UUID().uuidString
    /// 호선
    let lineNum: String
    /// 외부코드
    let frCode: String
    /// 전철역 코드
    let stationCD: String
    /// 전철역 이름
    let stationNm: String
    /// 열차번호
    let trainNo: String
    /// 도착시간
    let arrivetime: String
    /// 출발시간
    let lefttime: String
    /// 출발 지하철역 코드
    let originstation: String
    /// 도착 지하철역 코드
    let deststation: String
    /// 출발지하철역 이름
    let subwaysname: String
    /// 도착지하철역 이름
    let subwayename: String
    /// 요일
    let weekTag: String
    /// 상/하행선
    let inoutTag: String
    /// 플러그
    let flFlag: String
    /// 도착역 코드2
    let deststation2: String
    /// 급행선
    let expressYn: String
    /// 지선
    let branchLine: String

    enum CodingKeys: String, CodingKey {
        case lineNum = "LINE_NUM"
        case frCode = "FR_CODE"
        case stationCD = "STATION_CD"
        case stationNm = "STATION_NM"
        case trainNo = "TRAIN_NO"
        case arrivetime = "ARRIVETIME"
        case lefttime = "LEFTTIME"
        case originstation = "ORIGINSTATION"
        case deststation = "DESTSTATION"
        case subwaysname = "SUBWAYSNAME"
        case subwayename = "SUBWAYENAME"
        case weekTag = "WEEK_TAG"
        case inoutTag = "INOUT_TAG"
        case flFlag = "FL_FLAG"
        case deststation2 = "DESTSTATION2"
        case expressYn = "EXPRESS_YN"
        case branchLine = "BRANCH_LINE"
    }
}
