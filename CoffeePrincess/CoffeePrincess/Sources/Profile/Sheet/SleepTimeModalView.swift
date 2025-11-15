//
//  SleepTimeModalView.swift
//  CoffeePrincess
//
//  Created by 김나영 on 11/16/25.
//

import SwiftUI

// MARK: - 수면 시간 수정 모달

struct SleepTimeModalView: View {
    @ObservedObject var profileViewModel: ProfileViewModel
    @Environment(\.dismiss) var dismiss

    @State private var bedtime: String = "23:30"
    @State private var wakeTime: String = "07:30"

    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                ProfileTimePicker(
                    title: "잠드는 시간",
                    selection: $bedtime,
                    profileViewModel: profileViewModel
                )

                ProfileTimePicker(
                    title: "일어나는 시간",
                    selection: $wakeTime,
                    profileViewModel: profileViewModel
                )

                Spacer()

                Button(action: {
                    profileViewModel.userInfo.bedtime = bedtime
                    profileViewModel.userInfo.wakeTime = wakeTime
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
            .navigationTitle("수면 시간 수정")
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
            bedtime = profileViewModel.userInfo.bedtime.isEmpty ? "23:30" : profileViewModel.userInfo.bedtime
            wakeTime = profileViewModel.userInfo.wakeTime.isEmpty ? "07:30" : profileViewModel.userInfo.wakeTime
        }
    }
}
