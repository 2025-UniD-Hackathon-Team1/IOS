//
//  NewReportView.swift
//  CoffeePrincess
//
//  Created on 11/16/25.
//

import SwiftUI

struct NewReportView: View {
    @Environment(\.diContainer) private var di
    @StateObject private var viewModel = NewReportViewModel()
//    @Environment(\.dismiss) var dismiss
    
    var body: some View {
//        NavigationView {
//            ZStack {
                // 1. 배경색 (앱 테마에 맞게)
//                Color.screenBackground.ignoresSafeArea() // Custom Color
                
                // 2. 스크롤 가능한 콘텐츠 영역
//                ScrollView {
                    VStack(spacing: 24) {
                        
                        // 3. 헤더
                        HStack(spacing: 4) {
                            Button(action: { di.router.pop() }) {
                                Image(systemName: "chevron.left")
                                    .foregroundStyle(.black)
                            }
                            Spacer()
                            
                            // 인덱스 중앙
                            Text("나만의 맞춤형 리포트")
                                .font(.pretendard(.regular, size: 18))
                            
                            Spacer()
                            Button(action: { di.router.push(.newReportProfile)} ) {
                                Image(.profile)
                                    .foregroundStyle(Color.black)
                            }
                            
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)

                        // 4. 리포트 카드
                        if viewModel.isLoading {
                            ProgressView()
                                .padding(.top, 100)
                        } else {
                            // 카드 섹션
                            VStack(spacing: 16) {
                                ReportCardView(
                                    icon: "chart.bar.xaxis",
                                    title: "월간 리포트",
                                    content: viewModel.monthlyReportText
                                )
                                
                                ReportCardView(
                                    icon: "moon.zzz.fill",
                                    title: "수면 가이드",
                                    content: viewModel.sleepGuideText
                                )
                                
                                ReportCardView(
                                    icon: "sparkles",
                                    title: "각성 가이드",
                                    content: viewModel.awakeGuideText
                                )
                            }
                        }
                        
                        // 5. 캐릭터 이미지
                        Image(.kong2)
//                             .resizable()
                            .scaledToFit()
                            .frame(width: 150)
                            .padding(.top, 30)
                        
                        Spacer()
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 20)
//                }
            }
//            .navigationTitle("리포트")
//            .navigationBarTitleDisplayMode(.inline)
//            .toolbar {
//                ToolbarItem(placement: .navigationBarLeading) {
//                    Button(action: { dismiss() }) {
//                        Image(systemName: "chevron.left")
//                            .foregroundColor(.mainBrown)
//                    }
//                }
//            }
//        }
//    }
}

// MARK: - Helper View: Report Card

/// 리포트 항목을 표시하는 재사용 가능한 카드 뷰
struct ReportCardView: View {
    
    let icon: String
    let title: String
    let content: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // 1. 아이콘 + 타이틀
            HStack(spacing: 10) {
                Image(systemName: icon)
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(.mainBrown)
                    .frame(width: 24)
                
                Text(title)
                    .font(.pretendard(.bold, size: 16))
                    .foregroundColor(.mainBrown)
            }
            
            // 2. 내용
            Text(content)
                .font(.pretendard(.medium, size: 15))
                .foregroundColor(.secondaryBrown)
                .lineSpacing(5) // 줄 간격
                .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding(20)
        .background(Color.white) // 카드는 흰색 배경
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.05), radius: 10, x: 0, y: 5) // 은은한 그림자
    }
}

#Preview {
    NewReportView()
}
