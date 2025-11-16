//
//  HeaderSection.swift
//  CoffeePrincess
//
//  Created by chohaeun on 11/16/25.
//

import SwiftUI
import Foundation


// 상단 헤더 (오늘 날짜, 검색, 프로필)
struct HeaderSection: View {
    
    @StateObject private var viewModel:  CurrentViewModel
    @Environment(\.diContainer) private var di
    
    init(viewModel: CurrentViewModel = CurrentViewModel()) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    
    var body: some View{
            
            //상단 헤더
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
                
                    
                    Button {
                        di.router.push(.newReport)
                    } label: {
                        ZStack {
                            Circle()
                                .stroke(Color.secondaryBrown, lineWidth: 2) // 테두리 색과 두께 설정
                                .frame(width: 50, height: 50) // 원의 크기

                            Image(.fileicon)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 24, height: 24) // 아이콘 크기
                                .foregroundColor(.secondaryBrown)
                        }
                    }
                    .buttonStyle(PlainButtonStyle()) // 버튼의 기본 스타일 제거 (원형 유지)
            }
        }
    }


#Preview {
    HeaderSection()
}
