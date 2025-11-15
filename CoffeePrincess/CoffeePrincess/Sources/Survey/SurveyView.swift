//
//  SurveyView.swift
//  CoffeePrincess
//
//  Created by chohaeun on 11/16/25.
//

import SwiftUI

struct SurveyView: View {
    
    @StateObject private var viewModel = SurveyViewModel()
    @Environment(\.diContainer) private var di
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 28) {
                    
                    // 건강 정보
                    VStack(alignment: .leading, spacing: 20) {
                        Text("어젯밤 카페인 섭취 후 심장이 과하게 뛰는 경험을 느꼈나요?")
                            .font(.pretendard(.semiBold, size: 16))
                            .foregroundColor(.mainBrown)
                        
                        VStack(spacing: 12) {
                            RadioOption(
                                title: "자주 느꼈다",
                                isSelected: viewModel.heartRate == 5,
                                action: { viewModel.heartRate = 5 }
                            )
                            RadioOption(
                                title: "가끔 느꼈다",
                                isSelected: viewModel.heartRate == 4,
                                action: { viewModel.heartRate = 4 }
                            )
                            RadioOption(
                                title: "보통이다",
                                isSelected: viewModel.heartRate == 3,
                                action: { viewModel.heartRate = 3 }
                            )
                            RadioOption(
                                title: "거의 안 느꼈다",
                                isSelected: viewModel.heartRate == 2,
                                action: { viewModel.heartRate = 2 }
                            )
                            RadioOption(
                                title: "전혀 안 느꼈다",
                                isSelected: viewModel.heartRate == 1,
                                action: { viewModel.heartRate = 1 }
                            )
                        }
                    }
                    
                    // 구분선
                    Divider()
                        .background(Color.dividerCol)
                        .padding(.vertical, 8)
                    
                    // 수면 패턴
                    VStack(alignment: .leading, spacing: 20) {
                        Text("어젯밤에 몇 시에 잠드셨나요?")
                            .font(.pretendard(.semiBold, size: 16))
                            .foregroundColor(.mainBrown)
                        
                        VStack(alignment: .leading, spacing: 12) {
                            DropdownPicker(
                                title: "평소 잠드는 시간",
                                selection: $viewModel.sleepTime,          // ✅ SurveyModel 기반
                                options: viewModel.getTimeOptions(),
                                display: { viewModel.formatTimeDisplay($0) },
                                viewModel: viewModel
                            )
                        }
                    }
                    
                    
                    // 완료 버튼
                    Button(action: {
                        if viewModel.validateAndSave() {
                            di.router.pop()
                        }
                    }) {
                        Text("완료")
                            .font(.pretendard(.semiBold, size: 18))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 18)
                            .background(Color.mainBrown)
                            .cornerRadius(16)
                    }
                    .padding(.vertical, 30)
                }
                .padding(.horizontal, 20)
                .padding(.top, 20)
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        di.router.pop()}) {
                        Image(systemName: "chevron.left")
                            .foregroundColor(.mainBrown)
                    }
                }
            }
        }
        .alert("알림", isPresented: $viewModel.showAlert) {
            Button("확인", role: .cancel) { }
        } message: {
            Text(viewModel.alertMessage)
        }
    }
}

// MARK: - 커스텀 시간 선택 휠 피커
struct DropdownPicker: View {
    let title: String
    @Binding var selection: String
    let options: [String]
    let display: (String) -> String
    let viewModel: SurveyViewModel
    
    @State private var showPicker = false
    @State private var selectedDate: Date
    
    init(title: String, selection: Binding<String>, options: [String], display: @escaping (String) -> String, viewModel: SurveyViewModel) {
        self.title = title
        self._selection = selection
        self.options = options
        self.display = display
        self.viewModel = viewModel
        self._selectedDate = State(initialValue: viewModel.timeStringToDate(selection.wrappedValue))
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(title)
                .font(.pretendard(.medium, size: 14))
                .foregroundColor(.mainBrown)
            
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
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color.sectionBackground.opacity(0.5))
                )
                .onChange(of: selectedDate) { oldValue, newValue in
                    selection = viewModel.dateToTimeString(newValue)
                }
                .transition(.opacity.combined(with: .move(edge: .top)))
            }
        }
        .onChange(of: selection) { oldValue, newValue in
            selectedDate = viewModel.timeStringToDate(newValue)
        }
    }
}



// MARK: - 라디오 옵션 뷰
struct RadioOption: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 14) {
                ZStack {
                    Circle()
                        .stroke(isSelected ? Color.mainBrown : Color.dividerCol, lineWidth: 2)
                        .frame(width: 22, height: 22)
                    
                    if isSelected {
                        Circle()
                            .fill(Color.mainBrown)
                            .frame(width: 22, height: 22)
                        Circle()
                            .fill(Color.white)
                            .frame(width: 10, height: 10)
                    }
                }
                
                Text(title)
                    .font(.pretendard(.medium, size: 16))
                    .foregroundColor(.mainBrown)
                
                Spacer()
            }
            .padding(16)
            .background(isSelected ? Color.sectionBackground : Color.white)
            .cornerRadius(12)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(isSelected ? Color.mainBrown : Color.dividerCol, lineWidth: isSelected ? 2 : 1)
            )
        }
    }
}

// MARK: - 체크박스 옵션 뷰
struct CheckboxOption: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 14) {
                ZStack {
                    RoundedRectangle(cornerRadius: 4)
                        .stroke(isSelected ? Color.mainBrown : Color.dividerCol, lineWidth: 2)
                        .frame(width: 22, height: 22)
                        .background(isSelected ? Color.mainBrown : Color.white)
                    
                    if isSelected {
                        Text("✓")
                            .font(.pretendard(.bold, size: 14))
                            .foregroundColor(.white)
                    }
                }
                
                Text(title)
                    .font(.pretendard(.medium, size: 16))
                    .foregroundColor(.mainBrown)
                
                Spacer()
            }
            .padding(16)
            .background(isSelected ? Color.sectionBackground : Color.white)
            .cornerRadius(12)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(isSelected ? Color.mainBrown : Color.dividerCol, lineWidth: isSelected ? 2 : 1)
            )
        }
    }
}

// MARK: - Preview
#Preview {
    SurveyView()
}
