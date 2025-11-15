//
//  AppRouter.swift
//  CoffeePrincess
//
//  Created by 김나영 on 11/15/25.
//

import Foundation
import SwiftUI

enum Route: Hashable {
//    case onboarding
    case home       // 메인 대시보드 (탭뷰가 있는)
    // case addRecord(Date) // 예시: 특정 날짜에 기록 추가
}

final class AppRouter: ObservableObject {
    @Published var path = NavigationPath()
    @Published var showAlert: Bool = false
    @Published var alertMessage: String = ""
    
    var alertAction: (() -> Void)? = nil
    
    // MARK: - Navigation Methods
    func push(_ route: Route) {
        path.append(route)
    }
    
    func pop() {
        if !path.isEmpty { path.removeLast() }
    }
    
    func popToRoot() {
        path = NavigationPath()
    }
    
    func reset() {
        path = NavigationPath()
    }
}
