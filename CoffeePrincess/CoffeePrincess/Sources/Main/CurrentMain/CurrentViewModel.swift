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
    @Published var currentAlertnessPercent: Double = 0 // 각성도
    @Published var energyPercent: Double = 0
    @Published var statusIcon: String = ""
    @Published var statusText: String = ""
    @Published var lastIntakeText: String = ""
    @Published var awakeEndText: String = ""
    
    // MARK: - 오늘 마신 음료
    
    @Published var todayDrinks: [Drink] = []
    
    @Published var isLoadingTodayDrinks: Bool = false
    
    // ★★★ 날짜 포맷을 위한 헬퍼 추가 ★★★
    private var dateFomatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        formatter.locale = Locale(identifier: "en_US_POSIX")
        return formatter
    }()
    
//    // 오늘 날짜 텍스트 (필요하면 헤더에서 사용할 수 있음)
//    var todayString: String {
//        let formatter = DateFormatter()
//        formatter.locale = Locale(identifier: "ko_KR")
//        formatter.dateFormat = "yyyy.MM.dd (E)"
//        return formatter.string(from: Date())
//    }
    
    // MARK: - Init
    init() {
        loadMockData()
    }
    
    // MARK: - Today Text
    
    var todayString: String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.dateFormat = "yyyy.MM.dd (E)"
        return formatter.string(from: Date())
    }
    
    // MARK: - API Call
    
    /// (GET) ★★★ 오늘 마신 커피 목록을 서버에서 불러옵니다 ★★★
    func fetchTodayCoffee(container: DIContainer) {
        isLoadingTodayDrinks = true
        let todayString = dateFomatter.string(from: Date())
        
        print("--- 🚀 [GET] 오늘 마신 커피 목록 요청 ---")
        
        container.coffeeService.getTodayCoffee(date: todayString) { [weak self] result in
            DispatchQueue.main.async {
                self?.isLoadingTodayDrinks = false
                switch result {
                case .success(let response):
                    print("✅ [GET] 커피 목록 로드 성공: \(response.coffeeItemResponseList.count)개")
                    
                    // ★★★ (중요) API 응답(CoffeeItemResponse)을 UI 모델(Drink)로 변환 ★★★
                    self?.todayDrinks = response.coffeeItemResponseList.map { item in
                        Drink(
                            icon: "☕️", // (API에 아이콘이 없으므로 기본값 사용)
                            name: item.name,
                            amountMg: item.caffeineAmount, // (CoffeeItemResponse에 추가된 필드)
                            timeText: String(item.drinkTime.prefix(5)) // "HH:mm:ss" -> "HH:mm"
                        )
                    }
                    
                case .failure(let error):
                    print("❌ [GET] 커피 목록 로드 실패: \(error.localizedDescription)")
                    self?.todayDrinks = [] // 실패 시 목록 비우기
                }
            }
        }
    }
    
    // MARK: - Mock Data
    private func loadMockData() {
        currentCaffeine      = 185.0
        currentAlertnessPercent      = 46.0
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
