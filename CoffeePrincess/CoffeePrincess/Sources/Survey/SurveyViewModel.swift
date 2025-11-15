//
//  SurveyViewModel.swift
//  CoffeePrincess
//
//  Created by chohaeun on 11/16/25.
//

import Foundation
import SwiftUI

class SurveyViewModel: ObservableObject {
    
    // MARK: - Input Properties (SurveyModel 기반)
    @Published var sleepTime: String
    @Published var heartRate: Int
    
    // MARK: - Alert
    @Published var showAlert: Bool = false
    @Published var alertMessage: String = ""
    
    // MARK: - Formatter
    private let timeFormatter: DateFormatter = {
        let df = DateFormatter()
        df.dateFormat = "HH:mm"
        df.locale = Locale(identifier: "ko_KR")
        return df
    }()
    
    private let displayTimeFormatter: DateFormatter = {
        let df = DateFormatter()
        df.dateFormat = "a h시 m분"
        df.locale = Locale(identifier: "ko_KR")
        return df
    }()
    
    private let dateFormatter: DateFormatter = {
        let df = DateFormatter()
        df.dateFormat = "yyyy-MM-dd"
        df.locale = Locale(identifier: "ko_KR")
        return df
    }()
    
    // MARK: - Init
    init() {
        // 기본 수면 시간: 현재 시각 기준
        let now = Date()
        self.sleepTime = timeFormatter.string(from: now)
        self.heartRate = 0   // 아직 선택 안 함
    }
    
    // MARK: - Time Helpers
    func timeStringToDate(_ time: String) -> Date {
        if let date = timeFormatter.date(from: time) {
            return date
        }
        return Date()
    }
    
    func dateToTimeString(_ date: Date) -> String {
        return timeFormatter.string(from: date)
    }
    
    func formatTimeDisplay(_ time: String) -> String {
        let date = timeStringToDate(time)
        return displayTimeFormatter.string(from: date)
    }
    
    /// (옵션용) 시간 리스트가 필요하다면 사용 – 현재 뷰에서는 DatePicker만 쓰고 options는 크게 의미 없음
    func getTimeOptions() -> [String] {
        var result: [String] = []
        let calendar = Calendar.current
        if let start = calendar.date(bySettingHour: 0, minute: 0, second: 0, of: Date()) {
            for i in 0..<(24 * 2) { // 30분 단위
                if let time = calendar.date(byAdding: .minute, value: i * 30, to: start) {
                    result.append(timeFormatter.string(from: time))
                }
            }
        }
        return result
    }
    
    // MARK: - Validate & Save
    func validateAndSave() -> Bool {
        // 심박 선택 여부
        guard heartRate != 0 else {
            alertMessage = "심장이 얼마나 뛰었는지 선택해주세요."
            showAlert = true
            return false
        }
        
        // 수면 시간 선택 여부
        guard !sleepTime.isEmpty else {
            alertMessage = "어젯밤에 몇 시에 잠드셨는지 선택해주세요."
            showAlert = true
            return false
        }
        
        // sleepDate는 "어젯밤" 기준으로 어제 날짜 자동 세팅
        let calendar = Calendar.current
        let today = Date()
        let yesterday = calendar.date(byAdding: .day, value: -1, to: today) ?? today
        let sleepDateString = dateFormatter.string(from: yesterday)
        
        let survey = SurveyModel(
            sleepDate: sleepDateString,
            sleepTime: sleepTime,
            heartRate: heartRate
        )
        
        saveSurvey(survey)
        return true
    }
    
    // MARK: - Save (실제 저장 로직은 여기서 분리해서 구현 가능)
    private func saveSurvey(_ survey: SurveyModel) {
        // TODO: SurveyService 연동 등 실제 저장 로직
        // 예: SurveyService.shared.save(survey)
        print("Saved Survey:", survey)
    }
}
