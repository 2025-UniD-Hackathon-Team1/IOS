//
//  SleepView.swift
//  CoffeePrincess
//
//  Created by chohaeun on 11/16/25.
//

import SwiftUI

struct SleepView: View {
    
    @StateObject private var viewModel: SleepViewModel
    @Environment(\.diContainer) private var di
    
    init(viewModel: SleepViewModel = SleepViewModel()) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
            VStack {
                VStack(spacing: 16) {
                        sleepImpactSection
                        caffeineMetabolismSection
                    }
                    .padding(.horizontal, 16)
                
                Spacer(minLength: 60)

                    Button {
                        di.router.push(.survey)
                    } label: {
                        ZStack{
                            Image(.kongstand)
                                .resizable()
                                .scaledToFit()
                                .frame(height:140)
                                .offset(x:-100)
                            
                            Text("수면 패턴을 입력하세요")
                                .foregroundColor(.black)
                                .padding(10)
                                .background(Color.dividerCol)
                                .cornerRadius(10)
                                .offset(y:-65)
                            
                        }
                    }
                Spacer()
            }
            .background(Color(.cardBackground))
        }
    }

extension SleepView{
    
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
                                .foregroundColor(.secondaryBrown)
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

#Preview {
    SleepView()
}
