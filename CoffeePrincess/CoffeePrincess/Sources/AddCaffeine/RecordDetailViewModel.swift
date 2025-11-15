//
//  RecordDetailViewModel.swift
//  CoffeePrincess
//
//  Created by 김나영 on 11/15/25.
//

import Foundation
import Combine
import SwiftUI

/// RecordDetailView의 상태와 로직을 관리하는 ViewModel (새 로직 적용)
class RecordDetailViewModel: ObservableObject {
    // MARK: - Properties
    let selectedMenuItem: MenuItem
    
    // MARK: - Published State
    
    @Published var shotCount: Int = 0
    @Published var size: CoffeeSize = .tall
    @Published var selectedDate: Date = Date()
    @Published var totalCaffeine: Int = 0
    
    // --- ★★★ API 연동을 위해 추가된 상태 ★★★ ---
    @Published var isLoading: Bool = false
    @Published var showAlert: Bool = false
    @Published var alertMessage: String = ""
    
    // MARK: - Private Properties
    
    private var cancellables = Set<AnyCancellable>()
    
    // --- ★★★ 날짜 포맷을 위한 헬퍼 추가 ★★★ ---
    private var dateFomatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        formatter.locale = Locale(identifier: "en_US_POSIX")
        return formatter
    }()
    
    private var timeFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        formatter.locale = Locale(identifier: "en_US_POSIX")
        return formatter
    }()

    // MARK: - Initializer
    
    // (A님이 원하시는 init(menuItem:) 구조)
    init(menuItem: MenuItem) {
        self.selectedMenuItem = menuItem
        self.size = .tall
        self.shotCount = 0
        setupBindings()
    }
    
    // MARK: - Private Methods
    
    private func setupBindings() {
        // 1. (핵심) 'shotCount' 또는 'size'가 변경될 때마다,
        Publishers.CombineLatest($shotCount, $size)
            .sink { [weak self] (shots, size) in
                // 2. 총 카페인을 다시 계산합니다.
                self?.updateTotalCaffeine(extraShots: shots, selectedSize: size)
            }
            .store(in: &cancellables)
    }
    
    /// 총 카페인을 계산하는 로직 (새 로직 적용)
    private func updateTotalCaffeine(extraShots: Int, selectedSize: CoffeeSize) {
        
        // 1. (메뉴, 사이즈)에 맞는 '기본' 카페인 조회
        let baseCaffeine = CaffeineData.getBaseCaffeine(for: selectedMenuItem, size: selectedSize)
        
        // 2. '추가' 샷 카페인 계산
        let extraCaffeine = extraShots * CaffeineData.caffeinePerShot
        
        // 3. 총 합계
        self.totalCaffeine = baseCaffeine + extraCaffeine
        
        print("(\(selectedSize.rawValue), 샷추가: \(extraShots)) 총 카페인 계산됨: \(totalCaffeine)mg")
    }
    
    // MARK: - Public Methods
    
    /// (POST) ★★★ 서버에 커피 기록을 저장하는 수정된 함수 ★★★
    func saveRecord(container: DIContainer) {
        
        // 1. 서버에 보낼 CoffeeRecord 모델 생성
        let record = CoffeeRecord(
            drinkDate: dateFomatter.string(from: selectedDate),
            drinkTime: timeFormatter.string(from: selectedDate),
            coffeeName: selectedMenuItem.name,
            caffeineAmount: totalCaffeine
        )
        
        print("--- 🚀 [POST] 커피 기록 저장 요청 ---")
        print(record)
        
        isLoading = true
        
        // 2. (수정) DIContainer에서 'coffeeService'를 가져와 API 호출
        //    (DIContainer에 coffeeService가 등록되어 있어야 함)
        container.coffeeService.addCoffeeRecord(record) { [weak self] result in
            
            // 3. 메인 스레드에서 UI 업데이트
            DispatchQueue.main.async {
                self?.isLoading = false
                
                switch result {
                case .success:
                    print("✅ [POST] 커피 기록 저장 성공")
                    // 4. 성공 시 이전 화면으로 돌아가기
                    container.router.pop()
                    
                case .failure(let error):
                    print("❌ [POST] 커피 기록 저장 실패: \(error.localizedDescription)")
                    // 5. 실패 시 알림
                    self?.alertMessage = "저장에 실패했습니다: \(error.localizedDescription)"
                    self?.showAlert = true
                }
            }
        }
    }
}
