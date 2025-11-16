//
//  FutureViewModel.swift
//  CoffeePrincess
//
//  Created by chohaeun on 11/16/25.
//


import Foundation

final class FutureViewModel: ObservableObject {
    
    /// MARK: - 일정 기반 추천 (기존 코드)
    @Published var scheduleTitle: String = ""
    @Published var scheduleTimeText: String = ""
    @Published var recommendIntakeTimeText: String = ""
    
    // --- ★★★ 그래프 API 연동을 위해 추가된 코드 ★★★ ---
    
    /// (GET) 카페인 대사 그래프
    @Published var metabolismBars: [MetabolismBar] = []
    
    /// (GET) 현재 카페인 (그래프 상단 표시용)
    @Published var currentCaffeine: Double = 0
    
    /// 로딩 상태 (그래프용)
    @Published var isLoadingGraph: Bool = false
    
    // MARK: - Private Properties
    
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
    
//    /// (GET) API를 호출하여 카페인 그래프 데이터를 가져옵니다.
//    func fetchCaffeineGraph(container: DIContainer) {
//        isLoadingGraph = true
//        
//        container.dashboardService.getCaffeineInfo { [weak self] result in
//            DispatchQueue.main.async {
//                guard let self = self else { return }
//                
//                self.isLoadingGraph = false
//                switch result {
//                case .success(let response):
//                    print("✅ [GET] 카페인 그래프 로드 성공")
//                    self.currentCaffeine = response.currentCaffeine
//                    
//                    // API 응답(CaffeineGraphPoint) ➔ UI 모델(MetabolismBar)로 변환
//                    let currentHour = Calendar.current.component(.hour, from: Date())
//                    let currentHourString = String(format: "%02d", currentHour)
//                    
//                    self.metabolismBars = response.graph.map { point in
//                        let barHour = String(point.time.prefix(2)) // "06:24" ➔ "06"
//                        let isPast = barHour < currentHourString
//                        let isNow = barHour == currentHourString
//                        
//                        return MetabolismBar(
//                            timeLabel: barHour,
//                            amount: point.caffeine,
//                            isPast: isPast,
//                            isNow: isNow
//                        )
//                    }
//                    
//                case .failure(let error):
//                    print("❌ [GET] 카페인 그래프 로드 실패: \(error.localizedDescription)")
//                    self.metabolismBars = []
//                }
//            }
//        }
//    }
    
    /// 일정 목록(API 결과)을 기반으로 추천 텍스트를 업데이트합니다.
    private func updateScheduleRecommendation(from schedules: [Schedule]) {
        
        // 1. 첫 번째 일정을 가져옵니다.
        guard let firstSchedule = schedules.first else {
            // 일정이 없으면 기본값으로 설정
            self.scheduleTitle = "오늘 일정이 없습니다"
            self.scheduleTimeText = "일정을 추가해보세요"
            self.recommendIntakeTimeText = "-"
            return
        }
        
        // 2. scheduleTitle 채우기
        self.scheduleTitle = firstSchedule.name
        
        // 3. scheduleTimeText 채우기 ("오늘 HH:mm" 형식)
        // firstSchedule.time은 "06:49" 같은 형식
        self.scheduleTimeText = "오늘 \(firstSchedule.time)" // "오늘 06:49"
        
        // 4. recommendIntakeTimeText 계산하기 (일정 1시간 전)
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "HH:mm"
        timeFormatter.locale = Locale(identifier: "en_US_POSIX")
        
        if let scheduleTime = timeFormatter.date(from: firstSchedule.time) {
            // 오늘 날짜의 해당 시간(Date) 객체를 만듦
            let todayScheduleDate = Calendar.current.date(bySettingHour: Calendar.current.component(.hour, from: scheduleTime),
                                                          minute: Calendar.current.component(.minute, from: scheduleTime),
                                                          second: 0,
                                                          of: Date()) ?? Date()
            
            // 1시간 전 계산
            let recommendDate = Calendar.current.date(byAdding: .hour, value: -1, to: todayScheduleDate) ?? Date()
            
            // "오후 1시 15분" 형식으로 변환
            let outputFormatter = DateFormatter()
            outputFormatter.locale = Locale(identifier: "ko_KR")
            outputFormatter.dateFormat = "a h시 m분" // "오전 5시 49분"
            self.recommendIntakeTimeText = outputFormatter.string(from: recommendDate)
            
        } else {
            // 시간 변환 실패 시
            self.recommendIntakeTimeText = "-"
        }
    }
}
