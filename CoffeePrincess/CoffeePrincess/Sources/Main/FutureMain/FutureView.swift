//
//  futureView.swift
//  CoffeePrincess
//
//  Created by chohaeun on 11/16/25.
//


import SwiftUI
import Combine

struct FutureView: View {
    
    @StateObject private var viewModel: FutureViewModel
    @Environment(\.diContainer) private var di
    
    @State private var todaySchedules: [Schedule] = []
    @State private var cancellables = Set<AnyCancellable>()
    
    @State private var isLoadingSchedules: Bool = false
    
    // (수정) DIContainer에서 ScheduleService를 가져옵니다.
    // private let scheduleService = ScheduleService() // <- 이 방식 대신
    private var scheduleService: ScheduleService {
        di.scheduleService // <- DIContainer에서 가져옵니다.
    }
    
    init(viewModel: FutureViewModel = FutureViewModel()) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }


    
    var body: some View {
        VStack {
            VStack(spacing: 16) {
                scheduleRecommendationSection
                todayScheduleSection
            }
            .padding(.horizontal, 16)
            
            Spacer(minLength: 60)
                
            Image(.kongbottom)
                    .resizable()
                    .scaledToFit()
                    .frame(height:140)
                
            }
        .background(Color(.cardBackground))
        .onAppear {
            // ★★★ (수정) 두 개의 API를 모두 호출 ★★★
            fetchTodaySchedules() // 1. 기존 일정 API (View에서)
//            viewModel.fetchCaffeineGraph(container: di) // 2. 새 그래프 API (ViewModel에서)
        }
    }
}

extension FutureView {
    
    /// 오늘 날짜 기준으로 GET 일정 호출
    private func fetchTodaySchedules() {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let today = formatter.string(from: Date())   // "2025-11-16" 이런 포맷
        
        scheduleService.fetchSchedules(date: today)
            .receive(on: DispatchQueue.main)
            .sink { completion in
                if case let .failure(error) = completion {
                    print("❌ 일정 GET 실패:", error.localizedDescription)
                }
            } receiveValue: { schedules in
                // 이 화면에서만 쓰는 todaySchedules에 바로 꽂기
                self.todaySchedules = schedules
                
                // ✅ 첫 번째 스케줄을 기반으로 ViewModel 값 세팅
                if let first = schedules.first {
                    self.updateViewModel(with: first)
                }
            }
            .store(in: &cancellables)
    }

}
extension FutureView {
    
    /// 첫 번째 일정으로 추천 영역 텍스트 세팅
    private func updateViewModel(with schedule: Schedule) {
        // e.g. schedule.time == "13시", schedule.name == "회의"
        viewModel.scheduleTimeText = schedule.time
        viewModel.scheduleTitle = schedule.name
        viewModel.recommendIntakeTimeText = recommendTime(from: schedule.time)
    }
    
   
    /// "07:32" → "06:32" 로 1시간 전 추천 시간 계산
    private func recommendTime(from scheduleTime: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        
        guard let date = formatter.date(from: scheduleTime) else {
            return scheduleTime // 파싱 실패 시 그대로 반환
        }
        
        // -1시간
        let recommendDate = Calendar.current.date(byAdding: .hour, value: -1, to: date) ?? date
        
        return formatter.string(from: recommendDate)
    }

}


extension FutureView {
    private var scheduleRecommendationSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("오늘의 일정 기반 추천")
                .font(.headline)
                .foregroundColor(.fontBrown)
            
            if todaySchedules.isEmpty {
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color(.cardBackground))
                    .frame(height: 60)
                    .overlay(
                        HStack(spacing: 6) {
                            Image(systemName: "calendar.badge.plus")
                                .foregroundColor(.secondary)
                            Text("등록된 일정이 없습니다")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                    )
            } else {
                // 원래 추천 UI
                VStack(alignment: .leading, spacing: 8) {
                    HStack(alignment: .center, spacing: 8) {
                        Image(systemName: "clock.badge.exclamationmark")
                            .font(.subheadline)
                            .foregroundColor(.mainBrown)
                        
                        Text(viewModel.scheduleTimeText)
                            .font(.subheadline)
                            .fontWeight(.semibold)
                        
                        Text("· \(viewModel.scheduleTitle)")
                            .font(.subheadline)
                            .foregroundColor(.secondaryBrown)
                        
                        Spacer()
                    }
                    
                    Text("최상의 각성 상태를 위해, 아래 시간에 한 잔 어떠세요?")
                        .font(.footnote)
                        .foregroundColor(.secondaryBrown)
                    
                    HStack(spacing: 6) {
                        Image(systemName: "cup.and.saucer.fill")
                            .font(.caption)
                        Text("\(viewModel.recommendIntakeTimeText)에 커피를 드시는 것을 추천합니다.")
                            .font(.subheadline)
                            .fontWeight(.semibold)
                    }
                }
                .padding(14)
                .background(
                    RoundedRectangle(cornerRadius: 18)
                        .fill(Color(.cardBackground))
                )
            }
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 22)
                .fill(Color(.systemBackground))
                .shadow(color: Color.black.opacity(0.05), radius: 12, x: 0, y: 4)
        )
    }

    
    private var todayScheduleSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            
            HStack {
                Text("오늘의 일정")
                    .font(.headline)
                    .foregroundColor(.fontBrown)
                Spacer()
                Button {
                    di.router.push(.scheduleInput)
                } label: {
                    HStack(spacing: 4) {
                        Image(systemName: "plus.circle.fill")
                            .font(.subheadline)
                        Text("추가")
                            .font(.caption)
                    }
                    .padding(.horizontal, 8)
                    .padding(.vertical, 6)
                    .background(
                        Capsule()
                            .fill(Color(.cardBackground))
                    )
                }
                .buttonStyle(.plain)
            }
            
            // 🔥 여기서 바로 GET 결과(todaySchedules) 사용
            if todaySchedules.isEmpty {
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color(.cardBackground))
                    .frame(height: 60)
                    .overlay(
                        HStack(spacing: 6) {
                            Image(systemName: "calendar.badge.plus")
                                .foregroundColor(.secondary)
                            Text("등록된 일정이 없습니다")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                    )
            } else {
                VStack(spacing: 10) {
                    ForEach(todaySchedules) { schedule in
                        HStack(alignment: .top, spacing: 10) {
                            
                            VStack {
                                Circle()
                                    .fill(Color.mainBrown)
                                    .frame(width: 8, height: 8)
                                Rectangle()
                                    .fill(Color(.systemGray4))
                                    .frame(width: 2)
                                    // 마지막 일정이면 선 끊기
                                    .opacity(schedule.id == todaySchedules.last?.id ? 0 : 1)
                            }
                            
                            VStack(alignment: .leading, spacing: 4) {
                                Text(schedule.time)
                                    .font(.caption)
                                    .foregroundColor(.secondaryBrown)
                                
                                Text(schedule.name)
                                    .font(.subheadline)
                                    .fontWeight(.semibold)
                                    .foregroundColor(.fontBrown)
                            }
                            
                            Spacer()
                        }
                    }
                }
                .padding(.top, 4)
            }
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 18)
                .fill(Color(.systemBackground))
                .shadow(color: Color.black.opacity(0.05), radius: 12, x: 0, y: 4)
        )
    }
}

#Preview {
    FutureView()
}
