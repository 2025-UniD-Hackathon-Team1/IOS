//
//  ScheduleView.swift
//  CoffeePrincess
//
//  Created by chohaeun on 11/15/25.
//


import SwiftUI

struct ScheduleView: View {
    @Environment(\.diContainer) private var di
    @StateObject private var viewModel = ScheduleViewModel()
    
    var body: some View {
        ZStack {
            // 배경 톤 다운
            Color(.cardBackground)
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                // 상단 헤더바
                HeaderBar(
                    viewText: "일정 등록",
                    onTapBack: {
                        di.router.pop()
                    }
                )
                .padding(.bottom, 8)
                
                ScrollView {
                    VStack(alignment: .leading, spacing: 24) {
                        
                        // 설명 텍스트
                        VStack(alignment: .leading, spacing: 6) {
                            Text("오늘 중요한 일정을 등록해 주세요")
                                .font(.headline)
                                .fontWeight(.bold)
                                .foregroundColor(.mainBrown)
                            Text("일정을 등록하면 추천 카페인 섭취 시간도 함께 볼 수 있어요.")
                                .font(.footnote)
                                .foregroundColor(.mainBrown)
                        }
                        .padding(.horizontal, 20)
                        
                        // 입력 카드
                        VStack(alignment: .leading, spacing: 18) {
                            
                            // 제목 입력
                            VStack(alignment: .leading, spacing: 8) {
                                Text("일정 제목")
                                    .font(.subheadline)
                                    .fontWeight(.semibold)
                                    .foregroundColor(.mainBrown)
                                
                                TextField("예: 팀 프로젝트 발표", text: $viewModel.name)
                                    .padding(.horizontal, 12)
                                    .padding(.vertical, 10)
                                    .background(
                                        RoundedRectangle(cornerRadius: 10)
                                            .fill(Color(.cardBackground))
                                    )
                            }
                            
                            // 시간 선택
                            VStack(alignment: .leading, spacing: 8) {
                                Text("시간 (오늘)")
                                    .font(.subheadline)
                                    .fontWeight(.semibold)
                                    .foregroundColor(.mainBrown)
                                
                                HStack {
                                    Image(systemName: "clock")
                                        .foregroundColor(.mainBrown)
                                    
                                    DatePicker(
                                        "",
                                        selection: $viewModel.time,
                                        displayedComponents: .hourAndMinute
                                    )
                                    .labelsHidden()
                                    //.backgroundColor(.mainBrown)
                                }
                                .padding(.horizontal, 12)
                                .padding(.vertical, 10)
                                .background(
                                    RoundedRectangle(cornerRadius: 10)
                                        .fill(Color(.cardBackground))
                                )
                            }
                        }
                        .padding(20)
                        .background(
                            RoundedRectangle(cornerRadius: 18)
                                .fill(Color(.systemBackground))
                                .shadow(color: Color.black.opacity(0.05), radius: 12, x: 0, y: 4)
                        )
                        .padding(.horizontal, 16)
                        
                        Spacer(minLength: 40)
                    }
                }
                
                // 하단 저장 버튼
                VStack {
                    Button(action: {
                        let schedule = viewModel.buildSchedule()
                        di.scheduleService.add(schedule)
                        di.router.pop()
                    }) {
                        Text("일정 저장")
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 14)
                            .background(
                                RoundedRectangle(cornerRadius: 14)
                                    .fill(viewModel.name.isEmpty ? Color(.dividerCol) : Color.mainBrown)
                            )
                    }
                    .disabled(viewModel.name.isEmpty)
                    .padding(.horizontal, 20)
                    .padding(.top, 8)
                    .padding(.bottom, 20)
                }
                .background(
                    Color(.cardBackground)
                        .ignoresSafeArea(edges: .bottom)
                )
            }
        }
    }
}

#Preview {
    ScheduleView()
}
