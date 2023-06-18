//
//  SubwayArrival.swift
//  SubwayArrivalWidget
//
//  Created by J_Min on 2023/06/18.
//

import Foundation

struct SubwayArrival: Codable {
    let errorMessage: ErrorMessage
    let realtimeArrivalList: [RealtimeArrivalList]
}

// MARK: - ErrorMessage
struct ErrorMessage: Codable {
    let status: Int
    let code: String
    let message: String
    let link: String
    let developerMessage: String
    let total: Int
}

// MARK: - RealtimeArrivalList
struct RealtimeArrivalList: Codable {
    let totalCount, rowNum, selectedCount: Int
    let subwayID: String
    let updnLine, trainLineNm: String
    let statnFid, statnTid, statnID, statnNm: String
    let trnsitCo, ordkey, subwayList, statnList: String
    let btrainSttus, barvlDt, btrainNo, bstatnID: String
    let bstatnNm, recptnDt, arvlMsg2, arvlMsg3: String
    let arvlCD: String

    enum CodingKeys: String, CodingKey {
        case totalCount, rowNum, selectedCount
        case subwayID = "subwayId"
        case updnLine, trainLineNm, statnFid, statnTid
        case statnID = "statnId"
        case statnNm, trnsitCo, ordkey, subwayList, statnList, btrainSttus, barvlDt, btrainNo
        case bstatnID = "bstatnId"
        case bstatnNm, recptnDt, arvlMsg2, arvlMsg3
        case arvlCD = "arvlCd"
    }
}
