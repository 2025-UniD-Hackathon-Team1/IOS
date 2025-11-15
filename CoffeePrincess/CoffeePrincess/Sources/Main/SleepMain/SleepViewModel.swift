//
//  SleepViewModel.swift
//  CoffeePrincess
//
//  Created by chohaeun on 11/16/25.
//

import Foundation

final class SleepViewModel: ObservableObject {
    
    // MARK: - 수면 영향
    @Published var usualBedtimeText: String = ""
    @Published var lastIntakeTimeText: String = ""
    @Published var sleepDisruptionPercent: Int = 0
    
    // MARK: - 대사 그래프
    @Published var metabolismCurrentMg: Int = 0
    @Published var metabolismUntilText: String = ""
    @Published var metabolismSleepTimeText: String = ""
    @Published var metabolismBars: [MetabolismBar] = []
    
    // MARK: - 수면 예측 (추가 섹션용)
    @Published var tonightDisruptionPercent: Int = 0
    @Published var tonightLastIntakeTimeText: String = "-"
    @Published var tonightUsualBedtimeText: String = ""
    
    // MARK: - Init
    init() {
        loadMockData()
    }
    
    // MARK: - Mock Data
    private func loadMockData() {
        // 수면 영향
        usualBedtimeText       = "오후 11:30"
        lastIntakeTimeText     = "오후 9:50"
        sleepDisruptionPercent = 37
        
        // 대사 그래프
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
        
        // 수면 예측 더미
        tonightDisruptionPercent   = 0
        tonightLastIntakeTimeText  = "-"
        tonightUsualBedtimeText    = "23:30"
    }
}
