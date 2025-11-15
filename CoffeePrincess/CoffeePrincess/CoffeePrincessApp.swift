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
    @StateObject private var scheduleService = ScheduleService()
    
    @Environment(\.scenePhase) private var scenePhase
    
    init() {
        let router = AppRouter()
        self._router = StateObject(wrappedValue: router)
        self._container = StateObject(wrappedValue: DIContainer(router: router))
    }
    
    var body: some Scene {
        WindowGroup {
            NavigationStack(path: $router.path) {
                MainView()
                    .environment(\.diContainer, container)
                    .navigationDestination(for: Route.self) { route in
                        switch route {
                        case .home:
                            MainView()
                                .environment(\.diContainer, container)
                        case .scheduleInput:
                            ScheduleView()
                                .environment(\.diContainer, container)
                        case .addRecord:
                            AddRecordView()
                                .navigationBarBackButtonHidden(true)
                        case .recordDetail(let menuItem):
                            RecordDetailView(menuItem: menuItem)
                                .navigationBarBackButtonHidden(true)
                        }
                    }
            }
            //.environmentObject(container)
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
