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
    
    @StateObject private var viewModel: MainViewModel
    @Environment(\.diContainer) private var di
    
    init(viewModel: MainViewModel = MainViewModel()) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    
    var body: some View{
        VStack{
            
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
            
            Spacer()
        }
    }
}

#Preview {
    HeaderSection()
}
