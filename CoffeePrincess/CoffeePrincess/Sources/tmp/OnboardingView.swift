//
//  OnboardingView.swift
//  cafe_frame
//
//  Created by 김세은 on 11/15/25.
//

import SwiftUI

struct OnboardingView: View {
    @ObservedObject var userInfoManager: UserInfoManager
    @State private var tolerance: Double = 50
    @State private var heartRate: String = ""
    @State private var showAlert = false
    @State private var alertMessage = ""
    
    var body: some View {
        NavigationView {
            ZStack {
                // 배경 그라데이션
                LinearGradient(
                    gradient: Gradient(colors: [Color(hex: "#FCF2D9"), Color(hex: "#EEDCC6")]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 40) {
                        // 타이틀
                        Text("평소 카페인, 어느 정도 잘 맞나요?")
                            .font(.system(size: 24, weight: .bold))
                            .foregroundColor(Color(hex: "#230C02"))
                            .multilineTextAlignment(.center)
                            .padding(.top, 40)
                        
                        // 슬라이더 섹션
                        VStack(spacing: 20) {
                            HStack {
                                Text("전혀 못 마심")
                                    .font(.system(size: 14, weight: .semibold))
                                    .foregroundColor(Color(hex: "#230C02"))
                                Spacer()
                                Text("매우 둔감")
                                    .font(.system(size: 14, weight: .semibold))
                                    .foregroundColor(Color(hex: "#230C02"))
                            }
                            
                            Slider(value: $tolerance, in: 0...100, step: 1)
                                .tint(Color(hex: "#230C02"))
                            
                            Text("\(Int(tolerance))")
                                .font(.system(size: 18, weight: .bold))
                                .foregroundColor(Color(hex: "#230C02"))
                        }
                        .padding(20)
                        .background(Color(hex: "#FCF2D9"))
                        .cornerRadius(16)
                        .overlay(
                            RoundedRectangle(cornerRadius: 16)
                                .stroke(Color(hex: "#EEDCC6"), lineWidth: 1)
                        )
                        
                        // 질문 2
                        VStack(alignment: .leading, spacing: 24) {
                            Text("카페인 섭취 후 심장이 과하게 뛴 경험이 있었나요?")
                                .font(.system(size: 18, weight: .semibold))
                                .foregroundColor(Color(hex: "#230C02"))
                            
                            VStack(spacing: 12) {
                                RadioOption(
                                    title: "자주 있다",
                                    isSelected: heartRate == "often",
                                    action: { heartRate = "often" }
                                )
                                RadioOption(
                                    title: "가끔 있다",
                                    isSelected: heartRate == "sometimes",
                                    action: { heartRate = "sometimes" }
                                )
                                RadioOption(
                                    title: "거의 없다",
                                    isSelected: heartRate == "rarely",
                                    action: { heartRate = "rarely" }
                                )
                                RadioOption(
                                    title: "없음",
                                    isSelected: heartRate == "never",
                                    action: { heartRate = "never" }
                                )
                            }
                        }
                        
                        // 다음 버튼
                        Button(action: {
                            if heartRate.isEmpty {
                                alertMessage = "카페인 섭취 후 심장 박동 경험을 선택해주세요."
                                showAlert = true
                            } else {
                                userInfoManager.userInfo.tolerance = Int(tolerance)
                                userInfoManager.userInfo.heartRate = heartRate
                                userInfoManager.userInfo.step = 1
                                userInfoManager.userInfo.timestamp = Date().timeIntervalSince1970
                                userInfoManager.saveUserInfo()
                            }
                        }) {
                            Text("다음")
                                .font(.system(size: 18, weight: .semibold))
                                .foregroundColor(Color(hex: "#FFF5E9"))
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 18)
                                .background(
                                    LinearGradient(
                                        gradient: Gradient(colors: [Color(hex: "#EEDCC6"), Color(hex: "#230C02")]),
                                        startPoint: .leading,
                                        endPoint: .trailing
                                    )
                                )
                                .cornerRadius(16)
                                .shadow(color: Color.black.opacity(0.2), radius: 6, x: 0, y: 4)
                        }
                        .padding(.bottom, 40)
                    }
                    .padding(.horizontal, 20)
                }
            }
            .navigationBarHidden(true)
            .alert("알림", isPresented: $showAlert) {
                Button("확인", role: .cancel) { }
            } message: {
                Text(alertMessage)
            }
        }
    }
}

struct RadioOption: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack {
                ZStack {
                    Circle()
                        .stroke(isSelected ? Color(hex: "#230C02") : Color(hex: "#8B6F47"), lineWidth: 2)
                        .frame(width: 20, height: 20)
                    
                    if isSelected {
                        Circle()
                            .fill(Color(hex: "#230C02"))
                            .frame(width: 20, height: 20)
                        
                        Circle()
                            .fill(Color(hex: "#FFF5E9"))
                            .frame(width: 10, height: 10)
                    }
                }
                
                Text(title)
                    .font(.system(size: 16))
                    .foregroundColor(isSelected ? Color(hex: "#230C02") : Color(hex: "#230C02"))
                    .fontWeight(isSelected ? .semibold : .regular)
                
                Spacer()
            }
            .padding(16)
            .background(isSelected ? Color(hex: "#FFF5E9") : Color(hex: "#FCF2D9"))
            .cornerRadius(12)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(isSelected ? Color(hex: "#230C02") : Color(hex: "#EEDCC6"), lineWidth: 2)
            )
        }
    }
}
