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
                Index()
                    .environment(\.diContainer, container)
                    .navigationDestination(for: Route.self) { route in
                        switch route {
                        case .home:
                            SurveyView()
                                .environment(\.diContainer, container)
                                .navigationBarBackButtonHidden(true)
                        case .scheduleInput:
                            ScheduleView()
                                .environment(\.diContainer, container)
                                .navigationBarBackButtonHidden(true)
                        case .addRecord:
                            AddRecordView()
                                .navigationBarBackButtonHidden(true)
                        case .recordDetail(let menuItem):
                            RecordDetailView(menuItem: menuItem)
                                .navigationBarBackButtonHidden(true)
                        case .newReport:
                            NewReportView()
                                .navigationBarBackButtonHidden(true)
                        case .newReportProfile:
                            NewReportProfileView()
                                .navigationBarBackButtonHidden(true)
                        case .survey:
                            SurveyView()
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
