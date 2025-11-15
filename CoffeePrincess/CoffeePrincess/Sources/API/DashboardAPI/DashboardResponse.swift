//
//  DashboardResponse.swift
//  CoffeePrincess
//
//  Created by 김나영 on 11/16/25.
//

import Foundation

/// JSON 1의 "results" 필드에 해당하는 모델
struct CaffeineInfoResponse: Codable {
    let currentCaffeine: Double
    let graph: [CaffeineGraphPoint]
}

/// "graph" 배열의 각 항목에 해당하는 모델
struct CaffeineGraphPoint: Codable {
    /// "HH:mm" 형식
    let time: String
    
    /// (570, 507.8 등) Int와 Double이 섞여있으므로 Double로 받습니다.
    let caffeine: Double
}


/// JSON 2의 "results" 필드에 해당하는 모델
struct AlertnessInfoResponse: Codable {
    let currentAlertness: Double
    
    /// "YYYY-MM-DD HH:mm:ss" 형식
    let alertnessEndTime: String
}
