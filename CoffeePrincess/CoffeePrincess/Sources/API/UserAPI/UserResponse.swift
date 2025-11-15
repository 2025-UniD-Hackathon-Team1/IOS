//
//  UserResponse.swift
//  CoffeePrincess
//
//  Created by 김나영 on 11/16/25.
//

import Foundation

/// "results": {} 를 디코딩하기 위한 빈 모델
struct EmptyResponse: Codable {}

/// "results": { ... } 를 디코딩하기 위한 사용자 정보 모델
struct UserInfo: Codable {
    let gender: String
    let age: Int
    let sleepTime: String
}
