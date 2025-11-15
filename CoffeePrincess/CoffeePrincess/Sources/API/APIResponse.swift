//
//  APIResponse.swift
//  CoffeePrincess
//
//  Created by 김나영 on 11/16/25.
//

import Foundation

/// 공통 API 응답 래퍼 모델
struct APIResponse<T: Codable>: Codable {
    let isSuccess: Bool
    let code: String
    let message: String
    let results: T
}
