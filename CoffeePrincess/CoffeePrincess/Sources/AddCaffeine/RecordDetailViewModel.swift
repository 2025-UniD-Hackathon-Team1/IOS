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
    
    @Published var shotCount: Int = 0 // "추가 샷"을 의미하며 0에서 시작
    @Published var size: CoffeeSize = .tall
    @Published var selectedDate: Date = Date()
    @Published var totalCaffeine: Int = 0 // 계산된 총 카페인
    
    // MARK: - Private Properties
    
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Initializer
    
    init(menuItem: MenuItem) {
        self.selectedMenuItem = menuItem
        
        // 1. 초기값 설정 (Tall, 추가 샷 0)
        self.size = .tall
        self.shotCount = 0
        
        // 2. 바인딩 설정
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
    
    /// 저장 버튼 로직 (DIContainer를 통해 주입받아 사용)
    func saveRecord(container: DIContainer) {
        print("--- 카페인 기록 저장 ---")
        print("메뉴: \(selectedMenuItem.name)")
        print("추가 샷: \(shotCount), 사이즈: \(size.rawValue)")
        print("시간: \(selectedDate)")
        print("총 카페인: \(totalCaffeine)mg")
        
        // TODO: container.caffeineService.addRecord(...) 같은 저장 로직 호출
        
        // 저장 후 이전 화면으로 돌아가기
        container.router.pop()
    }
}
