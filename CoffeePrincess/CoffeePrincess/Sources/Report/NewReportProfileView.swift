//
//  NewReportProfileView.swift
//  CoffeePrincess
//
//  Created on 11/16/25.
//

import SwiftUI

struct NewReportProfileView: View {
    @Environment(\.diContainer) private var di
    
    // ViewModel은 View 내에서 생성됩니다.
    // ViewModel의 init()에서 UserService가 생성됩니다.
    @StateObject var viewModel = NewReportProfileViewModel()
    
    var body: some View {
        // ZStack을 추가하여 로딩 뷰를 오버레이
        ZStack {
            VStack(alignment: .leading, spacing: 20) {
                HeaderBar(viewText: "프로필 설정", onTapBack: { di.router.pop() })
                
                // 불필요한 Spacer 제거, ScrollView로 대체
                ScrollView {
                    VStack(alignment: .leading, spacing: 20) {
                        
                        // 성별
                        VStack(alignment: .leading, spacing: 12) {
                            Text("성별")
                                .font(.pretendard(.semiBold, size: 16))
                                .foregroundColor(.mainBrown)
                            
                            HStack(spacing: 12) {
                                GenderOption(
                                    title: "남성",
                                    value: "male",
                                    isSelected: viewModel.gender == "male",
                                    action: { viewModel.gender = "male" }
                                )
                                GenderOption(
                                    title: "여성",
                                    value: "female",
                                    isSelected: viewModel.gender == "female",
                                    action: { viewModel.gender = "female" }
                                )
                                GenderOption(
                                    title: "기타",
                                    value: "other",
                                    isSelected: viewModel.gender == "other",
                                    action: { viewModel.gender = "other" }
                                )
                            }
                        }
                        .padding(.horizontal, 20)
                        
                        // 나이
                        VStack(alignment: .leading, spacing: 12) {
                            Text("나이")
                                .font(.pretendard(.semiBold, size: 16))
                                .foregroundColor(.mainBrown)
                            
                            TextField("나이를 입력하세요", text: $viewModel.age)
                                .font(.pretendard(.medium, size: 16))
                                .keyboardType(.numberPad)
                                .padding(14)
                                .background(Color.cardBackground)
                                .cornerRadius(12)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 12)
                                        .stroke(Color.dividerCol, lineWidth: 1)
                                )
                        }
                        .padding(.horizontal, 20)
                        
                        // 희망 취침 시간
                        VStack(alignment: .leading, spacing: 12) {
                            Text("희망 취침 시간")
                                .font(.pretendard(.semiBold, size: 16))
                                .foregroundColor(.mainBrown)
                            
                            VStack(alignment: .leading, spacing: 12) {
                                ReportDropdownPicker(
                                    selection: $viewModel.bedtime,
                                    options: viewModel.getTimeOptions(),
                                    display: { viewModel.formatTimeDisplay($0) },
                                    viewModel: viewModel
                                )
                            }
                        }
                        .padding(.horizontal, 20)
                    }
                    .padding(.top, 20) // ScrollView 컨텐츠 상단 패딩
                }
                
                Spacer() // 버튼을 하단에 고정
                
                // 완료 버튼 (ScrollView 밖에 위치)
                Button(action: {
                    // ★★★ 수정된 버튼 액션 ★★★
                    viewModel.saveData { success in
                        if success {
                            // 저장이 성공했을 때만 pop 실행
                            print("데이터 저장 성공, 뷰를 닫습니다.")
                            di.router.pop()
                        }
                    }
                }) {
                    Text("완료")
                        .font(.pretendard(.semiBold, size: 18))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 18)
                        .background(Color.secondaryBrown)
                        .cornerRadius(16)
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 30)
            }
//            .background(Color.screenBackground.ignoresSafeArea()) // 배경색
            
            // ★★★ 로딩 오버레이 ★★★
            if viewModel.isLoading {
                Color.black.opacity(0.3).ignoresSafeArea()
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle(tint: .white))
                    .scaleEffect(1.5)
            }
        }
        .onAppear {
            // ★★★ 뷰가 나타날 때 데이터 로드 ★★★
            viewModel.loadData()
        }
        .alert("알림", isPresented: $viewModel.showAlert) {
            // ★★★ 알림 모디파이어 ★★★
            Button("확인", role: .cancel) { }
        } message: {
            Text(viewModel.alertMessage)
        }
    }
}

// MARK: - (MODIFIED) 커스텀 시간 선택 휠 피커
// NewReportViewModel을 사용하도록 수정
struct ReportDropdownPicker: View {
    @Binding var selection: String
    let options: [String]
    let display: (String) -> String
    let viewModel: NewReportProfileViewModel // <-- 타입 변경
    
    @State private var showPicker = false
    @State private var selectedDate: Date
    
    init(selection: Binding<String>, options: [String], display: @escaping (String) -> String, viewModel: NewReportProfileViewModel) { // <-- 타입 변경
        self._selection = selection
        self.options = options
        self.display = display
        self.viewModel = viewModel
        // viewModel의 헬퍼 함수를 사용하여 Date 초기화
        self._selectedDate = State(initialValue: viewModel.timeStringToDate(selection.wrappedValue))
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Button(action: {
                withAnimation(.easeInOut(duration: 0.3)) {
                    showPicker.toggle()
                }
            }) {
                HStack {
                    Text(display(selection))
                        .font(.pretendard(.medium, size: 16))
                        .foregroundColor(.mainBrown)
                    
                    Spacer()
                    
                    Image(systemName: showPicker ? "chevron.up" : "chevron.down")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(.mainBrown)
                }
                .padding(14)
                .frame(maxWidth: .infinity)
                .background(Color.cardBackground)
                .cornerRadius(12)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color.dividerCol, lineWidth: 1)
                )
            }
            
            if showPicker {
                DatePicker(
                    "",
                    selection: $selectedDate,
                    displayedComponents: .hourAndMinute
                )
                .datePickerStyle(.wheel)
                .labelsHidden()
                .tint(.mainBrown)
                .padding(.vertical, 8)
                .onChange(of: selectedDate) { oldValue, newValue in
                    // viewModel의 헬퍼 함수를 사용하여 String으로 변환
                    selection = viewModel.dateToTimeString(newValue)
                }
                .transition(.opacity.combined(with: .move(edge: .top)))
            }
        }
        .onChange(of: selection) { oldValue, newValue in
            // 외부에서 selection 바인딩이 변경될 경우 DatePicker의 selectedDate도 동기화
            selectedDate = viewModel.timeStringToDate(newValue)
        }
    }
}

// MARK: - (COPIED) 성별 옵션 뷰
// NewReportView에서 사용하기 위해 원본 코드를 복사
struct GenderOption: View {
    let title: String
    let value: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.pretendard(isSelected ? .bold : .medium, size: 13)) // Custom Font
                .foregroundColor(isSelected ? .white : .mainBrown) // Custom Color
                .frame(maxWidth: .infinity)
                .padding(.vertical, 14)
                .background(isSelected ? Color.secondaryBrown : Color.cardBackground) // Custom Color
                .cornerRadius(12)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(isSelected ? Color.secondaryBrown : Color.dividerCol, lineWidth: isSelected ? 2 : 1) // Custom Color
                )
        }
    }
}

#Preview {
    NewReportProfileView()
}
