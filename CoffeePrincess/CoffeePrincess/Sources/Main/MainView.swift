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
                        
                        caffeineMetabolismSection
                        scheduleRecommendationSection
                        todayScheduleSection
                        //tonightSleepPredictionSection
                        
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
        HStack(alignment: .center) {
            VStack(alignment: .leading, spacing: 6) {
                Text("오늘의 카페인")
                    .font(.system(size: 24, weight: .bold))
                    .foregroundColor(.fontBrown)
                
                HStack(spacing: 6) {
                    Image(systemName: "calendar")
                        .font(.caption)
                        .foregroundColor(.secondaryBrown)
                    Text(viewModel.todayString)
                        .font(.footnote)
                        .foregroundColor(.secondaryBrown)
                }
            }
            
            Spacer()
            
            HStack(spacing: 10) {
                Button {
                    // 검색 페이지로 이동 액션 연결 예정
                } label: {
                    RoundedRectangle(cornerRadius: 14)
                        .fill(Color(.white))
                        .shadow(color: Color.black.opacity(0.05), radius: 6, x: 0, y: 2)
                        .frame(width: 40, height: 40)
                        .overlay(
                            Image(systemName: "magnifyingglass")
                                .font(.system(size: 18, weight: .semibold))
                                .foregroundColor(.mainBrown)
                        )
                }
                
                Button {
                    // 프로필 화면으로 이동 액션 연결 예정
                } label: {
                    Image(systemName: "person.crop.circle.fill")
                        .font(.system(size: 34))
                        .foregroundColor(.mainBrown)
                }
            }
        }
    }


// MARK:  - 블록 1 & 2 - 카페인 지수 + 상태

    private var caffeineStatusSection: some View {
        VStack(alignment: .leading, spacing: 18) {
            
            // 상단 상태 요약
            HStack(alignment: .center, spacing: 20) {
                HStack(spacing: 8) {
                    Text(viewModel.statusIcon)
                        .font(.system(size: 30))
                    VStack(alignment: .leading, spacing: 2) {
                        Text(viewModel.statusText)
                            .font(.title3)
                            .fontWeight(.bold)
                            .foregroundColor(.fontBrown)
                        Text("지금 컨디션을 기준으로 계산했어요")
                            .font(.caption)
                            .foregroundColor(.secondaryBrown)
                    }
                }
                
                Spacer()
                
                VStack(alignment: .trailing, spacing: 6) {
                    VStack(alignment: .trailing, spacing: 2) {
                        Text("현재 카페인")
                            .font(.caption)
                            .foregroundColor(.secondaryBrown)
                        Text("\(Int(viewModel.currentCaffeine))mg")
                            .font(.headline)
                            .fontWeight(.bold)
                            .foregroundColor(.fontBrown)
                    }
                    
                    VStack(alignment: .trailing, spacing: 2) {
                        Text("마지막 섭취")
                            .font(.caption)
                            .foregroundColor(.secondaryBrown)
                        Text(viewModel.lastIntakeText)
                            .font(.subheadline)
                            .foregroundColor(.fontBrown)
                    }
                }
            }
            
            // 가로 카페인 게이지
            VStack(alignment: .leading, spacing: 6) {
                HStack {
                    Text("카페인 지수")
                        .font(.caption)
                        .foregroundColor(.secondaryBrown)
                    Spacer()
                    Text("\(Int(viewModel.caffeinePercent))%")
                        .font(.caption)
                        .foregroundColor(.secondaryBrown)
                }
                
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
                            .frame(width: max(0, width))
                            .padding(4)
                    }
                    .clipShape(RoundedRectangle(cornerRadius: 16))
                }
                .frame(height: 26)
            }
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 18)
                .fill(Color(.systemBackground))
                .shadow(color: Color.black.opacity(0.05), radius: 12, x: 0, y: 4)
        )
    }

// MARK: - 블록 3 - 현재 상태 (카페인 %, 에너지, 각성 종료 예상 시간)
    
    private var currentStateSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("현재 상태")
                    .font(.headline)
                    .foregroundColor(.fontBrown)
                Spacer()
            }
            
            HStack(spacing: 12) {
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
    


    
    // 블록 5 - 오늘 마신 커피 리스트
    private var todayDrinksSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("오늘 마신 음료")
                .font(.headline)
                .foregroundColor(.fontBrown)
            
            if viewModel.todayDrinks.isEmpty {
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color(.systemGray6))
                    .frame(height: 60)
                    .overlay(
                        HStack(spacing: 6) {
                            Image(systemName: "cup.and.saucer")
                                .foregroundColor(.secondary)
                            Text("아직 마신 커피가 없습니다")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                    )
            } else {
                VStack(spacing: 8) {
                    ForEach(viewModel.todayDrinks) { drink in
                        HStack(spacing: 12) {
                            Text(drink.icon)
                                .font(.title3)
                                .frame(width: 32, height: 32)
                            
                            VStack(alignment: .leading, spacing: 2) {
                                Text(drink.name)
                                    .font(.subheadline)
                                    .foregroundColor(.fontBrown)
                                Text("\(drink.amountMg)mg · \(drink.timeText)")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                            
                            Spacer()
                        }
                        .padding(.vertical, 6)
                        
                        Divider()
                            .padding(.leading, 44)
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
            .background(.mainBrown)
            .foregroundColor(.white)
            .clipShape(Capsule())
            .shadow(color:.mainBrown.opacity(0.4), radius: 8, x: 0, y: 2)
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
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Text("카페인 대사")
                    .font(.headline)
                    .foregroundColor(.fontBrown)
                Spacer()
                Text("현재 \(viewModel.metabolismCurrentMg)mg")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Text("\(viewModel.metabolismUntilText)까지 영향을 줄 수 있어요")
                .font(.caption)
                .foregroundColor(.secondary)
            
            ZStack {
                RoundedRectangle(cornerRadius: 22)
                    .fill(Color(.systemBackground))
                    .shadow(color: Color.black.opacity(0.04), radius: 10, x: 0, y: 4)
                
                VStack(spacing: 12) {
                    GeometryReader { proxy in
                        let maxValue = max(viewModel.metabolismBars.map { $0.amount }.max() ?? 1, 1)
                        let width = proxy.size.width
                        let height = proxy.size.height
                        
                        ZStack {
                            // 그리드
                            ForEach(0..<4) { i in
                                let y = height * CGFloat(Double(i) / 3.0)
                                Path { path in
                                    path.move(to: CGPoint(x: 0, y: y))
                                    path.addLine(to: CGPoint(x: width, y: y))
                                }
                                .stroke(Color(.systemGray5), lineWidth: 0.6)
                            }
                            
                            // 수면 기준선
                            Path { path in
                                let y = height * 0.55
                                path.move(to: CGPoint(x: 0, y: y))
                                path.addLine(to: CGPoint(x: width, y: y))
                            }
                            .stroke(
                                Color.purple.opacity(0.6),
                                style: StrokeStyle(lineWidth: 1, dash: [4, 4])
                            )
                            
                            let sleepIndex = 8
                            let spacing: CGFloat = 6
                            let barWidth = (width - spacing * CGFloat(viewModel.metabolismBars.count - 1)) / CGFloat(viewModel.metabolismBars.count)
                            let xSleep = CGFloat(sleepIndex) * (barWidth + spacing) + barWidth / 2
                            
                            // 수면 시간 세로 라인
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
                                                : Color.brown.opacity(0.3)
                                            )
                                            .frame(width: barWidth, height: barHeight)
                                        
                                        Text(bar.timeLabel)
                                            .font(.caption2)
                                            .foregroundColor(.secondary)
                                    }
                                }
                            }
                            .frame(maxHeight: .infinity, alignment: .bottom)
                            
                            // Now 뱃지
                            if let nowIndex = viewModel.metabolismBars.firstIndex(where: { $0.isNow }) {
                                let spacing: CGFloat = 6
                                let barWidth = (width - spacing * CGFloat(viewModel.metabolismBars.count - 1)) / CGFloat(viewModel.metabolismBars.count)
                                let xNow = CGFloat(nowIndex) * (barWidth + spacing) + barWidth / 2
                                
                                VStack(spacing: 2) {
                                    Text("Now")
                                        .font(.caption2)
                                        .padding(.horizontal, 8)
                                        .padding(.vertical, 3)
                                        .background(
                                            Capsule()
                                                .fill(Color(red: 1.0, green: 0.83, blue: 0.68))
                                        )
                                        .foregroundColor(.brown)
                                    Spacer()
                                }
                                .frame(width: width, height: height, alignment: .topLeading)
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
                                            .fill(Color.purple.opacity(0.1))
                                    )
                                }
                                Spacer()
                            }
                            .padding(.trailing, 8)
                        }
                    }
                    .frame(height: 170)
                    
                    HStack {
                        Text("지금부터 취침 전까지의 카페인 감소량을 예측해요")
                            .font(.caption2)
                            .foregroundColor(.secondary)
                        Spacer()
                    }
                    .padding(.horizontal, 4)
                }
                .padding(14)
            }
            .frame(maxWidth: .infinity)
        }
        .padding(.top, 4)
    }
}


extension MainView {
    private var scheduleRecommendationSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("오늘의 일정 기반 추천")
                .font(.headline)
                .foregroundColor(.fontBrown)
            
            VStack(alignment: .leading, spacing: 8) {
                HStack(alignment: .center, spacing: 8) {
                    Image(systemName: "clock.badge.exclamationmark")
                        .font(.subheadline)
                        .foregroundColor(.mainBrown)
                    
                    Text(viewModel.scheduleTimeText)
                        .font(.subheadline)
                        .fontWeight(.semibold)
                    
                    Text("· \(viewModel.scheduleTitle)")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    
                    Spacer()
                }
                
                Text("최상의 각성 상태를 위해, 아래 시간에 한 잔 어떠세요?")
                    .font(.footnote)
                    .foregroundColor(.secondary)
                
                HStack(spacing: 6) {
                    Image(systemName: "cup.and.saucer.fill")
                        .font(.caption)
                    Text("\(viewModel.recommendIntakeTimeText)에 커피를 드시는 것을 추천합니다.")
                        .font(.subheadline)
                        .fontWeight(.semibold)
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

extension MainView {
    private var todayScheduleSection: some View {
        
        let schedules = di.scheduleService.todaySchedules
        
        return VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("오늘의 일정")
                    .font(.headline)
                    .foregroundColor(.fontBrown)
                Spacer()
                Button {
                    di.router.push(.scheduleInput)
                } label: {
                    HStack(spacing: 4) {
                        Image(systemName: "plus.circle.fill")
                            .font(.subheadline)
                        Text("추가")
                            .font(.caption)
                    }
                    .padding(.horizontal, 8)
                    .padding(.vertical, 6)
                    .background(
                        Capsule()
                            .fill(Color(.systemGray6))
                    )
                }
                .buttonStyle(.plain)
            }
            
            if schedules.isEmpty {
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color(.systemGray6))
                    .frame(height: 60)
                    .overlay(
                        HStack(spacing: 6) {
                            Image(systemName: "calendar.badge.plus")
                                .foregroundColor(.secondary)
                            Text("등록된 일정이 없습니다")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                    )
            } else {
                VStack(spacing: 10) {
                    ForEach(schedules) { schedule in
                        HStack(alignment: .top, spacing: 10) {
                            // 왼쪽 타임라인 동그라미
                            VStack {
                                Circle()
                                    .fill(Color.mainBrown)
                                    .frame(width: 8, height: 8)
                                Rectangle()
                                    .fill(Color(.systemGray4))
                                    .frame(width: 2)
                                    .opacity(schedule.id == schedules.last?.id ? 0 : 1)
                            }
                            
                            VStack(alignment: .leading, spacing: 4) {
                                Text(schedule.time)
                                    .font(.caption)
                                    .foregroundColor(.secondaryBrown)
                                Text(schedule.title)
                                    .font(.subheadline)
                                    .fontWeight(.semibold)
                                    .foregroundColor(.fontBrown)
                            }
                            
                            Spacer()
                        }
                    }
                }
                .padding(.top, 4)
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


