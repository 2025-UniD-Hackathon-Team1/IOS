//
//  MainModel.swift
//  CoffeePrincess
//
//  Created by chohaeun on 11/15/25.
//

import Foundation

struct Drink: Identifiable {
    let id = UUID()
    let icon: String
    let name: String
    let amountMg: Int
    let timeText: String
}

struct MetabolismBar: Identifiable {
    let id = UUID()
    let timeLabel: String
    let amount: Double
    let isPast: Bool
    let isNow: Bool
}
