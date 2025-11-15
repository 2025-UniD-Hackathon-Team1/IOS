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
    let caffeineService: CaffeineService
    let healthService: HealthService // 헬스킷 연동 (수면, 심박수)
    let calendarService: CalendarService // 캘린더 연동 (일정)
    
    // MARK: - Published Properties
    @Published var selectedTab: String = "홈" // 메인 탭뷰 관찰
    
    init(router: AppRouter) {
        self.router = router
        
        // 서비스 초기화 (필요에 따라 Singleton 또는 새 인스턴스)
        self.caffeineService = CaffeineService.shared // 예시: 싱글톤
        self.healthService = HealthService()         // 예시: 새 인스턴스
        self.calendarService = CalendarService()     // 예시: 새 인스턴스
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
