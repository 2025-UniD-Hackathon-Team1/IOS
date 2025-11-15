//
//  CoffeeAPI.swift
//  CoffeePrincess
//
//  Created by 김나영 on 11/16/25.
//

import Foundation
import Moya

enum CoffeeAPI {
    /// (POST) 오늘의 커피 기록 추가
    case addCoffee(record: CoffeeRecord)
    
    /// (GET) 특정 날짜의 커피 기록 조회
    /// - Parameter date: "YYYY-MM-DD" 형식의 날짜 문자열
    case getTodayCoffee(date: String)
}

extension CoffeeAPI: TargetType {

    /// API의 기본 URL
    var baseURL: URL {
        return URL(string: "http://3.88.245.234/api/v1")!
    }

    /// 기본 URL 뒤에 붙는 경로
    var path: String {
        switch self {
        case .addCoffee:
            return "/coffee"
        case .getTodayCoffee:
            return "/coffee/today"
        }
    }

    /// HTTP 메서드
    var method: Moya.Method {
        switch self {
        case .addCoffee:
            return .post
        case .getTodayCoffee:
            return .get
        }
    }

    /// 요청(Request)의 본문(Body)과 파라미터
    var task: Task {
        switch self {
        case .addCoffee(let record):
            // CoffeeRecord 모델을 JSON으로 인코딩하여 body에 추가
            return .requestJSONEncodable(record)
            
        case .getTodayCoffee(let date):
            // 쿼리 파라미터로 ?date=2025-11-15 추가
            let parameters = ["date": date]
            return .requestParameters(parameters: parameters, encoding: URLEncoding.queryString)
        }
    }

    /// 커스텀 HTTP 헤더
    var headers: [String: String]? {
        // 1. AuthManager에서 현재 토큰 가져오기
        let token = AuthManager.shared.accessToken
        
        // 2. 모든 요청에 공통으로 필요한 헤더
        var commonHeaders: [String: String] = [
            "Authorization": "Bearer \(token)",
            "Accept-Language": "ko-KR,ko;q=0.9,en-US;q=0.8,en;q=0.7",
            "Connection": "keep-alive",
            "Referer": "http://3.88.245.234/swagger-ui/index.html",
            "User-Agent": "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36",
            "accept": "*/*"
        ]
        
        // 3. POST 요청에만 필요한 'Origin' 헤더 추가
        switch self {
        case .addCoffee:
            commonHeaders["Origin"] = "http://3.88.245.234"
        case .getTodayCoffee:
            break
        }
        
        // 참고: "Content-Type"은 'task'가 .requestJSONEncodable일 때
        // Moya가 "application/json"을 자동으로 추가해줍니다.
        
        return commonHeaders
    }
}
