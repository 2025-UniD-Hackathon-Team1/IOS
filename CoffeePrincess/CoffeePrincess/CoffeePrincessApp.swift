//
//  CoffeePrincessApp.swift
//  CoffeePrincess
//
//  Created by 김나영 on 11/15/25.
//

import SwiftUI

@main
struct CoffeePrincessApp: App {
    @StateObject private var router = AppRouter()
    @StateObject private var container: DIContainer
    
    @Environment(\.scenePhase) private var scenePhase
    
    init() {
        let router = AppRouter()
        self._router = StateObject(wrappedValue: router)
        self._container = StateObject(wrappedValue: DIContainer(router: router))
    }
    
    var body: some Scene {
        WindowGroup {
            NavigationStack(path: $router.path) {
                ContentView()
                    .navigationDestination(for: Route.self) { route in
                        switch route {
                        case .home:
                            let _ = print("로그인뷰나중에구현할게")
                        }
                    }
            }
            .environmentObject(container)
            .environment(\.diContainer, container)
            .alert(isPresented: $container.router.showAlert) {
                Alert(
                    title: Text("알림"),
                    message: Text(container.router.alertMessage),
                    dismissButton: .default(Text("확인")) {
                        container.router.alertAction?()
                        container.router.alertAction = nil
                    }
                )
            }
        }
    }
}
