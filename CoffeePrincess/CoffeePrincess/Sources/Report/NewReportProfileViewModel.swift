//
//  NewReportViewModel.swift
//  CoffeePrincess
//
//  Created on 11/16/25.
//

import Foundation
import SwiftUI

class NewReportProfileViewModel: ObservableObject {
    
    // MARK: - Published Properties
    
    /// 성별 (male, female, other)
    @Published var gender: String = ""
    
    /// 나이 (문자열로 입력받음)
    @Published var age: String = ""
    
    /// 희망 취침 시간 (HH:mm 형식)
    @Published var bedtime: String = "23:30"
    
    /// 유효성 검사 알림
    @Published var showAlert: Bool = false
    @Published var alertMessage: String = ""
    
    // MARK: - Private Properties
    
    /// 시간 선택 옵션 (30분 단위)
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
    
    init() {
        // 필요시 이곳에서 저장된 데이터를 불러올 수 있습니다.
        // loadData()
    }
    
    // MARK: - Public Methods
    
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
    
    /// 시간 선택 피커에 사용될 옵션 배열을 반환합니다.
    func getTimeOptions() -> [String] {
        return timeOptions
    }
    
    /// "HH:mm" 형식의 시간을 "오전/오후 H:mm" 형식으로 변환합니다.
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
    
    /// "HH:mm" 형식의 문자열을 Date 객체로 변환합니다. (오늘 날짜 기준)
    func timeStringToDate(_ timeString: String) -> Date {
        let components = timeString.split(separator: ":")
        guard components.count == 2,
              let hour = Int(components[0]),
              let minute = Int(components[1]) else {
            // 기본값: 오늘 23:30
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
    
    /// Date 객체를 "HH:mm" 형식의 문자열로 변환합니다.
    func dateToTimeString(_ date: Date) -> String {
        let calendar = Calendar.current
        let hour = calendar.component(.hour, from: date)
        let minute = calendar.component(.minute, from: date)
        
        // DatePicker가 30분 단위가 아닐 수 있으므로, 30분 단위로 반올림 (선택 사항)
        // 여기서는 DatePicker의 값을 그대로 사용합니다.
        // let roundedMinute = (minute / 30) * 30
        
        return String(format: "%02d:%02d", hour, minute)
    }
}
