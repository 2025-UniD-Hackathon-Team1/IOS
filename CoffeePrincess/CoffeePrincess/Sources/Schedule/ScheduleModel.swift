//
//  ScheduleModel.swift
//  CoffeePrincess
//
//  Created by chohaeun on 11/15/25.
//

import Foundation

struct Schedule: Identifiable {
    let id = UUID()
    var title: String
    var time: String   // "HH:mm"
}
