//
//  SurveyViewModel.swift
//  CoffeePrincess
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
    
    // MARK: - Service
    private let surveyService: SurveyService
    
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
    init(surveyService: SurveyService = SurveyService()) {
        self.surveyService = surveyService
        
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
    
    func getTimeOptions() -> [String] {
        var result: [String] = []
        let calendar = Calendar.current
        if let start = calendar.date(bySettingHour: 0, minute: 0, second: 0, of: Date()) {
            for i in 0..<(24 * 2) {
                if let time = calendar.date(byAdding: .minute, value: i * 30, to: start) {
                    result.append(timeFormatter.string(from: time))
                }
            }
        }
        return result
    }
    
    // MARK: - Validate & Send
    /// 유효성 검사 + 서버 전송까지 포함
    func validateAndSend(completion: @escaping (Bool) -> Void) {
        // 심박 선택 여부
        guard heartRate != 0 else {
            alertMessage = "심장이 얼마나 뛰었는지 선택해주세요."
            showAlert = true
            completion(false)
            return
        }
        
        // 수면 시간 선택 여부
        guard !sleepTime.isEmpty else {
            alertMessage = "어젯밤에 몇 시에 잠드셨는지 선택해주세요."
            showAlert = true
            completion(false)
            return
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
        
        // 서버 전송
        surveyService.sendSurvey(survey) { [weak self] result in
            DispatchQueue.main.async {
                guard let self = self else {
                    completion(false)
                    return
                }
                
                switch result {
                case .success:
                    print("✅ 설문 서버 전송 성공:", survey)
                    completion(true)
                    
                case .failure(let error):
                    print("❌ 설문 서버 전송 실패:", error)
                    self.alertMessage = "설문 서버 전송 실패: \(error.localizedDescription)"
                    self.showAlert = true
                    completion(false)
                }
            }
        }
    }
}
