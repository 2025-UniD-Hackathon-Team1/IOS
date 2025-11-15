//
//  CurrentViewModel.swift
//  CoffeePrincess
//
//  Created by chohaeun on 11/16/25.
//

import Foundation

final class CurrentViewModel: ObservableObject {
    
    // MARK: - 대시보드 기본 상태
    @Published var currentCaffeine: Double = 0
    @Published var caffeinePercent: Double = 0
    @Published var energyPercent: Double = 0
    @Published var statusIcon: String = ""
    @Published var statusText: String = ""
    @Published var lastIntakeText: String = ""
    @Published var awakeEndText: String = ""
    
    // MARK: - 오늘 마신 음료
    @Published var todayDrinks: [Drink] = []
    
    // 오늘 날짜 텍스트 (필요하면 헤더에서 사용할 수 있음)
    var todayString: String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.dateFormat = "yyyy.MM.dd (E)"
        return formatter.string(from: Date())
    }
    
    // MARK: - Init
    init() {
        loadMockData()
    }
    
    // MARK: - Mock Data
    private func loadMockData() {
        currentCaffeine      = 185.0
        caffeinePercent      = 46.0
        energyPercent        = 78.0
        statusIcon           = "😌"
        statusText           = "보통"
        lastIntakeText       = "1시간 20분 전"
        awakeEndText         = "오후 11:10"
        
        todayDrinks = [
            Drink(icon: "☕️", name: "아메리카노", amountMg: 95, timeText: "오전 9:10"),
            Drink(icon: "☕️", name: "카페라떼", amountMg: 150, timeText: "오후 2:20"),
            Drink(icon: "🥤", name: "콜라", amountMg: 80, timeText: "오후 7:45")
        ]
    }
}
