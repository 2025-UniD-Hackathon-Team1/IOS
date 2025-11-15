//
//  CaffeineTrackerView.swift
//  CoffeePrincess
//

import SwiftUI

// MARK: - 메인 뷰

struct MainView: View {
    
    @StateObject private var viewModel: MainViewModel
    @State private var selectedPeriod: CaffeinePeriod = .week
    @Environment(\.diContainer) private var di
    @EnvironmentObject private var scheduleService: ScheduleService
    
    init(viewModel: MainViewModel = MainViewModel()) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                ScrollView {
                    VStack(spacing: 16) {
                        headerSection
                        caffeineStatusSection
                        currentStateSection
                        sleepImpactSection
                        
                        // ── NEW: 여기부터 새 섹션들 ──
                        caffeineMetabolismSection
                        scheduleRecommendationSection
                        todayScheduleSection
                        tonightSleepPredictionSection
                        // ── NEW 끝 ──
                        
                        periodChartSection
                        todayDrinksSection
                        
                        Spacer(minLength: 40)
                    }
                    .padding(.horizontal, 16)
                    .padding(.top, 12)
                }
                
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
            .background(Color(.cardBackground))
            .navigationBarHidden(true)
        }
    }
}

// MARK: - 섹션들

extension MainView {
    
    // 상단 헤더 (오늘 날짜, 검색, 프로필)
    private var headerSection: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text("오늘의 카페인")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.fontBrown)
                Text(viewModel.todayString)
                    .font(.subheadline)
                    .foregroundColor(.secondaryBrown)
            }
            
            Spacer()
            
            Button {
                // 검색 페이지로 이동 액션 연결 예정
            } label: {
                Image(systemName: "magnifyingglass")
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(.mainBrown)
                    .padding(10)
                    .background(Color(.white))
                    .clipShape(Circle())
            }
            
            Button {
                // 프로필 화면으로 이동 액션 연결 예정
            } label: {
                Image(systemName: "person.crop.circle")
                    .font(.system(size: 28))
                    .foregroundColor(.mainBrown)
            }
            .padding(.leading, 4)
        }
    }
    
    // 블록 1 & 2 - 카페인 지수 + 상태
    private var caffeineStatusSection: some View {
        VStack(alignment: .center, spacing: 16) {

            // 상태 텍스트들
            HStack(alignment: .center) {
                
                HStack(spacing: 6) {
                    Text(viewModel.statusIcon)
                        .font(.system(size: 28))
                    Text(viewModel.statusText)
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.fontBrown)
                }
                Spacer()
                
                VStack(alignment: .leading, spacing: 4) {
                    Text("현재 카페인")
                        .font(.subheadline)
                        .foregroundColor(.secondaryBrown)
                    Text("\(Int(viewModel.currentCaffeine))mg")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.fontBrown)
                }
                
                Spacer()
                
                VStack(alignment: .leading, spacing: 2) {
                    Text("마지막 섭취")
                        .font(.subheadline)
                        .foregroundColor(.secondaryBrown)
                    Text(viewModel.lastIntakeText)
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.fontBrown)
                }
                
                Spacer()
            }
            
            // 가로 카페인 게이지
            ZStack(alignment: .leading) {
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color(.sectionBackground))

                GeometryReader { proxy in
                    let width = proxy.size.width * CGFloat(viewModel.caffeinePercent / 100.0)

                    RoundedRectangle(cornerRadius: 12)
                        .fill(
                            LinearGradient(
                                gradient: Gradient(colors: [
                                    Color(.secondaryBrown),
                                    Color(.dividerCol)
                                ]),
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .frame(width: width)
                        .padding(4)
                }
                .clipShape(RoundedRectangle(cornerRadius: 16))
            }
            .frame(width: 340, height: 28)
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
                statBox(title: "카페인 농도", value: "\(Int(viewModel.caffeinePercent))%")
                statBox(title: "에너지 레벨", value: "\(Int(viewModel.energyPercent))%")
                statBox(title: "각성 종료", value: viewModel.awakeEndText)
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
                    Text(viewModel.usualBedtimeText)
                        .font(.subheadline)
                        .fontWeight(.medium)
                }
                
                Spacer()
                
                VStack(alignment: .leading, spacing: 4) {
                    Text("마지막 섭취 시각")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    Text(viewModel.lastIntakeTimeText)
                        .font(.subheadline)
                        .fontWeight(.medium)
                }
                
                Spacer()
                
                VStack(alignment: .leading, spacing: 4) {
                    Text("수면 방해 확률")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    HStack(spacing: 4) {
                        Text("\(viewModel.sleepDisruptionPercent)%")
                            .font(.subheadline)
                            .fontWeight(.bold)
                        ProgressView(value: Double(viewModel.sleepDisruptionPercent), total: 100)
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
            
            if viewModel.todayDrinks.isEmpty {
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
                    ForEach(viewModel.todayDrinks) { drink in
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
                .foregroundColor(.mainBrown)
            Text(value)
                .font(.subheadline)
                .fontWeight(.semibold)
                .foregroundColor(.fontBrown)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(10)
        .background(Color(.dividerCol))
        .cornerRadius(12)
    }
}

// MARK: - 메타볼리즘 / 추천 / 수면 예측 섹션

extension MainView {
    private var caffeineMetabolismSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("카페인 대사")
                .font(.headline)
            
            Text("현재 \(viewModel.metabolismCurrentMg)mg ·\(viewModel.metabolismUntilText)까지")
                .font(.subheadline)
                .foregroundColor(.secondary)
            
            ZStack {
                RoundedRectangle(cornerRadius: 22)
                    .fill(Color(.systemBackground))
                    .shadow(color: Color.black.opacity(0.05), radius: 12, x: 0, y: 4)
                
                VStack(spacing: 12) {
                    // 그래프 영역
                    GeometryReader { proxy in
                        let maxValue = max(viewModel.metabolismBars.map { $0.amount }.max() ?? 1, 1)
                        let width = proxy.size.width
                        let height = proxy.size.height
                        
                        ZStack {
                            // 수평 그리드 라인 3개 정도
                            ForEach(0..<4) { i in
                                let y = height * CGFloat(Double(i) / 3.0)
                                Path { path in
                                    path.move(to: CGPoint(x: 0, y: y))
                                    path.addLine(to: CGPoint(x: width, y: y))
                                }
                                .stroke(Color(.systemGray5), lineWidth: 0.7)
                            }
                            
                            // 수면 기준선 (가로 점선 100mg 근처)
                            Path { path in
                                let y = height * 0.55
                                path.move(to: CGPoint(x: 0, y: y))
                                path.addLine(to: CGPoint(x: width, y: y))
                            }
                            .stroke(
                                Color.purple.opacity(0.6),
                                style: StrokeStyle(lineWidth: 1, dash: [4, 4])
                            )
                            
                            // 세로 수면 시간 라인
                            let sleepIndex = 8 // 대충 가운데쯤
                            let spacing: CGFloat = 6
                            let barWidth = (width - spacing * CGFloat(viewModel.metabolismBars.count - 1)) / CGFloat(viewModel.metabolismBars.count)
                            let xSleep = CGFloat(sleepIndex) * (barWidth + spacing) + barWidth / 2
                            
                            Path { path in
                                path.move(to: CGPoint(x: xSleep, y: 0))
                                path.addLine(to: CGPoint(x: xSleep, y: height))
                            }
                            .stroke(Color.purple.opacity(0.8), lineWidth: 1)
                            
                            // 막대들
                            HStack(alignment: .bottom, spacing: spacing) {
                                ForEach(viewModel.metabolismBars) { bar in
                                    VStack(spacing: 4) {
                                        let barHeight = max(6, height * CGFloat(bar.amount / maxValue) * 0.85)
                                        
                                        RoundedRectangle(cornerRadius: 4)
                                            .fill(
                                                bar.isPast
                                                ? Color.brown.opacity(bar.isNow ? 0.9 : 0.75)
                                                : Color.brown.opacity(0.35)
                                            )
                                            .frame(width: barWidth, height: barHeight)
                                        
                                        Text(bar.timeLabel)
                                            .font(.caption2)
                                            .foregroundColor(.secondary)
                                    }
                                }
                            }
                            .frame(maxHeight: .infinity, alignment: .bottom)
                            
                            // "Now" 뱃지
                            if let nowIndex = viewModel.metabolismBars.firstIndex(where: { $0.isNow }) {
                                let xNow = CGFloat(nowIndex) * (barWidth + spacing) + barWidth / 2
                                VStack(spacing: 2) {
                                    Text("Now")
                                        .font(.caption2)
                                        .padding(.horizontal, 8)
                                        .padding(.vertical, 2)
                                        .background(
                                            Capsule()
                                                .fill(Color(red: 1.0, green: 0.83, blue: 0.68))
                                        )
                                        .foregroundColor(.brown)
                                    Spacer()
                                }
                                .frame(width: width, height: height, alignment: .bottomLeading)
                                .offset(x: xNow - width / 2, y: 4)
                            }
                            
                            // 수면 라벨
                            VStack {
                                HStack {
                                    Spacer()
                                    VStack(spacing: 2) {
                                        Text(viewModel.metabolismSleepTimeText)
                                            .font(.caption2)
                                            .foregroundColor(.purple)
                                        Text("Sleep")
                                            .font(.caption2)
                                            .foregroundColor(.purple)
                                    }
                                    .padding(.horizontal, 6)
                                    .padding(.vertical, 4)
                                    .background(
                                        RoundedRectangle(cornerRadius: 10)
                                            .fill(Color.purple.opacity(0.12))
                                    )
                                }
                                Spacer()
                            }
                            .padding(.trailing, 8)
                        }
                    }
                    .frame(height: 170)
                    
                    // x축 날짜 텍스트 (단순 더미)
                    HStack {
                        Text("Sep12")
                            .font(.caption2)
                            .foregroundColor(.secondary)
                        Spacer()
                        Text("Sep13")
                            .font(.caption2)
                            .foregroundColor(.secondary)
                    }
                    .padding(.horizontal, 8)
                    .padding(.bottom, 4)
                }
                .padding(14)
            }
            .frame(maxWidth: .infinity)
        }
        .padding(0) // 이미 카드 안쪽에서 padding 있음
    }
}

extension MainView {
    private var scheduleRecommendationSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("오늘의 일정 기반 추천")
                .font(.headline)
            
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Text(viewModel.scheduleTimeText)
                        .font(.subheadline)
                        .fontWeight(.semibold)
                    Text(" - \(viewModel.scheduleTitle)")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    Spacer()
                }
                
                Text("최상의 각성 상태를 위해")
                    .font(.footnote)
                    .foregroundColor(.secondary)
                
                Text("\(viewModel.recommendIntakeTimeText)에 커피를 드시는 것을 추천합니다.")
                    .font(.subheadline)
                    .fontWeight(.semibold)
            }
            .padding(14)
            .background(
                RoundedRectangle(cornerRadius: 18)
                    .fill(Color(.systemGray6))
            )
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 22)
                .fill(Color(.systemBackground))
                .shadow(color: Color.black.opacity(0.05), radius: 12, x: 0, y: 4)
        )
    }
}

extension MainView {
    private var tonightSleepPredictionSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("오늘 밤 수면 예측")
                .font(.headline)
            
            VStack(alignment: .leading, spacing: 8) {
                Text("오늘 섭취한 카페인 때문에")
                    .font(.footnote)
                    .foregroundColor(.secondary)
                
                HStack(spacing: 4) {
                    Text("수면 방해 확률이")
                        .font(.subheadline)
                    Text("\(viewModel.tonightDisruptionPercent)%입니다.")
                        .font(.subheadline)
                        .fontWeight(.bold)
                }
                
                Divider()
                    .padding(.vertical, 6)
                
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("마지막 카페인 섭취 시각:")
                            .font(.caption)
                            .foregroundColor(.secondary)
                        Text(viewModel.tonightLastIntakeTimeText)
                            .font(.subheadline)
                    }
                    
                    Spacer()
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text("평소 취침 시간:")
                            .font(.caption)
                            .foregroundColor(.secondary)
                        Text(viewModel.tonightUsualBedtimeText)
                            .font(.subheadline)
                            .fontWeight(.semibold)
                    }
                }
            }
            .padding(14)
            .background(
                RoundedRectangle(cornerRadius: 18)
                    .fill(Color(.systemGray6))
            )
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 22)
                .fill(Color(.systemBackground))
                .shadow(color: Color.black.opacity(0.05), radius: 12, x: 0, y: 4)
        )
    }
}

// MARK: - 프리뷰

struct CaffeineTrackerView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            MainView()
                .preferredColorScheme(.light)
            
            MainView()
                .preferredColorScheme(.dark)
        }
    }
}

extension MainView {
    private var todayScheduleSection: some View {
        
        let schedules = di.scheduleService.todaySchedules
        
        return VStack(alignment: .leading, spacing: 10) {
            HStack {
                Text("오늘의 일정")
                    .font(.headline)
                Spacer()
                Button {
                    di.router.push(.scheduleInput)
                } label: {
                    Image(systemName: "plus.circle.fill")
                        .font(.title3)
                }
                .buttonStyle(.plain)
            }
            
            if schedules.isEmpty {
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color(.systemGray6))
                    .frame(height: 60)
                    .overlay(
                        Text("등록된 일정이 없습니다")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    )
            } else {
                VStack(alignment: .leading, spacing: 8) {
                    ForEach(schedules) { schedule in
                        HStack {
                            VStack(alignment: .leading, spacing: 4) {
                                Text(schedule.title)
                                    .font(.subheadline)
                                    .fontWeight(.semibold)
                                Text(schedule.time)
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                            Spacer()
                        }
                        Divider()
                    }
                }
                .padding(.vertical, 4)
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
