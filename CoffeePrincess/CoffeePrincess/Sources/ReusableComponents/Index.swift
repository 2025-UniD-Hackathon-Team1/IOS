//
//  Index.swift
//  CoffeePrincess
//
//  Created by chohaeun on 11/16/25.
//
import SwiftUI

struct Index: View {
    
    @Environment(\.diContainer) private var di
    
    private enum Tab {
        case current
        case future
        case sleep
    }
    
    @State private var selectedTab: Tab = .current
    
    var body: some View {
        ZStack {
            Color(.cardBackground)
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                HeaderSection()
                    .padding(25)
                
                tabBar

                // 🔥 스크롤 가능한 고정 영역
                ScrollView(.vertical, showsIndicators: false) {
                    VStack(spacing: 0) {
                        content
                    }
                }
            }
            
            if selectedTab == .current {
                Image(.kong)
                    .resizable()
                    .scaledToFit()
                    .frame(height: 75)
                    .offset(x: 140, y: -260)
            }
            
            HStack {
                Spacer()
                addCaffeineButton
            }
            .padding(.trailing, 24)
            .padding(.bottom, 24)
            .offset(y: 350)
        }
    }
    
    private var tabBar: some View {
        HStack(alignment: .bottom, spacing: 1) {
            tabButton(title: "현재", tab: .current)
            tabButton(title: "미래", tab: .future)
            tabButton(title: "수면", tab: .sleep)
            Spacer()
        }
        .padding(.top, 16)
        .padding(.horizontal, 28)
    }
    
    private func tabButton(title: String, tab: Tab) -> some View {
        Button {
            selectedTab = tab
        } label: {
            Text(title)
                .font(.subheadline)
                .fontWeight(.semibold)
                .padding(.horizontal, 18)
                .padding(.vertical, 10)
        }
        .background(
            selectedTab == tab ? Color.mainBrown : Color.white
        )
        .foregroundColor(
            selectedTab == tab ? Color.white : Color.mainBrown
        )
        .cornerRadius(12, corners: [.topLeft, .topRight])
    }
    
    @ViewBuilder
    private var content: some View {
        switch selectedTab {
        case .current:
            CurrentView()      // ✅ 각 View가 자기 ViewModel을 가짐
        case .future:
            FutureView()
        case .sleep:
            SleepView()
        }
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
}

// 아래 RoundedCorner / cornerRadius extension은 그대로 사용
struct RoundedCorner: Shape {
    var radius: CGFloat = 10
    var corners: UIRectCorner = .allCorners

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(
            roundedRect: rect,
            byRoundingCorners: corners,
            cornerRadii: CGSize(width: radius, height: radius)
        )
        return Path(path.cgPath)
    }
}

extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape( RoundedCorner(radius: radius, corners: corners) )
    }
}

#Preview {
    Index()
}
