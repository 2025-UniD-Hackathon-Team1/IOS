//
//  futureView.swift
//  CoffeePrincess
//
//  Created by chohaeun on 11/16/25.
//


import SwiftUI

struct FutureView: View {
    
    @StateObject private var viewModel: FutureViewModel
    @EnvironmentObject private var scheduleService: ScheduleService  // ← 핵심
    @Environment(\.diContainer) private var di
    
    
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
    }
}

extension FutureView {
    private var scheduleRecommendationSection: some View {
            VStack(alignment: .leading, spacing: 10) {
                Text("오늘의 일정 기반 추천")
                    .font(.headline)
                    .foregroundColor(.fontBrown)
                
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
            .padding(16)
            .background(
                RoundedRectangle(cornerRadius: 22)
                    .fill(Color(.systemBackground))
                    .shadow(color: Color.black.opacity(0.05), radius: 12, x: 0, y: 4)
            )
        }
    
    private var todayScheduleSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            
            let schedules = scheduleService.todaySchedules
            
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
            
            if schedules.isEmpty {
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
                    ForEach(schedules) { schedule in
                        HStack(alignment: .top, spacing: 10) {
                            
                            VStack {
                                Circle()
                                    .fill(Color.mainBrown)
                                    .frame(width: 8, height: 8)
                                Rectangle()
                                    .fill(Color(.systemGray4))
                                    .frame(width: 2)
                                    .opacity(schedule.id == schedules.last?.id ? 0 : 1)
                            }
                            
                            VStack(alignment: .leading, spacing: 4) {
                                Text(schedule.time)
                                    .font(.caption)
                                    .foregroundColor(.secondaryBrown)
                                
                                Text(schedule.name)    // ← FIXED
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
