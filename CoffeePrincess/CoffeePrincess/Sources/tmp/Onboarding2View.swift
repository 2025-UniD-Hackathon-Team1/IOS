//
//  Onboarding2View.swift
//  cafe_frame
//
//  Created by 김세은 on 11/15/25.
//

import SwiftUI

struct Onboarding2View: View {
    @ObservedObject var userInfoManager: UserInfoManager
    @State private var bedtime: String = "23:30"
    @State private var wakeTime: String = "07:30"
    @State private var selectedImportantTimes: Set<String> = []
    @State private var showAlert = false
    @State private var alertMessage = ""
    
    private let timeOptions: [String] = {
        var options: [String] = []
        for hour in 0..<24 {
            for minute in [0, 30] {
                let timeValue = String(format: "%02d:%02d", hour, minute)
                let hour12 = hour == 0 ? 12 : (hour > 12 ? hour - 12 : hour)
                let ampm = hour < 12 ? "오전" : "오후"
                let display = "\(ampm) \(hour12):\(String(format: "%02d", minute))"
                options.append(timeValue)
            }
        }
        return options
    }()
    
    private let importantTimeOptions = [
        ("morning", "오전 9~12시"),
        ("afternoon1", "오후 1~3시"),
        ("afternoon2", "오후 3~6시")
    ]
    
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
                    // 섹션 타이틀
                    Text("1-3. 수면 & 일정 기본 패턴")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(Color(hex: "#8B6F47"))
                    
                    // 타이틀
                    Text("평소 수면 패턴을 알려주세요")
                        .font(.system(size: 24, weight: .bold))
                        .foregroundColor(Color(hex: "#230C02"))
                        .multilineTextAlignment(.center)
                    
                    // 입력 영역
                    VStack(spacing: 20) {
                        VStack(alignment: .leading, spacing: 12) {
                            Text("평소 잠드는 시간")
                                .font(.system(size: 16, weight: .semibold))
                                .foregroundColor(Color(hex: "#230C02"))
                            
                            Picker("잠드는 시간", selection: $bedtime) {
                                ForEach(timeOptions, id: \.self) { time in
                                    Text(formatTimeDisplay(time)).tag(time)
                                }
                            }
                            .pickerStyle(.menu)
                            .padding(14)
                            .background(Color(hex: "#FCF2D9"))
                            .cornerRadius(12)
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(Color(hex: "#EEDCC6"), lineWidth: 2)
                            )
                        }
                        
                        VStack(alignment: .leading, spacing: 12) {
                            Text("평소 일어나는 시간")
                                .font(.system(size: 16, weight: .semibold))
                                .foregroundColor(Color(hex: "#230C02"))
                            
                            Picker("일어나는 시간", selection: $wakeTime) {
                                ForEach(timeOptions, id: \.self) { time in
                                    Text(formatTimeDisplay(time)).tag(time)
                                }
                            }
                            .pickerStyle(.menu)
                            .padding(14)
                            .background(Color(hex: "#FCF2D9"))
                            .cornerRadius(12)
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(Color(hex: "#EEDCC6"), lineWidth: 2)
                            )
                        }
                    }
                    
                    // 구분선
                    Rectangle()
                        .fill(Color(hex: "#EEDCC6"))
                        .frame(height: 1)
                        .padding(.vertical, 30)
                    
                    // 질문
                    VStack(alignment: .leading, spacing: 24) {
                        Text("평일에 중요한 일정이 많은 시간대는 언제인가요?")
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundColor(Color(hex: "#230C02"))
                        
                        VStack(spacing: 12) {
                            ForEach(importantTimeOptions, id: \.0) { option in
                                CheckboxOption(
                                    title: option.1,
                                    isSelected: selectedImportantTimes.contains(option.0),
                                    action: {
                                        if selectedImportantTimes.contains(option.0) {
                                            selectedImportantTimes.remove(option.0)
                                        } else {
                                            selectedImportantTimes.insert(option.0)
                                        }
                                    }
                                )
                            }
                        }
                    }
                    
                    // 다음 버튼
                    Button(action: {
                        if bedtime.isEmpty || wakeTime.isEmpty {
                            alertMessage = "수면 시간을 모두 선택해주세요."
                            showAlert = true
                        } else if selectedImportantTimes.isEmpty {
                            alertMessage = "중요한 일정이 많은 시간대를 최소 1개 이상 선택해주세요."
                            showAlert = true
                        } else {
                            userInfoManager.userInfo.bedtime = bedtime
                            userInfoManager.userInfo.wakeTime = wakeTime
                            userInfoManager.userInfo.importantTimes = Array(selectedImportantTimes)
                            userInfoManager.userInfo.completed = true
                            userInfoManager.userInfo.step = 2
                            userInfoManager.userInfo.timestamp = Date().timeIntervalSince1970
                            userInfoManager.saveUserInfo()
                            // ContentView가 자동으로 MainView로 전환됨
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
        }
        .alert("알림", isPresented: $showAlert) {
            Button("확인", role: .cancel) { }
        } message: {
            Text(alertMessage)
        }
        .onAppear {
            if userInfoManager.userInfo.bedtime.isEmpty {
                bedtime = "23:30"
                wakeTime = "07:30"
            } else {
                bedtime = userInfoManager.userInfo.bedtime
                wakeTime = userInfoManager.userInfo.wakeTime
            }
        }
    }
    
    private func formatTimeDisplay(_ time: String) -> String {
        let components = time.split(separator: ":")
        guard components.count == 2,
              let hour = Int(components[0]),
              let minute = Int(components[1]) else {
            return time
        }
        
        let hour12 = hour == 0 ? 12 : (hour > 12 ? hour - 12 : hour)
        let ampm = hour < 12 ? "오전" : "오후"
        return "\(ampm) \(hour12):\(String(format: "%02d", minute))"
    }
}

struct CheckboxOption: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack {
                ZStack {
                    RoundedRectangle(cornerRadius: 4)
                        .stroke(isSelected ? Color(hex: "#230C02") : Color(hex: "#8B6F47"), lineWidth: 2)
                        .frame(width: 20, height: 20)
                        .background(isSelected ? Color(hex: "#230C02") : Color(hex: "#FFF5E9"))
                    
                    if isSelected {
                        Text("✓")
                            .font(.system(size: 14, weight: .bold))
                            .foregroundColor(Color(hex: "#FFF5E9"))
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

