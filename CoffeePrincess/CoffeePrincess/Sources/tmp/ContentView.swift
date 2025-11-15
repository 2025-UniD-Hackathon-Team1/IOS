//
//  ContentView.swift
//  cafe_frame
//
//  Created by 김세은 on 11/15/25.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var userInfoManager = UserInfoManager()
    @StateObject private var tracker = CaffeineTracker()
    
    var body: some View {
        Group {
            if !userInfoManager.userInfo.completed || userInfoManager.userInfo.step < 2 {
                if userInfoManager.userInfo.step == 1 {
                    Onboarding2View(userInfoManager: userInfoManager)
                        .onAppear {
                            userInfoManager.loadUserInfo()
                        }
                } else {
                    OnboardingView(userInfoManager: userInfoManager)
                        .onAppear {
                            userInfoManager.loadUserInfo()
                        }
                }
            } else {
                MainView(tracker: tracker, userInfoManager: userInfoManager)
            }
        }
        .onAppear {
            userInfoManager.loadUserInfo()
            if userInfoManager.userInfo.maxCaffeine == 0 {
                userInfoManager.userInfo.maxCaffeine = userInfoManager.getDefaultMaxCaffeine()
            }
        }
    }
}

#Preview {
    ContentView()
}
