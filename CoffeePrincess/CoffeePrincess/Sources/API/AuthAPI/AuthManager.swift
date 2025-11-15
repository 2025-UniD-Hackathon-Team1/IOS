//
//  AuthManager.swift
//  CoffeePrincess
//
//  Created on 11/3/25.
//

import Foundation

final class AuthManager {
    static let shared = AuthManager()
    
    // UserDefaults에서 사용할 키
    private let accessTokenKey = "accessToken"
    
    // 개발용 하드코딩 토큰 (Fallback용)
    private let devToken = "eyJhbGciOiJIUzUxMiJ9.eyJzdWIiOiIxIiwiaWF0IjoxNzYzMjM1NjMwLCJleHAiOjE3NjMyNTM2MzB9.l34StwMovhieK0u2r4hoccfPCi1v-Y21nNwL1fYSG4Qgu-6YlRtX-01TQAulIIRHsl7f_M6cF2GH6ZGfEBVgKQ"

    private init() {}

    /// 현재 액세스 토큰을 반환합니다.
    /// (UserDefaults에 저장된 실제 토큰이 있으면 반환, 없으면 개발용 토큰 반환)
    var accessToken: String {
        return UserDefaults.standard.string(forKey: accessTokenKey) ?? devToken
    }
    
    /// 로그인 성공 시 실제 토큰을 UserDefaults에 저장합니다.
    func saveToken(_ token: String) {
        UserDefaults.standard.setValue(token, forKey: accessTokenKey)
    }
    
    /// 로그아웃 시 저장된 토큰을 삭제합니다.
    func clearToken() {
        UserDefaults.standard.removeObject(forKey: accessTokenKey)
    }
}
