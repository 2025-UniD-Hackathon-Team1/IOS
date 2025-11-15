//
//  NewReportViewModel.swift
//  CoffeePrincess
//
//  Created on 11/16/25.
//

import Foundation
import Combine

class NewReportViewModel: ObservableObject {
    
    // MARK: - Published Properties
    
    /// 서버에서 받은 원본 데이터를 저장 (Model)
    @Published var reportData: ReportData? = nil
    
    /// 로딩 상태
    @Published var isLoading: Bool = true

    // MARK: - Computed Properties (for View)
    
    /// 1. 월간 리포트 텍스트 (Model을 기반으로 계산)
    var monthlyReportText: String {
        guard let data = reportData else { return "" }
        
        return "섭취량이 \(data.ageGroup) \(data.gender) 평균 대비 \(data.comparisonPercentage)% \(data.comparisonStatus)."
    }
    
    /// 2. 수면 가이드 텍스트 (Model을 기반으로 계산)
    var sleepGuideText: String {
        guard let data = reportData else { return "" }
        
        return "꿀잠을 위해선 취침 최소 \(data.timeBeforeSleep)시간 전에 마지막 섭취를 권장합니다."
    }
    
    /// 3. 각성 가이드 텍스트 (Model을 기반으로 계산)
    var awakeGuideText: String {
        guard let data = reportData else { return "" }
        
        // 서버에서 받은 Int 값을 텍스트로 변환하는 로직 (템플릿 기반)
        let peakText = (data.timeBeforePeak == 1) ? "1시간" : "30분"
        
        return "최고의 효과를 위해, 중요 일정 시작 약 \(peakText) 전 섭취를 추천합니다."
    }
    
    // MARK: - Init
    
    init() {
        fetchReportData()
    }
    
    // MARK: - Public Methods
    
    /// 서버에서 리포트 데이터를 가져오는 함수 (가상)
    func fetchReportData() {
        isLoading = true
        
        // 2초 후 가상 데이터로 'ReportData' 모델을 채웁니다.
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            
            // (시뮬레이션) 서버에서 이런 데이터를 받았다고 가정합니다.
            let mockData = ReportData(
                ageGroup: "20대",
                gender: "여성",
                comparisonPercentage: 20,
                comparisonStatus: "많습니다",
                timeBeforeSleep: 6,
                timeBeforePeak: 1 // 1 = 1시간
            )
            
            // 원본 모델을 뷰모델에 저장합니다.
            self.reportData = mockData
            self.isLoading = false
        }
    }
}
