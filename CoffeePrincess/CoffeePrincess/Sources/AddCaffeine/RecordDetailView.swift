//
//  RecordDetailView.swift
//  CoffeePrincess
//
//  Created by 김나영 on 11/15/25.
//

import SwiftUI

/// 선택한 메뉴의 상세 정보(샷, 사이즈, 시간)를 입력하고 저장하는 뷰입니다.
struct RecordDetailView: View {
    @Environment(\.diContainer) private var di
    
    // 1. @StateObject는 뷰가 직접 소유하고 생성해야 합니다.
    //    (private var로 변경)
    @StateObject private var viewModel: RecordDetailViewModel
    
    // 2. ViewModel을 생성하는데 필요한 '데이터'인 MenuItem을 init에서 받습니다.
    private let menuItem: MenuItem
    
    // 3. init(menuItem:) 추가
    init(menuItem: MenuItem) {
        self.menuItem = menuItem
        // 4. 전달받은 menuItem으로 ViewModel을 '내부에서' 생성합니다.
        self._viewModel = StateObject(wrappedValue: RecordDetailViewModel(menuItem: menuItem))
    }
    
    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                HeaderBar(viewText: viewModel.selectedMenuItem.name, onTapBack: { di.router.pop() })
                List {
                    // MARK: - 메뉴 설정
                    Section(header: headerView(title: "섭취량 설정")) {
                        Stepper(value: $viewModel.shotCount, in: 0...10) {
                            HStack {
    //                            Image(systemName: "plus.circle")
                                Image(.plus)
                                    .foregroundStyle(Color.mainBrown)
                                    .padding(.trailing, 5)
                                Text("샷 추가")
    //                                .font(.pretendard(.regular, size: 17))
                                Spacer()
                                Text("\(viewModel.shotCount) 샷")
                                    .foregroundStyle(Color.mainBrown)
                            }
                        }
                        .font(.pretendard(.regular, size: 17))
                        HStack {
                            Image(.size)
                                .foregroundStyle(Color.mainBrown)
                                .padding(.trailing, 5)
                            Picker("사이즈", selection: $viewModel.size) {
                                ForEach(CoffeeSize.allCases, id: \.self) { size in
                                    Text(size.rawValue).tag(size)
                                }
                            }
                        }
                        .font(.pretendard(.regular, size: 17))
                        .pickerStyle(.menu)
                        .tint(Color.mainBrown)
                    }
                    .listRowBackground(Color.cardBackground)
                    
                    // MARK: - 시간 설정
                    Section(header: headerView(title: "섭취 시간")) {
                        DatePicker(
                            "마신 시간",
                            selection: $viewModel.selectedDate,
                            in: ...Date(), // 미래 시간은 선택 불가
                            displayedComponents: [.date, .hourAndMinute]
                        )
                        .datePickerStyle(.graphical) // 달력 스타일
                        .labelsHidden()
                        .tint(Color.secondaryBrown)
                    }
                    .listRowBackground(Color.cardBackground)
                    
                    // MARK: - 총 카페인 (계산 결과)
                    Section(/*header: headerView(title: "예상 카페인")*/) {
                        HStack {
                            Image("activity-heart")
                                .foregroundStyle(Color.mainBrown)
                            Text("예상 총 카페인 함량")
                                .font(.pretendard(.regular, size: 17))
                            Spacer()
                            Text("\(viewModel.totalCaffeine) mg")
                                .font(.pretendard(.bold, size: 19))
                                .foregroundColor(.secondaryBrown)
                        }
                    }
                    .listRowBackground(Color.cardBackground)
                }
                .scrollContentBackground(.hidden)
    //            .listStyle(.insetGrouped)
                
                // MARK: - 저장 버튼
                Button(action: {
                    viewModel.saveRecord(container: di)
                }) {
                    Text("저장하기")
                        .font(.pretendard(.bold, size: 18))
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.secondaryBrown)
                        .foregroundColor(.white)
                        .cornerRadius(12)
                }
                .padding(.horizontal, 20)
    //            .padding(.bottom, 10)
            }
            if viewModel.isLoading {
                Color.black.opacity(0.3).ignoresSafeArea()
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle(tint: .white))
                    .scaleEffect(1.5)
            }
        }
        .alert("알림", isPresented: $viewModel.showAlert) {
            Button("확인", role: .cancel) { }
        } message: {
            Text(viewModel.alertMessage)
        }
//        .navigationTitle(viewModel.selectedMenuItem.name) // 네비게이션 타이틀에 메뉴 이름
//        .navigationBarTitleDisplayMode(.inline)
    }
    
    @ViewBuilder
    private func headerView(title: String) -> some View {
        Text(title)
            .font(.pretendard(.regular, size: 18)) // "평소 수면 패턴" 폰트와 비슷하게
            .foregroundStyle(Color.mainBrown) // 메인 브라운보다 연한 색
//            .padding(.leading, 8) // List의 기본 패딩과 맞춤
//            .padding(.bottom, 8) // 섹션과 간격
            .textCase(nil) // 대문자 변환 비활성화
    }
}

// MARK: - Preview
#Preview {
    let mockItem = MenuItem.mockStarbucksItems[0] // "아메리카노"
    RecordDetailView(menuItem: mockItem)
}
