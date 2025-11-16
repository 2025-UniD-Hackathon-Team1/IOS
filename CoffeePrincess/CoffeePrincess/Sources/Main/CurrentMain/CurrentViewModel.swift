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
    
    @Published var isLoadingStatus: Bool = false
    
    // ★★★ 날짜 포맷을 위한 헬퍼 추가 ★★★
    private var dateFomatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        formatter.locale = Locale(identifier: "en_US_POSIX")
        return formatter
    }()
    
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
    
    /// (GET) ★★★ 대시보드 상태 (카페인, 각성도)를 불러옵니다 ★★★
    func fetchDashboardStatus(container: DIContainer) {
        isLoadingStatus = true
        
        let group = DispatchGroup()
        
        // --- 1. 카페인 정보 가져오기 ---
        group.enter()
        container.dashboardService.getCaffeineInfo { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let response):
                    print("✅ [GET] 카페인 정보 로드 성공")
                    self?.currentCaffeine = response.currentCaffeine
                    // (참고: graph 데이터는 response.graph에 있습니다)
                case .failure(let error):
                    print("❌ [GET] 카페인 정보 로드 실패: \(error.localizedDescription)")
                }
                group.leave()
            }
        }
        
        // --- 2. 각성 정보 가져오기 ---
        group.enter()
        container.dashboardService.getAlertnessInfo { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let response):
                    print("✅ [GET] 각성도 정보 로드 성공")
                    // 서버가 0.23 (비율)로 주므로 100을 곱해 %로 변환
                    self?.currentAlertnessPercent = response.currentAlertness * 100
                    // 시간 포맷 변경
                    self?.awakeEndText = self?.formatAwakeEndTime(response.alertnessEndTime) ?? "정보 없음"
                case .failure(let error):
                    print("❌ [GET] 각성도 정보 로드 실패: \(error.localizedDescription)")
                }
                group.leave()
            }
        }
        
        // --- 3. 두 API가 모두 완료되면 로딩 종료 ---
        group.notify(queue: .main) {
            self.isLoadingStatus = false
            print("--- 🏁 대시보드 상태 업데이트 완료 ---")
        }
    }
    
    /// "YYYY-MM-DD HH:mm:ss" ➔ "오후 11:10"
    private func formatAwakeEndTime(_ dateString: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        formatter.locale = Locale(identifier: "en_US_POSIX")
        
        guard let date = formatter.date(from: dateString) else {
            return dateString // 변환 실패 시 원본 반환
        }
        
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.dateFormat = "a h:mm" // "오후 11:10"
        return formatter.string(from: date)
    }
    
    // MARK: - Mock Data
    private func loadMockData() {
//        currentCaffeine      = 185.0
//        currentAlertnessPercent      = 46.0
        energyPercent        = 78.0
        statusIcon           = "😌"
        statusText           = "보통"
        lastIntakeText       = "1시간 20분 전"
//        awakeEndText         = "오후 11:10"
        
        todayDrinks = [
            Drink(icon: "☕️", name: "아메리카노", amountMg: 95, timeText: "오전 9:10"),
            Drink(icon: "☕️", name: "카페라떼", amountMg: 150, timeText: "오후 2:20"),
            Drink(icon: "🥤", name: "콜라", amountMg: 80, timeText: "오후 7:45")
        ]
    }
}
