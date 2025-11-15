//
//  ScheduleView.swift
//  CoffeePrincess
//
//  Created by chohaeun on 11/15/25.
//


import SwiftUI

struct ScheduleView: View {
    @Environment(\.diContainer) private var di
    @EnvironmentObject var MainViewModel: MainViewModel
    @StateObject private var viewModel = ScheduleViewModel()
    @EnvironmentObject var scheduleService: ScheduleService

    var body: some View {
        VStack(alignment: .leading) {
            // 네가 직접 만드는 헤더
            HStack {
                Button {
                    di.router.pop()
                } label: {
                    Image(systemName: "chevron.left")
                    Text("오늘 일정 추가")
                }
                .font(.headline)

                Spacer()
            }
            .padding()

            Form {
                Section(header: Text("일정 제목")) {
                    TextField("예: 팀 프로젝트 발표", text: $viewModel.title)
                }

                Section(header: Text("시간 (오늘)")) {
                    DatePicker(
                        "시간 선택",
                        selection: $viewModel.time,
                        displayedComponents: .hourAndMinute
                    )
                }

                Section {
                    Button("저장") {
                        let schedule = viewModel.buildSchedule()
                        scheduleService.add(schedule)
                        di.router.pop()
                    }
                }
            }
        }
        .toolbar(.hidden, for: .navigationBar)   // 🔥 네비게이션 바 완전 숨기기
    }
}
