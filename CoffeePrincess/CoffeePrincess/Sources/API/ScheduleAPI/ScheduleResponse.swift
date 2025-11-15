//
//  ScheduleResponse.swift
//  CoffeePrincess
//
//  Created by 김나영 on 11/16/25.
//

import Foundation
/// JSON 2의 "results" 필드에 해당하는 모델
struct ScheduleListResponse: Codable {
    let scheduleItemResponseList: [ScheduleItemResponse]
}

/// "scheduleItemResponseList" 배열의 각 항목에 해당하는 모델
struct ScheduleItemResponse: Codable {
    let scheduleId: Int
    let name: String
    
    /// "YYYY-MM-DD"
    let date: String
    
    /// "HH:mm:ss"
    let time: String
}

/// 일정 생성(POST) 시 body에 사용되는 모델
struct ScheduleRecord: Codable {
    /// "HH:mm"
    let time: String
    
    /// "YYYY-MM-DD"
    let date: String
    
    let name: String
    
    enum CodingKeys: String, CodingKey {
        case time
        case date
        case name
    }
}
