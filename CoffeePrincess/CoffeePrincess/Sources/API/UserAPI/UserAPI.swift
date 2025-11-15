//
//  UserAPI.swift
//  CoffeePrincess
//
//  Created on 11/16/25.
//

import Foundation
import Moya

enum UserAPI {
    /// (GET) 사용자 정보 조회
    case getUserInfo
    
    /// (POST) 사용자 정보 수정
    case updateUserInfo(userInfo: UserInfo)
}

extension UserAPI: TargetType {

    /// API의 기본 URL입니다.
    var baseURL: URL {
        return URL(string: "http://3.88.245.234/api/v1")!
    }

    /// 기본 URL 뒤에 붙는 경로입니다.
    var path: String {
        switch self {
        case .getUserInfo, .updateUserInfo:
            return "/user"
        }
    }

    /// HTTP 메서드
    var method: Moya.Method {
        switch self {
        case .getUserInfo:
            return .get
        case .updateUserInfo:
            return .post
        }
    }

    /// 요청(Request)의 본문(Body)과 파라미터
    var task: Task {
        switch self {
        case .getUserInfo:
            // GET 요청이므로 파라미터가 없습니다.
            return .requestPlain
            
        case .updateUserInfo(let userInfo):
            // UserInfo 모델을 JSON으로 인코딩하여 body에 추가합니다.
            // "Content-Type: application/json" 헤더가 자동으로 추가됩니다.
            return .requestJSONEncodable(userInfo)
        }
    }

    /// 커스텀 HTTP 헤더
    var headers: [String: String]? {
        // 1. AuthManager에서 현재 토큰을 가져옵니다.
        // (로그인 전이면 devToken, 로그인 후면 실제 토큰)
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
        case .updateUserInfo:
            commonHeaders["Origin"] = "http://3.88.245.234"
        case .getUserInfo:
            break // GET 요청에는 Origin 헤더가 없었음
        }
        
        // 참고: "Content-Type"은 'task'가 .requestJSONEncodable이므로
        // Moya가 자동으로 "application/json"을 추가해줍니다.
        
        return commonHeaders
    }
}
