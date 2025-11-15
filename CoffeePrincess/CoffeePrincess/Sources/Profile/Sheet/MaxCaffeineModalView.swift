//
//  MaxCaffeineModalView.swift
//  CoffeePrincess
//
//  Created by 김나영 on 11/16/25.
//

import SwiftUI

// MARK: - 최대 카페인 제한치 수정 모달

struct MaxCaffeineModalView: View {
    @ObservedObject var profileViewModel: ProfileViewModel
    @Environment(\.dismiss) var dismiss

    @State private var maxCaffeine: String = "140"

    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                VStack(alignment: .leading, spacing: 10) {
                    Text("1일 최대 카페인 제한치 (mg)")
                        .font(.pretendard(.medium, size: 15))
                        .foregroundColor(.mainBrown)

                    TextField("", text: $maxCaffeine)
                        .font(.pretendard(.medium, size: 16))
                        .keyboardType(.numberPad)
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
                    if let value = Int(maxCaffeine), value >= 0 && value <= 500 {
                        profileViewModel.userInfo.maxCaffeine = value
                        profileViewModel.saveUserInfo()
                        dismiss()
                    }
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
            .navigationTitle("최대 카페인 제한치 수정")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("닫기") { dismiss() }
                        .font(.pretendard(.medium, size: 16))
                        .foregroundColor(.mainBrown)
                }
            }
        }
        .onAppear {
            maxCaffeine = String(profileViewModel.userInfo.maxCaffeine)
        }
    }
}
