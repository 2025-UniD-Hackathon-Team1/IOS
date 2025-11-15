//
//  CaffeineEntry.swift
//  cafe_frame
//
//  Created by 김세은 on 11/15/25.
//

import Foundation

struct CaffeineEntry: Codable, Identifiable {
    var id: UUID = UUID()
    var amount: Int // 카페인 양 (mg)
    var timestamp: TimeInterval // 섭취 시간
    
    init(amount: Int, timestamp: TimeInterval = Date().timeIntervalSince1970) {
        self.amount = amount
        self.timestamp = timestamp
    }
}

