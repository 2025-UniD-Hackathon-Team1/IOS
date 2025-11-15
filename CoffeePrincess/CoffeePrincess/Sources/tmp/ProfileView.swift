//
//  ProfileView.swift
//  cafe_frame
//
//  Created by 김세은 on 11/15/25.
//

import SwiftUI

struct ProfileView: View {
    @ObservedObject var tracker: CaffeineTracker
    @ObservedObject var userInfoManager: UserInfoManager
    @Environment(\.dismiss) var dismiss
    @State private var showSleepTimeModal = false
    @State private var showTargetSleepModal = false
    @State private var showMaxCaffeineModal = false
    
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
                    VStack(spacing: 30) {
                        // 프로필 헤더
                        VStack(spacing: 20) {
                            Text("👤")
                                .font(.system(size: 48))
                                .frame(width: 100, height: 100)
                                .background(Color(hex: "#FFF5E9"))
                                .clipShape(Circle())
                                .overlay(
                                    Circle()
                                        .stroke(Color(hex: "#EEDCC6"), lineWidth: 3)
                                )
                            
                            Text("사용자 님")
                                .font(.system(size: 24, weight: .bold))
                                .foregroundColor(Color(hex: "#230C02"))
                            
                            Text("카페인 타입: \(userInfoManager.getCaffeineType())")
                                .font(.system(size: 16, weight: .semibold))
                                .foregroundColor(Color(hex: "#8B6F47"))
                        }
                        .padding(30)
                        .frame(maxWidth: .infinity)
                        .background(Color(hex: "#FCF2D9"))
                        .cornerRadius(16)
                        .overlay(
                            RoundedRectangle(cornerRadius: 16)
                                .stroke(Color(hex: "#EEDCC6"), lineWidth: 1)
                        )
                        
                        // 개인 설정 섹션
                        ProfileSection(title: "개인 설정") {
                            SettingRow(
                                label: "평소 수면 시간대",
                                value: formatSleepTimeRange(),
                                action: { showSleepTimeModal = true }
                            )
                            
                            SettingRow(
                                label: "목표 수면 시간",
                                value: formatTargetSleep(),
                                action: { showTargetSleepModal = true }
                            )
                            
                            Button(action: {
                                // 재측정 로직
                                userInfoManager.userInfo.step = 0
                                userInfoManager.userInfo.completed = false
                                userInfoManager.saveUserInfo()
                                dismiss()
                            }) {
                                HStack {
                                    Text("카페인 민감도 재측정")
                                        .font(.system(size: 16, weight: .semibold))
                                        .foregroundColor(Color(hex: "#FFF5E9"))
                                    Spacer()
                                }
                                .padding(.vertical, 10)
                                .padding(.horizontal, 20)
                                .background(
                                    LinearGradient(
                                        gradient: Gradient(colors: [Color(hex: "#EEDCC6"), Color(hex: "#230C02")]),
                                        startPoint: .leading,
                                        endPoint: .trailing
                                    )
                                )
                                .cornerRadius(12)
                            }
                        }
                        
                        // 건강 정보 섹션
                        ProfileSection(title: "건강 정보") {
                            InfoRow(
                                label: "심장이 과하게 뛴 경험:",
                                value: "\"\(userInfoManager.getHeartRateText())\""
                            )
                            
                            InfoRow(
                                label: "1일 최대 카페인 제한치:",
                                value: "\(userInfoManager.userInfo.maxCaffeine)mg",
                                showEdit: true,
                                action: { showMaxCaffeineModal = true }
                            )
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 30)
                }
            }
            .navigationTitle("프로필")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: { dismiss() }) {
                        Image(systemName: "chevron.left")
                            .foregroundColor(Color(hex: "#230C02"))
                    }
                }
            }
        }
        .sheet(isPresented: $showSleepTimeModal) {
            SleepTimeModalView(userInfoManager: userInfoManager)
        }
        .sheet(isPresented: $showTargetSleepModal) {
            TargetSleepModalView(userInfoManager: userInfoManager)
        }
        .sheet(isPresented: $showMaxCaffeineModal) {
            MaxCaffeineModalView(userInfoManager: userInfoManager)
        }
    }
    
    private func formatSleepTimeRange() -> String {
        let bedtime = formatTime(userInfoManager.userInfo.bedtime)
        let wakeTime = formatTime(userInfoManager.userInfo.wakeTime)
        return "\(bedtime) ~ \(wakeTime)"
    }
    
    private func formatTime(_ time: String) -> String {
        let components = time.split(separator: ":")
        guard components.count == 2,
              let hour = Int(components[0]),
              let minute = Int(components[1]) else {
            return time
        }
        
        let ampm = hour >= 12 ? "오후" : "오전"
        let displayHour = hour > 12 ? hour - 12 : (hour == 0 ? 12 : hour)
        return "\(ampm) \(displayHour):\(String(format: "%02d", minute))"
    }
    
    private func formatTargetSleep() -> String {
        let hours = Int(userInfoManager.userInfo.targetSleep)
        let minutes = Int((userInfoManager.userInfo.targetSleep - Double(hours)) * 60)
        if minutes == 0 {
            return "\(hours)시간"
        } else {
            return "\(hours)시간 \(minutes)분"
        }
    }
    
}

struct ProfileSection<Content: View>: View {
    let title: String
    let content: Content
    
    init(title: String, @ViewBuilder content: () -> Content) {
        self.title = title
        self.content = content()
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text(title)
                .font(.system(size: 18, weight: .bold))
                .foregroundColor(Color(hex: "#230C02"))
                .padding(.bottom, 12)
                .overlay(
                    Rectangle()
                        .frame(height: 2)
                        .foregroundColor(Color(hex: "#EEDCC6")),
                    alignment: .bottom
                )
            
            VStack(spacing: 0) {
                content
            }
        }
        .padding(20)
        .background(Color(hex: "#FFF5E9"))
        .cornerRadius(16)
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(Color(hex: "#EEDCC6"), lineWidth: 1)
        )
        .shadow(color: Color.black.opacity(0.05), radius: 4, x: 0, y: 2)
    }
}

struct SettingRow: View {
    let label: String
    let value: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack {
                Text(label)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(Color(hex: "#230C02"))
                Spacer()
                HStack(spacing: 12) {
                    Text(value)
                        .font(.system(size: 16))
                        .foregroundColor(Color(hex: "#8B6F47"))
                    Image(systemName: "chevron.down")
                        .font(.system(size: 12))
                        .foregroundColor(Color(hex: "#8B6F47"))
                }
            }
            .padding(.vertical, 16)
            .overlay(
                Rectangle()
                    .frame(height: 1)
                    .foregroundColor(Color(hex: "#EEDCC6")),
                alignment: .bottom
            )
        }
    }
}

struct InfoRow: View {
    let label: String
    let value: String
    var showEdit: Bool = false
    var action: (() -> Void)? = nil
    
    var body: some View {
        HStack {
            Text(label)
                .font(.system(size: 16, weight: .semibold))
                .foregroundColor(Color(hex: "#230C02"))
            Spacer()
            HStack(spacing: 12) {
                Text(value)
                    .font(.system(size: 16))
                    .foregroundColor(Color(hex: "#8B6F47"))
                if showEdit {
                    Button(action: { action?() }) {
                        Text("수정")
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundColor(Color(hex: "#230C02"))
                            .underline()
                    }
                }
            }
        }
        .padding(.vertical, 16)
        .overlay(
            Rectangle()
                .frame(height: 1)
                .foregroundColor(Color(hex: "#EEDCC6")),
            alignment: .bottom
        )
    }
}

// 수면 시간 수정 모달
struct SleepTimeModalView: View {
    @ObservedObject var userInfoManager: UserInfoManager
    @Environment(\.dismiss) var dismiss
    @State private var bedtime: String = "23:30"
    @State private var wakeTime: String = "07:30"
    
    private let timeOptions: [String] = {
        var options: [String] = []
        for hour in 0..<24 {
            for minute in [0, 30] {
                options.append(String(format: "%02d:%02d", hour, minute))
            }
        }
        return options
    }()
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                VStack(alignment: .leading, spacing: 12) {
                    Text("잠드는 시간")
                        .font(.system(size: 14, weight: .semibold))
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
                    Text("일어나는 시간")
                        .font(.system(size: 14, weight: .semibold))
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
                
                Spacer()
                
                Button(action: {
                    userInfoManager.userInfo.bedtime = bedtime
                    userInfoManager.userInfo.wakeTime = wakeTime
                    userInfoManager.saveUserInfo()
                    dismiss()
                }) {
                    Text("저장")
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(Color(hex: "#FFF5E9"))
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(
                            LinearGradient(
                                gradient: Gradient(colors: [Color(hex: "#EEDCC6"), Color(hex: "#230C02")]),
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .cornerRadius(12)
                }
            }
            .padding(20)
            .navigationTitle("수면 시간 수정")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("닫기") { dismiss() }
                }
            }
        }
        .onAppear {
            bedtime = userInfoManager.userInfo.bedtime.isEmpty ? "23:30" : userInfoManager.userInfo.bedtime
            wakeTime = userInfoManager.userInfo.wakeTime.isEmpty ? "07:30" : userInfoManager.userInfo.wakeTime
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

// 목표 수면 시간 수정 모달
struct TargetSleepModalView: View {
    @ObservedObject var userInfoManager: UserInfoManager
    @Environment(\.dismiss) var dismiss
    @State private var targetSleep: Double = 7.5
    
    private let sleepOptions: [Double] = [6, 6.5, 7, 7.5, 8, 8.5, 9]
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                VStack(alignment: .leading, spacing: 12) {
                    Text("목표 수면 시간")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(Color(hex: "#230C02"))
                    
                    Picker("목표 수면 시간", selection: $targetSleep) {
                        ForEach(sleepOptions, id: \.self) { hours in
                            Text(formatSleepOption(hours)).tag(hours)
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
                
                Spacer()
                
                Button(action: {
                    userInfoManager.userInfo.targetSleep = targetSleep
                    userInfoManager.saveUserInfo()
                    dismiss()
                }) {
                    Text("저장")
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(Color(hex: "#FFF5E9"))
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(
                            LinearGradient(
                                gradient: Gradient(colors: [Color(hex: "#EEDCC6"), Color(hex: "#230C02")]),
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .cornerRadius(12)
                }
            }
            .padding(20)
            .navigationTitle("목표 수면 시간 수정")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("닫기") { dismiss() }
                }
            }
        }
        .onAppear {
            targetSleep = userInfoManager.userInfo.targetSleep
        }
    }
    
    private func formatSleepOption(_ hours: Double) -> String {
        let h = Int(hours)
        let m = Int((hours - Double(h)) * 60)
        if m == 0 {
            return "\(h)시간"
        } else {
            return "\(h)시간 \(m)분"
        }
    }
}

// 최대 카페인 제한치 수정 모달
struct MaxCaffeineModalView: View {
    @ObservedObject var userInfoManager: UserInfoManager
    @Environment(\.dismiss) var dismiss
    @State private var maxCaffeine: String = "140"
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                VStack(alignment: .leading, spacing: 12) {
                    Text("1일 최대 카페인 제한치 (mg)")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(Color(hex: "#230C02"))
                    
                    TextField("", text: $maxCaffeine)
                        .keyboardType(.numberPad)
                        .padding(14)
                        .background(Color(hex: "#FCF2D9"))
                        .cornerRadius(12)
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(Color(hex: "#EEDCC6"), lineWidth: 2)
                        )
                }
                
                Spacer()
                
                Button(action: {
                    if let value = Int(maxCaffeine), value >= 0 && value <= 500 {
                        userInfoManager.userInfo.maxCaffeine = value
                        userInfoManager.saveUserInfo()
                        dismiss()
                    }
                }) {
                    Text("저장")
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(Color(hex: "#FFF5E9"))
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(
                            LinearGradient(
                                gradient: Gradient(colors: [Color(hex: "#EEDCC6"), Color(hex: "#230C02")]),
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .cornerRadius(12)
                }
            }
            .padding(20)
            .navigationTitle("최대 카페인 제한치 수정")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("닫기") { dismiss() }
                }
            }
        }
        .onAppear {
            maxCaffeine = String(userInfoManager.userInfo.maxCaffeine)
        }
    }
}

