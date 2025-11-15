
//
//  MainView.swift
//  CoffeePrincess
//
//  Created by chohaeun on 11/15/25.
//

import SwiftUI

// MARK: - 모델 (View 전용 더미 모델)

struct Drink: Identifiable {
    let id = UUID()
    let icon: String
    let name: String
    let amountMg: Int
    let timeText: String
}

enum CaffeinePeriod: String, CaseIterable {
    case week = "주간"
    case month = "월간"
}

// MARK: - 메인 뷰

struct CaffeineTrackerView: View {
    // 더미 상태값들 (실제 로직/모델 붙이면 여기에 연결)
    @State private var currentCaffeine: Double = 185.0
    @State private var caffeinePercent: Double = 46.0
    @State private var energyPercent: Double = 78.0
    @State private var statusIcon: String = "😌"
    @State private var statusText: String = "보통"
    @State private var lastIntakeText: String = "1시간 20분 전"
    @State private var awakeEndText: String = "오후 11:10"
    
    @State private var usualBedtimeText: String = "오후 11:30"
    @State private var lastIntakeTimeText: String = "오후 9:50"
    @State private var sleepDisruptionPercent: Int = 37
    
    @State private var selectedPeriod: CaffeinePeriod = .week
    
    @State private var todayDrinks: [Drink] = [
        Drink(icon: "☕️", name: "아메리카노", amountMg: 95, timeText: "오전 9:10"),
        Drink(icon: "☕️", name: "카페라떼", amountMg: 150, timeText: "오후 2:20"),
        Drink(icon: "🥤", name: "콜라", amountMg: 80, timeText: "오후 7:45")
    ]
    
    var body: some View {
        NavigationView {
            ZStack {
                ScrollView {
                    VStack(spacing: 16) {
                        headerSection
                        caffeineStatusSection
                        currentStateSection
                        sleepImpactSection
                        periodChartSection
                        todayDrinksSection
                        
                        Spacer(minLength: 40)
                    }
                    .padding(.horizontal, 16)
                    .padding(.top, 12)
                }
                
                // 오른쪽 아래 플로팅 버튼 (카페인 추가)
                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        addCaffeineButton
                    }
                    .padding(.trailing, 24)
                    .padding(.bottom, 24)
                }
            }
            .navigationBarHidden(true)
        }
    }
}

// MARK: - 섹션들

extension CaffeineTrackerView {
    
    // 상단 헤더 (오늘 날짜, 검색, 프로필)
    private var headerSection: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text("오늘의 카페인")
                    .font(.title2)
                    .fontWeight(.bold)
                Text(formattedToday)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            Button {
                // 검색 페이지로 이동 액션 연결 예정
            } label: {
                Image(systemName: "magnifyingglass")
                    .font(.system(size: 18, weight: .semibold))
                    .padding(10)
                    .background(Color(.systemGray6))
                    .clipShape(Circle())
            }
            
            Button {
                // 프로필 화면으로 이동 액션 연결 예정
            } label: {
                Image(systemName: "person.crop.circle")
                    .font(.system(size: 28))
                    .foregroundColor(.accentColor)
            }
            .padding(.leading, 4)
        }
    }
    
    // 블록 1 & 2 - 카페인 지수 + 상태
    private var caffeineStatusSection: some View {
        HStack(spacing: 16) {
            // 세로 카페인 게이지
            ZStack(alignment: .bottom) {
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color(.systemGray6))
                
                GeometryReader { proxy in
                    let height = proxy.size.height * CGFloat(caffeinePercent / 100.0)
                    
                    RoundedRectangle(cornerRadius: 12)
                        .fill(LinearGradient(
                            gradient: Gradient(colors: [
                                Color(red: 0.99, green: 0.42, blue: 0.42),
                                Color(red: 1.0, green: 0.78, blue: 0.40)
                            ]),
                            startPoint: .bottom,
                            endPoint: .top
                        ))
                        .frame(height: height)
                        .padding(4)
                }
                .clipShape(RoundedRectangle(cornerRadius: 16))
            }
            .frame(width: 60, height: 160)
            
            // 상태 텍스트들
            VStack(alignment: .leading, spacing: 12) {
                HStack(spacing: 6) {
                    Text(statusIcon)
                        .font(.system(size: 28))
                    Text(statusText)
                        .font(.headline)
                    Spacer()
                }
                
                VStack(alignment: .leading, spacing: 4) {
                    Text("현재 카페인")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    Text("\(Int(currentCaffeine))mg")
                        .font(.title2)
                        .fontWeight(.bold)
                }
                
                VStack(alignment: .leading, spacing: 2) {
                    Text("마지막 섭취")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    Text(lastIntakeText)
                        .font(.subheadline)
                }
                
                Spacer()
            }
            
            Spacer()
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 18)
                .fill(Color(.systemBackground))
                .shadow(color: Color.black.opacity(0.05), radius: 12, x: 0, y: 4)
        )
    }
    
    // 블록 3 - 현재 상태 (카페인 %, 에너지, 각성 종료 예상 시간)
    private var currentStateSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("현재 상태")
                .font(.headline)
            
            HStack(spacing: 16) {
                statBox(title: "카페인 농도", value: "\(Int(caffeinePercent))%")
                statBox(title: "에너지 레벨", value: "\(Int(energyPercent))%")
                statBox(title: "각성 종료", value: awakeEndText)
            }
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 18)
                .fill(Color(.systemBackground))
                .shadow(color: Color.black.opacity(0.05), radius: 12, x: 0, y: 4)
        )
    }
    
    // 블록 4 - 수면 영향
    private var sleepImpactSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("수면 영향")
                .font(.headline)
            
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text("평소 취침 시간")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    Text(usualBedtimeText)
                        .font(.subheadline)
                        .fontWeight(.medium)
                }
                
                Spacer()
                
                VStack(alignment: .leading, spacing: 4) {
                    Text("마지막 섭취 시각")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    Text(lastIntakeTimeText)
                        .font(.subheadline)
                        .fontWeight(.medium)
                }
                
                Spacer()
                
                VStack(alignment: .leading, spacing: 4) {
                    Text("수면 방해 확률")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    HStack(spacing: 4) {
                        Text("\(sleepDisruptionPercent)%")
                            .font(.subheadline)
                            .fontWeight(.bold)
                        ProgressView(value: Double(sleepDisruptionPercent), total: 100)
                            .frame(width: 60)
                    }
                }
            }
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 18)
                .fill(Color(.systemBackground))
                .shadow(color: Color.black.opacity(0.05), radius: 12, x: 0, y: 4)
        )
    }
    
    // 블록 2/차트 부분 - 주간 / 월간 토글 + 그래프
    private var periodChartSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text(selectedPeriod == .week ? "최근 7일 섭취량" : "최근 30일 섭취량")
                    .font(.headline)
                
                Spacer()
                
                Picker("", selection: $selectedPeriod) {
                    ForEach(CaffeinePeriod.allCases, id: \.self) { period in
                        Text(period.rawValue)
                            .tag(period)
                    }
                }
                .pickerStyle(.segmented)
                .frame(width: 140)
            }
            
            if selectedPeriod == .week {
                weeklyChartPlaceholder
            } else {
                monthlyCalendarPlaceholder
            }
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 18)
                .fill(Color(.systemBackground))
                .shadow(color: Color.black.opacity(0.05), radius: 12, x: 0, y: 4)
        )
    }
    
    private var weeklyChartPlaceholder: some View {
        // 단순한 막대 그래프 형태의 뷰 (더미 데이터)
        let dummy = [0, 120, 60, 180, 240, 90, 0]
        let dayNames = ["일", "월", "화", "수", "목", "금", "토"]
        let maxValue = max(dummy.max() ?? 1, 1)
        
        return GeometryReader { proxy in
            HStack(alignment: .bottom, spacing: 8) {
                ForEach(0..<dummy.count, id: \.self) { index in
                    VStack {
                        Text(dummy[index] == 0 ? "" : "\(dummy[index])")
                            .font(.caption2)
                            .foregroundColor(.secondary)
                        
                        RoundedRectangle(cornerRadius: 8)
                            .frame(
                                width: (proxy.size.width - 8 * CGFloat(dummy.count - 1)) / CGFloat(dummy.count),
                                height: max(4, proxy.size.height * CGFloat(dummy[index]) / CGFloat(maxValue))
                            )
                            .foregroundColor(Color.accentColor.opacity(0.8))
                        
                        Text(dayNames[index])
                            .font(.caption2)
                            .foregroundColor(.secondary)
                    }
                }
            }
        }
        .frame(height: 140)
    }
    
    private var monthlyCalendarPlaceholder: some View {
        // 단순 박스 달력 모양 (실제 데이터 X)
        VStack(spacing: 8) {
            HStack {
                ForEach(["일","월","화","수","목","금","토"], id: \.self) { day in
                    Text(day)
                        .font(.caption2)
                        .foregroundColor(.secondary)
                        .frame(maxWidth: .infinity)
                }
            }
            
            ForEach(0..<5, id: \.self) { _ in
                HStack(spacing: 4) {
                    ForEach(0..<7, id: \.self) { _ in
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color(.systemGray4), lineWidth: 1)
                            .frame(height: 34)
                            .overlay(
                                Text(" ")
                            )
                    }
                }
            }
        }
        .frame(maxWidth: .infinity)
    }
    
    // 블록 5 - 오늘 마신 커피 리스트
    private var todayDrinksSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("오늘 마신 음료")
                .font(.headline)
            
            if todayDrinks.isEmpty {
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color(.systemGray6))
                    .frame(height: 60)
                    .overlay(
                        Text("아직 마신 커피가 없습니다")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    )
            } else {
                VStack(spacing: 8) {
                    ForEach(todayDrinks) { drink in
                        HStack {
                            Text(drink.icon)
                                .font(.title3)
                                .frame(width: 32, alignment: .center)
                            
                            VStack(alignment: .leading, spacing: 2) {
                                Text(drink.name)
                                    .font(.subheadline)
                                Text("\(drink.amountMg)mg · \(drink.timeText)")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                            
                            Spacer()
                        }
                        .padding(.vertical, 6)
                        
                        Divider()
                            .padding(.leading, 40)
                    }
                }
            }
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 18)
                .fill(Color(.systemBackground))
                .shadow(color: Color.black.opacity(0.05), radius: 12, x: 0, y: 4)
        )
    }
    
    // 플로팅 + 버튼
    private var addCaffeineButton: some View {
        Button {
            // "카페인 추가" 서브 화면/모달로 이동 액션 연결 예정
        } label: {
            HStack(spacing: 8) {
                Image(systemName: "plus")
                    .font(.system(size: 18, weight: .bold))
                Text("카페인 추가")
                    .font(.subheadline)
                    .fontWeight(.semibold)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .background(Color.accentColor)
            .foregroundColor(.white)
            .clipShape(Capsule())
            .shadow(color: Color.accentColor.opacity(0.4), radius: 8, x: 0, y: 4)
        }
    }
    
    // 공통 작은 스탯 박스
    private func statBox(title: String, value: String) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(title)
                .font(.caption)
                .foregroundColor(.secondary)
            Text(value)
                .font(.subheadline)
                .fontWeight(.semibold)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(10)
        .background(Color(.systemGray6))
        .cornerRadius(12)
    }
    
    // 오늘 날짜 텍스트
    private var formattedToday: String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.dateFormat = "yyyy.MM.dd (E)"
        return formatter.string(from: Date())
    }
}

// MARK: - 프리뷰

struct CaffeineTrackerView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            CaffeineTrackerView()
                .preferredColorScheme(.light)
            
            CaffeineTrackerView()
                .preferredColorScheme(.dark)
        }
    }
}
