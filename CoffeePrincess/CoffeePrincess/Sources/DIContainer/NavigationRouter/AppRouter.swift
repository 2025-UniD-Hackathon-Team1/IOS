//
//  AppRouter.swift
//  CoffeePrincess
//
//  Created by 김나영 on 11/15/25.
//

import Foundation
import SwiftUI

enum Route: Hashable {
    case home
    case addRecord
    case recordDetail(menuItem: MenuItem)
    case scheduleInput
    case profile
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
