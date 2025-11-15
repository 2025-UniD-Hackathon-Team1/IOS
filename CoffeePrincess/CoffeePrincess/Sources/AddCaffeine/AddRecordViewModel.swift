//
//  AddRecordViewModel.swift
//  CoffeePrincess
//
//  Created by 김나영 on 11/16/25.
//

import Foundation
import Combine

class AddRecordViewModel: ObservableObject {
    
    @Published var coffeeList: [CoffeeItemResponse] = []
    @Published var isLoading: Bool = false
    
    // 날짜 포맷팅
    private var dateFomatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        formatter.locale = Locale(identifier: "en_US_POSIX")
        return formatter
    }()
    
    /// (GET) 오늘 날짜의 커피 기록을 불러옵니다.
    func fetchTodayCoffee(container: DIContainer) {
        isLoading = true
        let todayString = dateFomatter.string(from: Date())
        
        print("--- 🚀 [GET] 오늘 마신 커피 목록 요청 ---")
        
        container.coffeeService.getTodayCoffee(date: todayString) { [weak self] result in
            DispatchQueue.main.async {
                self?.isLoading = false
                switch result {
                case .success(let response):
                    print("✅ [GET] 커피 목록 로드 성공: \(response.coffeeItemResponseList.count)개")
                    self?.coffeeList = response.coffeeItemResponseList
                case .failure(let error):
                    print("❌ [GET] 커피 목록 로드 실패: \(error.localizedDescription)")
                }
            }
        }
    }
}
