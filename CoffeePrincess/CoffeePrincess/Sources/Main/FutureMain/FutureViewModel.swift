//
//  FutureViewModel.swift
//  CoffeePrincess
//
//  Created by chohaeun on 11/16/25.
//


import Foundation

final class FutureViewModel: ObservableObject {
    
    // MARK: - 일정 기반 추천
    @Published var scheduleTitle: String = ""
    @Published var scheduleTimeText: String = ""
    @Published var recommendIntakeTimeText: String = ""
    
    // MARK: - Init
    init() {
        loadMockData()
    }
    
    // MARK: - Mock Data
    private func loadMockData() {
        scheduleTitle           = "중요 PT 일정"
        scheduleTimeText        = "오늘 14:00"
        recommendIntakeTimeText = "오후 1시 15분"
    }
    
    /// 나중에 API 또는 일정 선택 시 호출할 메서드 예시
    func apply(scheduleTitle: String, scheduleDate: Date) {
        self.scheduleTitle = scheduleTitle
        
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ko_KR")
        dateFormatter.dateFormat = "오늘 HH:mm"
        self.scheduleTimeText = dateFormatter.string(from: scheduleDate)
        
        let calendar = Calendar.current
        let recommendDate = calendar.date(byAdding: .minute, value: -45, to: scheduleDate) ?? scheduleDate
        
        let timeFormatter = DateFormatter()
        timeFormatter.locale = Locale(identifier: "ko_KR")
        timeFormatter.dateFormat = "a h시 m분"
        self.recommendIntakeTimeText = timeFormatter.string(from: recommendDate)
    }
}
