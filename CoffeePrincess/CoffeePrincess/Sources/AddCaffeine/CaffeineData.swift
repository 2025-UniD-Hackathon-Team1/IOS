//
//  CaffeineData.swift
//  CoffeePrincess
//
//  Created by 김나영 on 11/16/25.
//

import Foundation

/// 카페인 데이터베이스
struct CaffeineData {
    
    /// 에스프레소 1샷당 카페인 (샷 추가/제거 시 사용)
    static let caffeinePerShot: Int = 75
    
    /// (메뉴명, 사이즈) 2중 Dictionary로 데이터 저장
    /// "메뉴명": [ "사이즈" : 기본 카페인(mg) ]
    /// (CaffeineInfo 대신 Int를 직접 저장)
    static let starbucksMenuData: [String: [CoffeeSize: Int]] = [
        
        "아메리카노": [
            .tall: 150,
            .grande: 225,
            .venti: 300
        ],
        "카페 라떼": [
            .tall: 75,
            .grande: 150,
            .venti: 150
        ],
        "바닐라 라떼": [ // 카페 라떼와 동일
            .tall: 75,
            .grande: 150,
            .venti: 150
        ],
        "스타벅스 돌체 라떼": [ // 카페 라떼와 동일
            .tall: 75,
            .grande: 150,
            .venti: 150
        ],
        "플랫 화이트": [
            .tall: 130,
            .grande: 195,
            .venti: 195
        ],
        "카페 모카": [
            .tall: 95,
            .grande: 175,
            .venti: 190
        ],
        "콜드 브루": [ // 샷 기반 아님 (샷 추가 시 +75)
            .tall: 125,
            .grande: 155,
            .venti: 185
        ],
        "자바 칩 프라푸치노": [ // 샷 기반 아님 (샷 추가 시 +75)
            .tall: 85,
            .grande: 100,
            .venti: 130
        ],
        
        // --- (기타 메뉴) ---
        "믹스 커피": [
            .tall: 60, .grande: 60, .venti: 60
        ],
        "에너지 드링크": [
            .tall: 100, .grande: 100, .venti: 100
        ],
        "콜라": [
            .tall: 30, .grande: 30, .venti: 30
        ]
    ]
    
    /// (메뉴명, 사이즈)로 '기본 카페인'만 조회하는 헬퍼 함수
    static func getBaseCaffeine(for menuItem: MenuItem, size: CoffeeSize) -> Int {
        
        // "바닐라 라떼", "스타벅스 돌체 라떼"는 "카페 라떼"의 데이터를 사용하도록 매핑
        var menuName = menuItem.name
        if menuName == "바닐라 라떼" || menuName == "스타벅스 돌체 라떼" {
            menuName = "카페 라떼"
        }
        
        if let menuData = starbucksMenuData[menuName] {
            // 해당 사이즈 정보가 있으면 반환, 없으면 .tall 정보라도 반환
            return menuData[size] ?? menuData[.tall] ?? 0
        }
        
        // 매칭되는 데이터가 없으면 0 반환
        return 0
    }
}
