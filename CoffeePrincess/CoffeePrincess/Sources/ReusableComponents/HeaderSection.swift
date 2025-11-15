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
                        di.router.push(.newReport)
                    } label: {
                        Image(.fileicon)
                            .resizable()
                            .scaledToFit()
                            .frame(height: 30)
                            .foregroundColor(.secondaryBrown)
                    }
                }
            }
            
        }
    }
}

#Preview {
    HeaderSection()
}
