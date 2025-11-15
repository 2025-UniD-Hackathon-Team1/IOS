//
//  AuthAPI.swift
//  CoffeePrincess
//
//  Created by 김나영 on 11/16/25.
//

import Foundation
import Moya

// 'AuthRouter'는 인증 관련 API 엔드포인트를 정의합니다.
enum AuthAPI {
    // 로그인 케이스, 필요한 파라미터를 받습니다.
    case login(username: String, password: String)
    
    // TODO: 여기에 다른 인증 API (예: .register, .logout)를 추가할 수 있습니다.
}

// MARK: - TargetType Protocol
extension AuthAPI: TargetType {

    /// API의 기본 URL입니다.
    var baseURL: URL {
        return URL(string: "http://3.88.245.234/api/v1")!
    }

    /// 기본 URL 뒤에 붙는 경로입니다.
    var path: String {
        switch self {
        case .login:
            return "/auth/login"
        }
    }

    /// HTTP 메서드 (GET, POST, etc.)
    var method: Moya.Method {
        switch self {
        case .login:
            return .post
        }
    }

    /// 요청(Request)의 본문(Body)과 파라미터를 정의합니다.
    var task: Task {
        switch self {
        case .login(let username, let password):
            // 요청 파라미터
            let parameters: [String: Any] = [
                "username": username,
                "password": password
            ]
            
            // .requestParameters는 파라미터를 JSON으로 인코딩하고
            // "Content-Type: application/json" 헤더를 자동으로 추가합니다.
            return .requestParameters(parameters: parameters, encoding: JSONEncoding.default)
        }
    }

    /// 커스텀 HTTP 헤더를 정의합니다.
    var headers: [String: String]? {
        // 참고: "Content-Type" 헤더는 'task'에서 JSONEncoding.default를
        // 사용했기 때문에 Moya가 자동으로 추가해 줍니다.
        // 원본 요청에 있던 나머지 헤더들을 여기에 추가합니다.
        return [
            "Accept-Language": "ko-KR,ko;q=0.9,en-US;q=0.8,en;q=0.7",
            "Connection": "keep-alive",
            "Origin": "http://3.88.245.234",
            "Referer": "http://3.88.245.234/swagger-ui/index.html",
            "User-Agent": "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36",
            "accept": "*/*"
        ]
    }

    /// 테스트용 샘플 데이터를 제공합니다.
    var sampleData: Data {
        // 로그인 성공 시 예상되는 Mock Response를 여기에 정의할 수 있습니다.
        // 예: "{\"token\": \"exampleToken\"}".data(using: .utf8)!
        return Data()
    }
}

