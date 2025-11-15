//
//  UserInfoManager.swift
//  cafe_frame
//
//  Created by 김세은 on 11/15/25.
//

import Foundation

class UserInfoManager: ObservableObject {
    @Published var userInfo: UserInfo = UserInfo() {
        didSet {
            saveUserInfo()
        }
    }
    
    private let userInfoKey = "userInfo"
    
    init() {
        loadUserInfo()
    }
    
    func loadUserInfo() {
        if let data = UserDefaults.standard.data(forKey: userInfoKey),
           let decoded = try? JSONDecoder().decode(UserInfo.self, from: data) {
            self.userInfo = decoded
        }
    }
    
    func saveUserInfo() {
        if let encoded = try? JSONEncoder().encode(userInfo) {
            UserDefaults.standard.set(encoded, forKey: userInfoKey)
        }
    }
    
    func getCaffeineType() -> String {
        if userInfo.tolerance < 30 {
            return "민감형"
        } else if userInfo.tolerance < 70 {
            return "일반형"
        } else {
            return "둔감형"
        }
    }
    
    func getHeartRateText() -> String {
        switch userInfo.heartRate {
        case "often": return "자주 있음"
        case "sometimes": return "가끔 있음"
        case "rarely": return "거의 없음"
        case "never": return "없음"
        default: return "-"
        }
    }
    
    func getDefaultMaxCaffeine() -> Int {
        if userInfo.tolerance < 30 {
            return 100
        } else if userInfo.tolerance < 70 {
            return 140
        } else {
            return 200
        }
    }
}

