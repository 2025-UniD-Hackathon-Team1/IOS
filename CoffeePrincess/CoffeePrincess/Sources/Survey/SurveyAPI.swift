//
//  SurveyAPI.swift
//  CoffeePrincess
//
//  Created by chohaeun on 11/16/25.
//

//
//  SurveyAPI.swift
//  CoffeePrincess
//

import Foundation
import Moya

enum SurveyAPI {
    case feedback(sleepDate: String, sleepTime: String, heartRate: Int)
}

extension SurveyAPI: TargetType {
    
    var baseURL: URL {
        // AuthAPI와 동일한 베이스 URL
        return URL(string: "http://3.88.245.234/api/v1")!
    }
    
    var path: String {
        switch self {
        case .feedback:
            return "/feedback"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .feedback:
            return .post
        }
    }
    
    var task: Task {
        switch self {
        case .feedback(let sleepDate, let sleepTime, let heartRate):
            let parameters: [String: Any] = [
                "sleepDate": sleepDate,
                "sleepTime": sleepTime,
                "heartRate": heartRate
            ]
            return .requestParameters(parameters: parameters, encoding: JSONEncoding.default)
        }
    }
    
    var headers: [String : String]? {
        var headers: [String: String] = [
            "Accept-Language": "ko-KR,ko;q=0.9,en-US;q=0.8,en;q=0.7",
            "Connection": "keep-alive",
            "Origin": "http://3.88.245.234",
            "Referer": "http://3.88.245.234/swagger-ui/index.html",
            "User-Agent": "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36",
            "accept": "*/*",
            "Content-Type": "application/json"
        ]
        
        // ✅ 여기! 로그인 토큰을 Authorization 헤더에 실어 보냄
        let token = AuthManager.shared.accessToken
        headers["Authorization"] = "Bearer \(token)"
        
        return headers
    }

    
    var sampleData: Data {
        return Data()
    }
}
