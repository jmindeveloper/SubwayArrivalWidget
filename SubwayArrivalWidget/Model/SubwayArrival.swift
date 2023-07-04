//
//  SubwayArrival.swift
//  SubwayArrivalWidget
//
//  Created by J_Min on 2023/06/18.
//

import Foundation

struct SubwayArrival: Codable {
    let errorMessage: ErrorMessage
    let realtimeArrivalList: [RealtimeArrivalInfo]
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
struct RealtimeArrivalInfo: Codable, Identifiable {
    let id: String = UUID().uuidString
    /// 총 데이터 건수
    let totalCount: Int
    let rowNum: Int
    let selectedCount: Int
    /// 지하철호선 id
    let subwayID: String
    /// 상하행선 구분 (0: 상행/내선, 1: 하행/외선)
    let updnLine: UPDNLine
    /// 도착지 방면
    let trainLineNm: String
    /// 이전지하철역 id
    let statnFid: String
    /// 다음지ㅎ철역 id
    let statnTid: String
    /// 지하철역 id
    let statnID: String
    /// 지하철역 이름
    let statnNm: String
    /// 환승노선수
    let trnsitCo: String
    /// 도착예정열차 순번
    let ordkey: String
    /// 연계호선id
    let subwayList: String
    /// 연계지하철역 id
    let statnList: String
    /// 열차번호
    let btrainSttus: String
    /// 도착예정시간
    let barvlDt: String
    /// 열차번호
    let btrainNo: String
    /// 종착지하철역 id
    let bstatnID: String
    /// 종착지하철역 이름
    let bstatnNm: String
    /// 정보 생성 시간
    let recptnDt: String
    /// 첫번째 도착 메세지
    let arvlMsg2: String
    /// 두번째 도착 메세지
    let arvlMsg3: String
    /// 도착코드
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
