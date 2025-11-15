//
//  ScheduleViewModel.swift
//  CoffeePrincess
//
//  Created by chohaeun on 11/15/25.
//

import Foundation
import Combine

final class ScheduleViewModel: ObservableObject {
    @Published var name: String = ""
    @Published var time: Date = Date()
    
    /// View에서 입력한 값으로 Schedule 생성
    /// - 지금은 "오늘"만 쓰니까 date는 항상 오늘 날짜("yyyy-MM-dd")로 저장
    func buildSchedule() -> Schedule {
        // 시간 문자열: "HH:mm"
        let timeFormatter = DateFormatter()
        timeFormatter.locale = Locale(identifier: "ko_KR")
        timeFormatter.dateFormat = "HH:mm"
        let timeString = timeFormatter.string(from: time)
        
        // 날짜 문자열: "yyyy-MM-dd"
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ko_KR")
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let dateString = dateFormatter.string(from: Date())
        
        return Schedule(
            name: name,
            date: dateString,
            time: timeString
        )
    }
}
