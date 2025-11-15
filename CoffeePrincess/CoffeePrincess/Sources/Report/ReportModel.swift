//
//  ReportModel.swift
//  CoffeePrincess
//
//  Created by 김나영 on 11/16/25.
//

import Foundation

struct ReportData: Codable, Equatable {
    
    /// e.g., "20대"
    let ageGroup: String
    
    /// e.g., "여성"
    let gender: String
    
    /// e.g., 20
    let comparisonPercentage: Int
    
    /// e.g., "많습니다", "적습니다", "비슷합니다"
    let comparisonStatus: String
    
    /// e.g., 6
    let timeBeforeSleep: Int
    
    /// e.g., 1 (1시간), 0 (30분)
    let timeBeforePeak: Int
    
    /// JSON의 snake_case 키를 Swift의 camelCase 프로퍼티로 매핑합니다.
    enum CodingKeys: String, CodingKey {
        case ageGroup = "age_group"
        case gender
        case comparisonPercentage = "comparison_percentage"
        case comparisonStatus = "comparison_status"
        case timeBeforeSleep = "time_before_sleep"
        case timeBeforePeak = "time_before_peak"
    }
}

struct UserInfo: Codable, Equatable {
    /// 성별 (male, female, other)
    var gender: String
    
    /// 나이
    var age: Int
    
    /// 희망 취침 시간 (HH:mm 형식)
    var bedtime: String
    
    /// Equatable 프로토콜 준수를 위한 비교 함수
    static func == (lhs: UserInfo, rhs: UserInfo) -> Bool {
        return lhs.gender == rhs.gender &&
               lhs.age == rhs.age &&
               lhs.bedtime == rhs.bedtime
    }
    
    /// 초기값을 설정한 init (필요에 따라 사용)
    init(gender: String = "", age: Int = 0, bedtime: String = "23:30") {
        self.gender = gender
        self.age = age
        self.bedtime = bedtime
    }
}
