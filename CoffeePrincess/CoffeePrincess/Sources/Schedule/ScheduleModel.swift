//
//  ScheduleModel.swift
//  CoffeePrincess
//
//  Created by chohaeun on 11/15/25.
//

import Foundation

struct Schedule: Identifiable {
    let id = UUID()
    
    var name: String
    var date: String   // "2025-11-15"
    var time: String   // "HH:mm"
}
