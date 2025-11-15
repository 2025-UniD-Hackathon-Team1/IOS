//
//  MainView.swift
//  cafe_frame
//
//  Created by 김세은 on 11/15/25.
//

import SwiftUI

struct MainView: View {
    @ObservedObject var tracker: CaffeineTracker
    @ObservedObject var userInfoManager: UserInfoManager
    @State private var timer: Timer?
    @State private var showAddCaffeine = false
    @State private var showProfile = false
    
    private func formatTime(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.dateFormat = "a h:mm"
        return formatter.string(from: date)
    }
    
    var body: some View {
        ZStack {
            // 배경 그라데이션
            LinearGradient(
                gradient: Gradient(colors: [Color(hex: "#FCF2D9"), Color(hex: "#EEDCC6")]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            VStack(spacing: 0) {
                // 상단 앱바
                HStack {
                    Text("오늘")
                        .font(.system(size: 20, weight: .bold))
                        .foregroundColor(Color(hex: "#230C02"))
                    
                    Spacer()
                    
                    HStack(spacing: 12) {
                        Button(action: {}) {
                            Image(systemName: "bell")
                                .font(.system(size: 20))
                                .foregroundColor(Color(hex: "#230C02"))
                                .frame(width: 40, height: 40)
                                .background(Color.clear)
                                .clipShape(Circle())
                        }
                        
                        Button(action: { showProfile = true }) {
                            Text("👤")
                                .font(.system(size: 20))
                                .frame(width: 40, height: 40)
                                .background(Color(hex: "#FCF2D9"))
                                .clipShape(Circle())
                                .overlay(
                                    Circle()
                                        .stroke(Color(hex: "#EEDCC6"), lineWidth: 2)
                                )
                        }
                    }
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 16)
                .background(Color(hex: "#FFF5E9"))
                .overlay(
                    Rectangle()
                        .frame(height: 1)
                        .foregroundColor(Color(hex: "#EEDCC6")),
                    alignment: .bottom
                )
                
                ScrollView {
                    VStack(spacing: 16) {
                        // 블록 1 - 카페인 지수 상태바
                        StatusSectionView(tracker: tracker)
                        
                        // 블록 2 - 일정 & 추천
                        ScheduleRecommendationView(userInfoManager: userInfoManager)
                        
                        // 블록 3 - 현재 상태
                        CurrentStatusView(tracker: tracker)
                        
                        // 블록 4 - 수면 영향
                        SleepImpactView(tracker: tracker, userInfoManager: userInfoManager)
                        
                        // 블록 5 - 오늘 마신 커피
                        TodayDrinksView(tracker: tracker)
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 20)
                    .padding(.bottom, 100)
                }
            }
            
            // 하단 고정 버튼
            VStack {
                Spacer()
                Button(action: { showAddCaffeine = true }) {
                    HStack {
                        Text("+")
                            .font(.system(size: 24, weight: .light))
                        Text("커피 기록하기")
                            .font(.system(size: 18, weight: .semibold))
                    }
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
                    .cornerRadius(16)
                    .shadow(color: Color.black.opacity(0.2), radius: 6, x: 0, y: 4)
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 16)
                .background(Color(hex: "#FFF5E9"))
                .overlay(
                    Rectangle()
                        .frame(height: 1)
                        .foregroundColor(Color(hex: "#EEDCC6")),
                    alignment: .top
                )
            }
        }
        .sheet(isPresented: $showAddCaffeine) {
            AddCaffeineView(tracker: tracker)
        }
        .sheet(isPresented: $showProfile) {
            ProfileView(tracker: tracker, userInfoManager: userInfoManager)
        }
        .onAppear {
            startTimer()
        }
        .onDisappear {
            stopTimer()
        }
    }
    
    private func startTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 60, repeats: true) { _ in
            tracker.objectWillChange.send()
        }
    }
    
    private func stopTimer() {
        timer?.invalidate()
        timer = nil
    }
}

// 블록 1 - 카페인 지수 상태바
struct StatusSectionView: View {
    @ObservedObject var tracker: CaffeineTracker
    
    var body: some View {
        HStack(spacing: 20) {
            // 왼쪽: 세로형 카페인 지수 상태바
            VStack(spacing: 12) {
                Text("카페인 지수")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(Color(hex: "#230C02"))
                
                ZStack(alignment: .bottom) {
                    // 배경 바
                    RoundedRectangle(cornerRadius: 15)
                        .fill(Color(hex: "#FCF2D9"))
                        .frame(width: 30, height: 200)
                        .overlay(
                            RoundedRectangle(cornerRadius: 15)
                                .stroke(Color(hex: "#EEDCC6"), lineWidth: 2)
                        )
                    
                    // 채워진 바
                    let percentage = tracker.getCaffeinePercentage()
                    RoundedRectangle(cornerRadius: 15)
                        .fill(
                            LinearGradient(
                                gradient: Gradient(colors: [
                                    Color(hex: "#FCF2D9"),
                                    Color(hex: "#EEDCC6"),
                                    Color(hex: "#230C02")
                                ]),
                                startPoint: .top,
                                endPoint: .bottom
                            )
                        )
                        .frame(width: 30, height: 200 * percentage / 100)
                }
                
                Text("\(Int(tracker.calculateCurrentCaffeine()))mg")
                    .font(.system(size: 18, weight: .bold))
                    .foregroundColor(Color(hex: "#230C02"))
            }
            
            // 오른쪽: 시간 경과 및 상태
            VStack(spacing: 8) {
                Text("상태")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(Color(hex: "#230C02"))
                
                let status = tracker.getStatus(currentCaffeine: tracker.calculateCurrentCaffeine())
                Text(status.icon)
                    .font(.system(size: 48))
                
                Text(status.text)
                    .font(.system(size: 18, weight: .bold))
                    .foregroundColor(Color(hex: "#230C02"))
                
                if let timeSince = tracker.getTimeSinceLastIntake() {
                    let hours = Int(timeSince.hours)
                    let minutes = Int((timeSince.hours - Double(hours)) * 60)
                    if hours > 0 {
                        Text("\(hours)시간 \(minutes)분 전")
                            .font(.system(size: 14))
                            .foregroundColor(Color(hex: "#8B6F47"))
                    } else {
                        Text("\(minutes)분 전")
                            .font(.system(size: 14))
                            .foregroundColor(Color(hex: "#8B6F47"))
                    }
                } else {
                    Text("섭취 기록 없음")
                        .font(.system(size: 14))
                        .foregroundColor(Color(hex: "#8B6F47"))
                }
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

// 블록 2 - 일정 & 추천
struct ScheduleRecommendationView: View {
    @ObservedObject var userInfoManager: UserInfoManager
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("오늘의 일정 기반 추천")
                .font(.system(size: 18, weight: .bold))
                .foregroundColor(Color(hex: "#230C02"))
            
            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    Text("오늘 14:00")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(Color(hex: "#230C02"))
                    Text("- 중요 PT 일정")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(Color(hex: "#8B6F47"))
                }
                (
                    Text("최상의 각성 상태를 위해\n") +
                    Text("오후 1시 15분에 커피").bold() +
                    Text("를 드시는 것을 추천합니다.")
                )
                .font(.system(size: 15))
                .foregroundColor(Color(hex: "#230C02"))
            }
            .padding(16)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(
                LinearGradient(
                    gradient: Gradient(colors: [Color(hex: "#FCF2D9"), Color(hex: "#EEDCC6")]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
            .cornerRadius(12)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Color(hex: "#EEDCC6"), lineWidth: 1)
            )
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

// 블록 3 - 현재 상태
struct CurrentStatusView: View {
    @ObservedObject var tracker: CaffeineTracker
    
    private func formatTime(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.dateFormat = "a h:mm"
        return formatter.string(from: date)
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("현재 상태")
                .font(.system(size: 18, weight: .bold))
                .foregroundColor(Color(hex: "#230C02"))
            
            VStack(spacing: 12) {
                StatusRow(
                    label: "현재 체내 카페인 농도:",
                    value: "\(Int(tracker.getCaffeinePercentage()))%"
                )
                
                StatusRow(
                    label: "각성 상태:",
                    value: "🔋 에너지 레벨 \(Int(tracker.getEnergyLevel()))%"
                )
                
                if let awakeEndTime = tracker.getAwakeEndTime() {
                    StatusRow(
                        label: "예상 각성 종료:",
                        value: formatTime(awakeEndTime)
                    )
                } else {
                    StatusRow(
                        label: "예상 각성 종료:",
                        value: "-"
                    )
                }
            }
            .padding(16)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(Color(hex: "#FCF2D9"))
            .cornerRadius(12)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Color(hex: "#EEDCC6"), lineWidth: 1)
            )
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

struct StatusRow: View {
    let label: String
    let value: String
    
    var body: some View {
        HStack {
            Text(label)
                .font(.system(size: 14))
                .foregroundColor(Color(hex: "#8B6F47"))
            Spacer()
            Text(value)
                .font(.system(size: 14, weight: .semibold))
                .foregroundColor(Color(hex: "#230C02"))
        }
        .padding(.vertical, 12)
        .overlay(
            Rectangle()
                .frame(height: 1)
                .foregroundColor(Color(hex: "#EEDCC6")),
            alignment: .bottom
        )
    }
}

// 블록 4 - 수면 영향
struct SleepImpactView: View {
    @ObservedObject var tracker: CaffeineTracker
    @ObservedObject var userInfoManager: UserInfoManager
    
    private func formatTime(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.dateFormat = "a h:mm"
        return formatter.string(from: date)
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("오늘 밤 수면 예측")
                .font(.system(size: 18, weight: .bold))
                .foregroundColor(Color(hex: "#230C02"))
            
            VStack(alignment: .leading, spacing: 16) {
                let sleepProb = tracker.getSleepDisruptionProbability(userBedtime: userInfoManager.userInfo.bedtime)
                Text("오늘 섭취한 카페인 때문에\n수면 방해 확률이 **\(sleepProb)%**입니다.")
                    .font(.system(size: 15))
                    .foregroundColor(Color(hex: "#230C02"))
                
                VStack(spacing: 8) {
                    if let timeSince = tracker.getTimeSinceLastIntake() {
                        let lastIntakeDate = Date(timeIntervalSince1970: timeSince.timestamp)
                        DetailRow(
                            label: "마지막 카페인 섭취 시각:",
                            value: formatTime(lastIntakeDate)
                        )
                    } else {
                        DetailRow(
                            label: "마지막 카페인 섭취 시각:",
                            value: "-"
                        )
                    }
                    
                    let bedtime = userInfoManager.userInfo.bedtime
                    let components = bedtime.split(separator: ":")
                    if components.count == 2,
                       let hour = Int(components[0]),
                       let minute = Int(components[1]) {
                        let ampm = hour >= 12 ? "오후" : "오전"
                        let displayHour = hour > 12 ? hour - 12 : (hour == 0 ? 12 : hour)
                        DetailRow(
                            label: "평소 취침 시간:",
                            value: "\(ampm) \(displayHour):\(String(format: "%02d", minute))"
                        )
                    }
                }
                .padding(.top, 12)
                .overlay(
                    Rectangle()
                        .frame(height: 1)
                        .foregroundColor(Color(hex: "#EEDCC6")),
                    alignment: .top
                )
            }
            .padding(16)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(Color(hex: "#FCF2D9"))
            .cornerRadius(12)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Color(hex: "#EEDCC6"), lineWidth: 1)
            )
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

struct DetailRow: View {
    let label: String
    let value: String
    
    var body: some View {
        HStack {
            Text(label)
                .font(.system(size: 13))
                .foregroundColor(Color(hex: "#8B6F47"))
            Spacer()
            Text(value)
                .font(.system(size: 13, weight: .semibold))
                .foregroundColor(Color(hex: "#230C02"))
        }
    }
}

// 블록 5 - 오늘 마신 커피
struct TodayDrinksView: View {
    @ObservedObject var tracker: CaffeineTracker
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("오늘 마신 커피")
                .font(.system(size: 18, weight: .bold))
                .foregroundColor(Color(hex: "#230C02"))
            
            let todayDrinks = tracker.getTodayDrinks()
            if todayDrinks.isEmpty {
                Text("아직 마신 커피가 없습니다")
                    .font(.system(size: 14))
                    .foregroundColor(Color(hex: "#8B6F47"))
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 40)
            } else {
                VStack(spacing: 8) {
                    ForEach(todayDrinks) { entry in
                        DrinkItemView(entry: entry)
                    }
                }
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
struct DrinkItemView: View {
    let entry: CaffeineEntry
    
    // MARK: - 계산된 프로퍼티 (ViewBuilder 바깥에서 처리)
    private var formattedTime: String {
        let date = Date(timeIntervalSince1970: entry.timestamp)
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.dateFormat = "a h:mm"
        return formatter.string(from: date)
    }
    
    private var closestDrink: Drink {
        findClosestDrink(amount: entry.amount)
    }
    
    var body: some View {
        HStack(spacing: 12) {
            Text(closestDrink.icon)
                .font(.system(size: 24))
            
            Text(closestDrink.name)
                .font(.system(size: 15, weight: .semibold))
                .foregroundColor(Color(hex: "#230C02"))
            
            Spacer()
            
            Text("\(entry.amount)mg · \(formattedTime)")
                .font(.system(size: 13))
                .foregroundColor(Color(hex: "#8B6F47"))
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(Color(hex: "#FCF2D9"))
        .cornerRadius(12)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color(hex: "#EEDCC6"), lineWidth: 1)
        )
    }
    
    private func findClosestDrink(amount: Int) -> Drink {
        var closest = Drink.drinkDatabase[0]
        var minDiff = abs(amount - closest.amount)
        
        for drink in Drink.drinkDatabase {
            let diff = abs(amount - drink.amount)
            if diff < minDiff {
                minDiff = diff
                closest = drink
            }
        }
        return closest
    }
}

//#Preview()
