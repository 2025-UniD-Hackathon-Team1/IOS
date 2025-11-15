//
//  NewReportProfileViewModel.swift
//  CoffeePrincess
//
//  Created on 11/16/25.
//

import Foundation
import SwiftUI

class NewReportProfileViewModel: ObservableObject {
    
    // MARK: - Dependencies
    
    /// UserService 인스턴스를 ViewModel 내부에서 생성
    private let userService: UserService
    
    // MARK: - Published Properties
    
    @Published var gender: String = ""
    @Published var age: String = ""
    @Published var bedtime: String = "23:30"
    
    @Published var showAlert: Bool = false
    @Published var alertMessage: String = ""
    
    /// API 통신을 위한 로딩 상태
    @Published var isLoading: Bool = false
    
    // MARK: - Private Properties
    
    private let timeOptions: [String] = {
        var options: [String] = []
        for hour in 0..<24 {
            for minute in [0, 30] {
                options.append(String(format: "%02d:%02d", hour, minute))
            }
        }
        return options
    }()

    // MARK: - Init
    
    /// ViewModel이 생성될 때 UserService도 함께 생성
    init(userService: UserService = UserService()) {
        self.userService = userService
    }
    
    // MARK: - Public Methods
    
    /// (GET) 뷰가 나타날 때 서버에서 사용자 정보를 불러옵니다.
    func loadData() {
        isLoading = true
        
        userService.getUserInfo { [weak self] result in
            DispatchQueue.main.async {
                self?.isLoading = false
                switch result {
                case .success(let userInfo):
                    print("✅ [GET] 유저 정보 로드 성공:")
                    print("   - Gender: \(userInfo.gender)")
                    print("   - Age: \(userInfo.age)")
                    print("   - SleepTime: \(userInfo.sleepTime)")
                    
                    // ★★★ 수정 ★★★
                    // 서버의 "MALE"을 뷰의 "male"로 변경
                    self?.gender = userInfo.gender.lowercased()
                    
                    self?.age = String(userInfo.age)
                    
                    // ★★★ 수정 (잠재적 문제) ★★★
                    // 서버가 "11:00:00" (초)까지 주므로 "11:00" (분)까지만 잘라냅니다.
                    self?.bedtime = String(userInfo.sleepTime.prefix(5))

                case .failure(let error):
                    print("❌ [GET] 유저 정보 로드 실패: \(error.localizedDescription)")
                }
            }
        }
    }
    
    /// (POST) '완료' 버튼 클릭 시 서버에 데이터를 저장합니다.
    func saveData(completion: @escaping (Bool) -> Void) {
        guard validateData(), let ageInt = Int(age) else {
            completion(false)
            return
        }
        
        // ★★★ 수정 ★★★
        // 뷰의 "male"을 서버의 "MALE"로 변경
        let serverGender = self.gender.uppercased()
        
        // ★★★ 수정 ★★★
        // "HH:mm" 형식을 보장 (time picker를 조작했을 경우)
        let serverSleepTime = String(self.bedtime.prefix(5))
        
        // 3. API 요청 모델 생성
        let userInfo = UserInfo(gender: serverGender, age: ageInt, sleepTime: serverSleepTime)
        
        print("🚀 [POST] 유저 정보 저장 요청:")
        print("   - Gender: \(userInfo.gender)")
        print("   - Age: \(userInfo.age)")
        print("   - SleepTime: \(userInfo.sleepTime)")
        
        // 4. API 호출
        isLoading = true
        userService.updateUserInfo(userInfo: userInfo) { [weak self] result in
            DispatchQueue.main.async {
                self?.isLoading = false
                switch result {
                case .success:
                    // ★★★★★
                    // 3. 저장 성공 로그
                    // ★★★★★
                    print("✅ [POST] 유저 정보 저장 성공")
                    
                    completion(true)
                    
                case .failure(let error):
                    // ★★★★★
                    // 3-1. 저장 실패 로그
                    // ★★★★★
                    print("❌ [POST] 유저 정보 저장 실패: \(error.localizedDescription)")
                    
                    self?.alertMessage = "저장에 실패했습니다: \(error.localizedDescription)"
                    self?.showAlert = true
                    completion(false)
                }
            }
        }
    }
    
    /// 입력된 데이터의 유효성을 검사합니다.
    func validateData() -> Bool {
        // 1. 성별 검증
        if gender.isEmpty {
            alertMessage = "성별을 선택해주세요."
            showAlert = true
            return false
        }
        
        // 2. 나이 검증
        guard let ageInt = Int(age), ageInt > 0, ageInt <= 150 else {
            alertMessage = "올바른 나이를 입력해주세요."
            showAlert = true
            return false
        }
        
        // 3. 취침 시간 검증 (기본값이 있으므로 .isEmpty는 불필요)
        if bedtime.isEmpty {
            alertMessage = "희망 취침 시간을 선택해주세요."
            showAlert = true
            return false
        }
        
        // 모든 검증 통과
        return true
    }
    
    // MARK: - Helper Functions for DropdownPicker
    
    func getTimeOptions() -> [String] {
        return timeOptions
    }
    
    func formatTimeDisplay(_ time: String) -> String {
        let components = time.split(separator: ":")
        guard components.count == 2,
              let hour = Int(components[0]),
              let minute = Int(components[1]) else {
            return time
        }
        
        let hour12 = hour == 0 ? 12 : (hour > 12 ? hour - 12 : hour)
        let ampm = hour < 12 ? "오전" : "오후"
        return "\(ampm) \(hour12):\(String(format: "%02d", minute))"
    }
    
    func timeStringToDate(_ timeString: String) -> Date {
        let components = timeString.split(separator: ":")
        guard components.count == 2,
              let hour = Int(components[0]),
              let minute = Int(components[1]) else {
            let calendar = Calendar.current
            var components = calendar.dateComponents([.year, .month, .day], from: Date())
            components.hour = 23
            components.minute = 30
            return calendar.date(from: components) ?? Date()
        }
        
        let calendar = Calendar.current
        var dateComponents = calendar.dateComponents([.year, .month, .day], from: Date())
        dateComponents.hour = hour
        dateComponents.minute = minute
        return calendar.date(from: dateComponents) ?? Date()
    }
    
    func dateToTimeString(_ date: Date) -> String {
        let calendar = Calendar.current
        let hour = calendar.component(.hour, from: date)
        let minute = calendar.component(.minute, from: date)
        
        return String(format: "%02d:%02d", hour, minute)
    }
}
