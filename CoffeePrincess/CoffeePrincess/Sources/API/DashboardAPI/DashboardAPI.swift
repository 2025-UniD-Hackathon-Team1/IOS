//
//  DashboardAPI.swift
//  CoffeePrincess
//
//  Created on 11/16/25.
//

import Foundation
import Moya

enum DashboardAPI {
    /// (GET) 현재 카페인 정보 조회
    /// - Parameter currentTime: "YYYY-MM-DDTHH:mm:ss" ISO 8601 형식
    case getCaffeineInfo(currentTime: String)
    
    /// (GET) 현재 각성 정보 조회
    /// - Parameter currentTime: "YYYY-MM-DDTHH:mm:ss" ISO 8601 형식
    case getAlertnessInfo(currentTime: String)
}

extension DashboardAPI: TargetType {

    /// API의 기본 URL
    var baseURL: URL {
        return URL(string: "http://3.88.245.234/api/v1")!
    }

    /// 기본 URL 뒤에 붙는 경로
    var path: String {
        switch self {
        case .getCaffeineInfo:
            return "/coffee/caffeine"
        case .getAlertnessInfo:
            return "/coffee/alertness"
        }
    }

    /// HTTP 메서드
    var method: Moya.Method {
        switch self {
        case .getCaffeineInfo, .getAlertnessInfo:
            return .get
        }
    }

    /// 요청(Request)의 본문(Body)과 파라미터
    var task: Task {
        let parameters: [String: Any]
        
        switch self {
        case .getCaffeineInfo(let currentTime):
            // 쿼리 파라미터로 ?currentTime=... 추가
            parameters = ["currentTime": currentTime]
            
        case .getAlertnessInfo(let currentTime):
            // 쿼리 파라미터로 ?currentTime=... 추가
            parameters = ["currentTime": currentTime]
        }
        
        return .requestParameters(parameters: parameters, encoding: URLEncoding.queryString)
    }

    /// 커스텀 HTTP 헤더
    var headers: [String: String]? {
        // 1. AuthManager에서 현재 토큰 가져오기
        let token = AuthManager.shared.accessToken
        
        // 2. 모든 요청에 공통으로 필요한 헤더
        return [
            "Authorization": "Bearer \(token)",
            "Accept-Language": "ko-KR,ko;q=0.9,en-US;q=0.8,en;q=0.7",
            "Connection": "keep-alive",
            "Referer": "http://3.88.245.234/swagger-ui/index.html",
            "User-Agent": "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36",
            "accept": "*/*"
        ]
    }
}
