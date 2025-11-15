//
//  CoffeeResponse.swift
//  CoffeePrincess
//
//  Created by 김나영 on 11/16/25.
//

import Foundation
/// (GET) 커피 기록 조회를 위해 서버에서 **받는** 모델 ("results" 필드)
struct TodayCoffeeResponse: Codable {
    let coffeeItemResponseList: [CoffeeItemResponse]
}

/// (GET) "coffeeItemResponseList" 배열의 각 항목
struct CoffeeItemResponse: Codable {
    let coffeeId: Int
    let name: String
    let drinkDate: String
    let drinkTime: String
    let caffeineAmount: Int
}

/// (POST) 커피 기록 생성을 위해 서버에 **보내는** 모델
struct CoffeeRecord: Codable {
    /// "YYYY-MM-DD"
    let drinkDate: String
    
    /// "HH:mm"
    let drinkTime: String
    
    let coffeeName: String
    let caffeineAmount: Int
    
    enum CodingKeys: String, CodingKey {
        case drinkDate
        case drinkTime
        case coffeeName
        case caffeineAmount
    }
}
