//
//  ScheduleService.swift
//  CoffeePrincess
//
//  Created by chohaeun on 11/15/25.
//


import Foundation
import Combine

final class ScheduleService: ObservableObject {
    /// 지금은 "오늘" 일정만 쓴다고 했으니 전부 오늘 기준이라고 두자
    @Published private(set) var todaySchedules: [Schedule] = []
    
    func add(_ schedule: Schedule) {
        todaySchedules.append(schedule)
    }
    
    func remove(_ schedule: Schedule) {
        todaySchedules.removeAll { $0.id == schedule.id }
    }
    
    func reset() {
        todaySchedules.removeAll()
    }
}
