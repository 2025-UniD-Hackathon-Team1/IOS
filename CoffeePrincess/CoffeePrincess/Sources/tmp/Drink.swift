//
//  Drink.swift
//  cafe_frame
//
//  Created by 김세은 on 11/15/25.
//

import Foundation

struct Drink: Codable, Identifiable, Hashable {
    var id: UUID = UUID()
    var name: String
    var amount: Int // 카페인 양 (mg)
    var icon: String
    var category: String
    
    static let drinkDatabase: [Drink] = [
        Drink(name: "아메리카노", amount: 95, icon: "☕", category: "커피"),
        Drink(name: "카페라떼", amount: 150, icon: "☕", category: "커피"),
        Drink(name: "에스프레소", amount: 200, icon: "☕", category: "커피"),
        Drink(name: "카푸치노", amount: 120, icon: "☕", category: "커피"),
        Drink(name: "콜드브루", amount: 165, icon: "☕", category: "커피"),
        Drink(name: "카페모카", amount: 175, icon: "☕", category: "커피"),
        Drink(name: "바닐라라떼", amount: 150, icon: "☕", category: "커피"),
        Drink(name: "카라멜마키아토", amount: 150, icon: "☕", category: "커피"),
        Drink(name: "콜라", amount: 80, icon: "🥤", category: "기타"),
        Drink(name: "녹차", amount: 50, icon: "🍵", category: "기타"),
        Drink(name: "초콜릿", amount: 40, icon: "🍫", category: "기타"),
        Drink(name: "홍차", amount: 30, icon: "🍵", category: "기타"),
        Drink(name: "에너지드링크", amount: 80, icon: "⚡", category: "기타"),
        Drink(name: "코코아", amount: 5, icon: "☕", category: "기타"),
        Drink(name: "우롱차", amount: 30, icon: "🍵", category: "기타"),
        Drink(name: "마테차", amount: 85, icon: "🍵", category: "기타"),
        Drink(name: "아이스티", amount: 25, icon: "🧊", category: "기타"),
        Drink(name: "핫초콜릿", amount: 5, icon: "☕", category: "기타")
    ]
}

