//
//  CurrentView.swift
//  CoffeePrincess
//
//  Created by chohaeun on 11/16/25.
//

import SwiftUI

struct CurrentView: View {
    
    @StateObject private var viewModel: CurrentViewModel
    @Environment(\.diContainer) private var di
    
    init(viewModel: CurrentViewModel = CurrentViewModel()) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
            VStack {
                    
                VStack(spacing: 16) {
                        caffeineStatusSection
                        currentStateSection
                        todayDrinksSection
                    }
                    .padding(.horizontal, 16)
                
                Spacer()
                
            }
            .background(Color(.cardBackground))
            .task {
                // ★★★ 뷰가 나타날 때 API 호출 ★★★
                viewModel.fetchTodayCoffee(container: di)
            }
    }
}


extension CurrentView {

    // MARK:  - 블록 1 & 2 - 카페인 지수 + 상태
    
    private var caffeineStatusSection: some View {
            // 본 섹션 박스
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
                        Text("각성도")
                            .font(.caption)
                            .foregroundColor(.secondaryBrown)
                        Spacer()
                        Text("\(Int(viewModel.currentAlertnessPercent))%")
                            .font(.caption)
                            .foregroundColor(.secondaryBrown)
                    }
                    
                    ZStack(alignment: .leading) {
                        RoundedRectangle(cornerRadius: 16)
                            .fill(Color(.sectionBackground))
                        
                        GeometryReader { proxy in
                            let width = proxy.size.width * CGFloat(viewModel.currentAlertnessPercent / 100.0)
                            
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
//                statBox(title: "카페인 농도", value: "\(Int(viewModel.caffeinePercent))%")
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
    
    // 블록 5 - 오늘 마신 커피 리스트
    private var todayDrinksSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("오늘 마신 음료")
                .font(.headline)
                .foregroundColor(.fontBrown)
            
            // ★★★ (수정) 로딩 및 빈 상태 처리 ★★★
            if viewModel.isLoadingTodayDrinks {
                HStack {
                    Spacer()
                    ProgressView() // 로딩 중 스피너 표시
                    Spacer()
                }
                .frame(height: 60)
                
            } else if viewModel.todayDrinks.isEmpty {
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
            di.router.push(.addRecord)
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
}

#Preview {
    CurrentView()
}
