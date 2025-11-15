//
//  ScheduleViewModel.swift
//  CoffeePrincess
//
//  Created by chohaeun on 11/15/25.
//

import Foundation

final class ScheduleViewModel: ObservableObject {
    @Published var title: String = ""
    @Published var time: Date = Date()

    func buildSchedule() -> Schedule {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        let timeString = formatter.string(from: time)
        return Schedule(title: title, time: timeString)
    }
}

