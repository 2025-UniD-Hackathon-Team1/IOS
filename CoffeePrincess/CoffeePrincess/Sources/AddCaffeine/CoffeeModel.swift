//
//  CoffeeModel.swift
//  CoffeePrincess
//
//  Created by 김나영 on 11/15/25.
//

import Foundation

/// 커피 메뉴를 나타내는 모델입니다. (카페인 정보 분리)
struct MenuItem: Identifiable, Hashable {
    let id = UUID()
    let name: String
    let iconName: String // SFSymbol 이름
    
    // (baseCaffeinePerShot 속성 제거됨)
}

// MARK: - Mock Data
extension MenuItem {
    /// 아이콘은 SF Symbols를 사용합니다. (https://developer.apple.com/sf-symbols/)
    static var mockStarbucksItems: [MenuItem] = [
        // (baseCaffeinePerShot 속성 제거됨)
        MenuItem(name: "아메리카노", iconName: "cup.and.saucer.fill"),
        MenuItem(name: "카페 라떼", iconName: "cup.and.saucer.fill"),
        MenuItem(name: "바닐라 라떼", iconName: "cup.and.saucer.fill"), // "카페 라떼" 데이터 사용
        MenuItem(name: "콜드 브루", iconName: "mug.fill"),
        MenuItem(name: "플랫 화이트", iconName: "snowflake"),
        MenuItem(name: "카페 모카", iconName: "leaf.fill"), // 아이콘 수정 필요
        MenuItem(name: "스타벅스 돌체 라떼", iconName: "leaf.fill"), // 아이콘 수정 필요
        MenuItem(name: "자바 칩 프라푸치노", iconName: "leaf.fill") // 아이콘 수정 필요
    ]
    
    static var mockOtherItems: [MenuItem] = [
        MenuItem(name: "믹스 커피", iconName: "mug.fill"),
        MenuItem(name: "에너지 드링크", iconName: "bolt.fill"),
        MenuItem(name: "콜라", iconName: "takeoutbag.and.cup.and.straw.fill")
    ]
}

/// 커피 사이즈를 정의하는 Enum (기존과 동일)
enum CoffeeSize: String, CaseIterable, Identifiable {
//    case short = "Short"
    case tall = "Tall"
    case grande = "Grande"
    case venti = "Venti"
    
    var id: String { self.rawValue }
}
