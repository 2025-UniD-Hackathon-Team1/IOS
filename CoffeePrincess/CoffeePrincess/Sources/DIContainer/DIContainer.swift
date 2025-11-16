//
//  DIContainer.swift
//  CoffeePrincess
//
//  Created by 김나영 on 11/15/25.
//

import Foundation
import SwiftUI
import Combine
import Moya

final class DIContainer: ObservableObject {
    // MARK: - Router
    var router: AppRouter
    
    // MARK: - Services
    let scheduleService: ScheduleService
    let coffeeService: CoffeeService
    let dashboardService: DashboardService
    
    // MARK: - Published Properties
    @Published var selectedTab: String = "홈"
    
    init(
        router: AppRouter,
        scheduleService: ScheduleService = ScheduleService()
    ) {
        self.router = router
        self.scheduleService = scheduleService
        self.coffeeService = CoffeeService()
        self.dashboardService = DashboardService()
    }
}

// MARK: - EnvironmentKey 등록
private struct DIContainerKey: EnvironmentKey {
    static var defaultValue: DIContainer = DIContainer(router: AppRouter())
}

extension EnvironmentValues {
    var diContainer: DIContainer {
        get { self[DIContainerKey.self] }
        set { self[DIContainerKey.self] = newValue }
    }
}
