//
//  TargetSleepModalView.swift
//  CoffeePrincess
//
//  Created by 김나영 on 11/16/25.
//

import SwiftUI

// MARK: - 목표 수면 시간 수정 모달

struct TargetSleepModalView: View {
    @ObservedObject var profileViewModel: ProfileViewModel
    @Environment(\.dismiss) var dismiss

    @State private var selectedHours: Int = 7
    @State private var selectedMinutes: Int = 30
    
    private let hourOptions = Array(1...15)
    private let minuteOptions = [0, 15, 30, 45]

    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                VStack(alignment: .leading, spacing: 10) {
                    Text("목표 수면 시간")
                        .font(.pretendard(.medium, size: 15))
                        .foregroundColor(.mainBrown)

                    HStack(spacing: 0) {
                        // 시간 선택
                        VStack(spacing: 8) {
                            Text("시간")
                                .font(.pretendard(.medium, size: 14))
                                .foregroundColor(.mainBrown)
                            
                            Picker("시간", selection: $selectedHours) {
                                ForEach(hourOptions, id: \.self) { hour in
                                    Text("\(hour)").tag(hour)
                                }
                            }
                            .pickerStyle(.wheel)
                            .tint(.mainBrown)
                            .frame(maxWidth: .infinity)
                        }
                        
                        // 분 선택
                        VStack(spacing: 8) {
                            Text("분")
                                .font(.pretendard(.medium, size: 14))
                                .foregroundColor(.mainBrown)
                            
                            Picker("분", selection: $selectedMinutes) {
                                ForEach(minuteOptions, id: \.self) { minute in
                                    Text("\(minute)").tag(minute)
                                }
                            }
                            .pickerStyle(.wheel)
                            .tint(.mainBrown)
                            .frame(maxWidth: .infinity)
                        }
                    }
                    .padding(12)
                    .background(Color.sectionBackground)
                    .cornerRadius(10)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.dividerCol, lineWidth: 1)
                    )
                }

                Spacer()

                Button(action: {
                    let totalSleep = Double(selectedHours) + Double(selectedMinutes) / 60.0
                    profileViewModel.userInfo.targetSleep = totalSleep
                    profileViewModel.saveUserInfo()
                    dismiss()
                }) {
                    Text("저장")
                        .font(.pretendard(.semiBold, size: 17))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 14)
                        .background(Color.mainBrown)
                        .cornerRadius(12)
                }
            }
            .padding(20)
            .navigationTitle("목표 수면 시간 수정")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("닫기") { dismiss() }
                        .font(.pretendard(.medium, size: 16))
                        .foregroundColor(.mainBrown)
                }
            }
        }
        .task {
            let currentSleep = profileViewModel.userInfo.targetSleep
            selectedHours = Int(currentSleep)
            selectedMinutes = Int((currentSleep - Double(Int(currentSleep))) * 60)
            // 분을 15분 단위로 반올림
            selectedMinutes = minuteOptions.min(by: { abs($0 - selectedMinutes) < abs($1 - selectedMinutes) }) ?? 0
        }
    }
}
