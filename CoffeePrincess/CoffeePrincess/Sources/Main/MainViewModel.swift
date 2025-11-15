//
//  MainViewModel.swift
//  CoffeePrincess
//
//  Created by chohaeun on 11/15/25.
//

//
//  CaffeineTrackerViewModel.swift
//  CoffeePrincess
//

import Foundation

final class MainViewModel: ObservableObject {
    
    // MARK: - 대시보드 기본 상태
    
    @Published var currentCaffeine: Double = 0
    @Published var caffeinePercent: Double = 0
    @Published var energyPercent: Double = 0
    @Published var statusIcon: String = ""
    @Published var statusText: String = ""
    @Published var lastIntakeText: String = ""
    @Published var awakeEndText: String = ""
    
    // MARK: - 수면 영향
    
    @Published var usualBedtimeText: String = ""
    @Published var lastIntakeTimeText: String = ""
    @Published var sleepDisruptionPercent: Int = 0
    
    // MARK: - 오늘 마신 음료
    
    @Published var todayDrinks: [Drink] = []
    
    // MARK: - Body Caffeine / 대사 / 추천 카드 더미 값
    
    @Published var bodyCaffeineMg: Int = 0
    @Published var bodyCaffeineLevel: String = ""
    @Published var dailyIntakeMg: Int = 0
    @Published var dailyIntakeMl: Int = 0
    @Published var maxCaffeineMg: Int = 0
    @Published var diffYesterdayMg: Int = 0
    @Published var isDiffExpanded: Bool = false
    
    // 대사 그래프
    @Published var metabolismCurrentMg: Int = 0
    @Published var metabolismUntilText: String = ""
    @Published var metabolismSleepTimeText: String = ""
    @Published var metabolismBars: [MetabolismBar] = []
    
    // 일정 기반 추천
    @Published var scheduleTitle: String = ""
    @Published var scheduleTimeText: String = ""
    @Published var recommendIntakeTimeText: String = ""
    
    // 수면 예측
    @Published var tonightDisruptionPercent: Int = 0
    @Published var tonightLastIntakeTimeText: String = "-"
    @Published var tonightUsualBedtimeText: String = ""
    
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
    
    // MARK: - Mock Data (나중에 API 연결 시 이 부분만 갈아끼우면 됨)
    
    func loadMockData() {
        // 대시보드 기본 상태
        currentCaffeine      = 185.0
        caffeinePercent      = 46.0
        energyPercent        = 78.0
        statusIcon           = "😌"
        statusText           = "보통"
        lastIntakeText       = "1시간 20분 전"
        awakeEndText         = "오후 11:10"
        
        // 수면 영향
        usualBedtimeText     = "오후 11:30"
        lastIntakeTimeText   = "오후 9:50"
        sleepDisruptionPercent = 37
        
        // 오늘 마신 음료
        todayDrinks = [
            Drink(icon: "☕️", name: "아메리카노", amountMg: 95, timeText: "오전 9:10"),
            Drink(icon: "☕️", name: "카페라떼", amountMg: 150, timeText: "오후 2:20"),
            Drink(icon: "🥤", name: "콜라", amountMg: 80, timeText: "오후 7:45")
        ]
        
        // Body Caffeine / 대사 카드 더미 (일단 값만 세팅)
        bodyCaffeineMg   = 500
        bodyCaffeineLevel = "HIGH"
        dailyIntakeMg    = 520
        dailyIntakeMl    = 1500
        maxCaffeineMg    = 400
        diffYesterdayMg  = 95
        isDiffExpanded   = false
        
        metabolismCurrentMg     = 300
        metabolismUntilText     = "23:51"
        metabolismSleepTimeText = "23:00"
        metabolismBars = [
            .init(timeLabel: "06", amount: 0,   isPast: true,  isNow: false),
            .init(timeLabel: "08", amount: 250, isPast: true,  isNow: false),
            .init(timeLabel: "09", amount: 220, isPast: true,  isNow: true),
            .init(timeLabel: "10", amount: 190, isPast: true,  isNow: false),
            .init(timeLabel: "11", amount: 160, isPast: true,  isNow: false),
            .init(timeLabel: "12", amount: 130, isPast: true,  isNow: false),
            .init(timeLabel: "13", amount: 100, isPast: true,  isNow: false),
            .init(timeLabel: "14", amount: 80,  isPast: false, isNow: false),
            .init(timeLabel: "15", amount: 60,  isPast: false, isNow: false),
            .init(timeLabel: "16", amount: 40,  isPast: false, isNow: false),
            .init(timeLabel: "17", amount: 25,  isPast: false, isNow: false),
            .init(timeLabel: "18", amount: 10,  isPast: false, isNow: false)
        ]
        
        // 일정 기반 추천 더미
        scheduleTitle           = "중요 PT 일정"
        scheduleTimeText        = "오늘 14:00"
        recommendIntakeTimeText = "오후 1시 15분"
        
        // 수면 예측 더미
        tonightDisruptionPercent   = 0
        tonightLastIntakeTimeText  = "-"
        tonightUsualBedtimeText    = "23:30"
    }
    
    // MARK: - TODO: API 연결용 메서드 예시
    //
    // 나중에 서버에서 받아온 DTO를 여기서 한 번에 매핑하면 됨.
    //
    // func applyDashboard(from response: CaffeineDashboardResponse) {
    //     currentCaffeine = response.currentCaffeine
    //     ...
    // }
}
