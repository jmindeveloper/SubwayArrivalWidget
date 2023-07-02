//
//  SubwayTimeTable.swift
//  SubwayArrivalWidget
//
//  Created by J_Min on 2023/07/02.
//

import Foundation

struct SubwayTimeTable: Codable {
    let timeTable: SearchSTNTimeTableByFRCodeService

    enum CodingKeys: String, CodingKey {
        case timeTable = "SearchSTNTimeTableByFRCodeService"
    }
}

struct SearchSTNTimeTableByFRCodeService: Codable {
    let listTotalCount: Int
    let result: Result
    let row: [Row]

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

struct Row: Codable {
    let lineNum: String
    let frCode: String
    let stationCD: String
    let stationNm: String
    let trainNo: String
    let arrivetime: String
    let lefttime: String
    let originstation: String
    let deststation: String
    let subwaysname: String
    let subwayename: String
    let weekTag: String
    let inoutTag: String
    let flFlag: String
    let deststation2: String
    let expressYn: String
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
