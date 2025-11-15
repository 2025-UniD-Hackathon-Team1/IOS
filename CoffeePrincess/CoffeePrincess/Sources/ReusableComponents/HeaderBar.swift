//
//  HeaderBar.swift
//  CoffeePrincess
//
//  Created by 김나영 on 11/15/25.
//

import SwiftUI

struct HeaderBar: View {
    let viewText: String
    var onTapBack: () -> Void
    
    var body: some View {
        ZStack {
            HStack {
                Button(action: { onTapBack() }) {
                    Image(systemName: "chevron.left")
                        .foregroundStyle(.black)
                        .padding(.leading)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding()
                Spacer()
            }
            
            // 인덱스 중앙
            Text(viewText)
                .font(.pretendard(.regular, size: 18))
//                .foregroundStyle(.mainBrown)
        }
    }
}
