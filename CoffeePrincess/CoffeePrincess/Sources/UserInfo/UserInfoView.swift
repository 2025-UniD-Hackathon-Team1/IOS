//
//  UserInfoView.swift
//  CoffeePrincess
//
//  Created on 11/15/25.
//

import SwiftUI

struct UserInfoView: View {
    @ObservedObject var viewModel: UserInfoViewModel
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 28) {
                    
                    // 기본 정보
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
                    }
                    
                    // 구분선
                    Divider()
                        .background(Color.dividerCol)
                        .padding(.vertical, 8)
                    
                    // 카페인 민감도
                    VStack(spacing: 20) {
                        Text("평소 카페인, 어느 정도 잘 맞나요?")
                            .font(.pretendard(.semiBold, size: 16))
                            .foregroundColor(.mainBrown)
                        
                        HStack {
                            Text("전혀 못 마심")
                                .font(.pretendard(.medium, size: 14))
                                .foregroundColor(.secondaryBrown)
                            Spacer()
                            Text("매우 둔감")
                                .font(.pretendard(.medium, size: 14))
                                .foregroundColor(.secondaryBrown)
                        }
                        
                        Slider(value: $viewModel.tolerance, in: 0...100, step: 1)
                            .tint(.mainBrown)
                        
                        Text("\(Int(viewModel.tolerance))")
                            .font(.pretendard(.bold, size: 20))
                            .foregroundColor(.mainBrown)
                    }
                    
                    // 구분선
                    Divider()
                        .background(Color.dividerCol)
                        .padding(.vertical, 8)
                    
                    // 건강 정보
                    VStack(alignment: .leading, spacing: 20) {
                        Text("카페인 섭취 후 심장이 과하게 뛴 경험이 있었나요?")
                            .font(.pretendard(.semiBold, size: 16))
                            .foregroundColor(.mainBrown)
                        
                        VStack(spacing: 12) {
                            RadioOption(
                                title: "자주 있다",
                                isSelected: viewModel.heartRate == "often",
                                action: { viewModel.heartRate = "often" }
                            )
                            RadioOption(
                                title: "가끔 있다",
                                isSelected: viewModel.heartRate == "sometimes",
                                action: { viewModel.heartRate = "sometimes" }
                            )
                            RadioOption(
                                title: "거의 없다",
                                isSelected: viewModel.heartRate == "rarely",
                                action: { viewModel.heartRate = "rarely" }
                            )
                            RadioOption(
                                title: "없음",
                                isSelected: viewModel.heartRate == "never",
                                action: { viewModel.heartRate = "never" }
                            )
                        }
                    }
                    
                    // 구분선
                    Divider()
                        .background(Color.dividerCol)
                        .padding(.vertical, 8)
                    
                    // 수면 패턴
                    VStack(alignment: .leading, spacing: 20) {
                        Text("평소 수면 패턴을 알려주세요")
                            .font(.pretendard(.semiBold, size: 16))
                            .foregroundColor(.mainBrown)
                        
                        VStack(alignment: .leading, spacing: 12) {
                            DropdownPicker(
                                title: "평소 잠드는 시간",
                                selection: $viewModel.bedtime,
                                options: viewModel.getTimeOptions(),
                                display: { viewModel.formatTimeDisplay($0) },
                                viewModel: viewModel
                            )
                        }
                        
                        VStack(alignment: .leading, spacing: 12) {
                            DropdownPicker(
                                title: "평소 일어나는 시간",
                                selection: $viewModel.wakeTime,
                                options: viewModel.getTimeOptions(),
                                display: { viewModel.formatTimeDisplay($0) },
                                viewModel: viewModel
                            )
                        }
                    }
                    
                    // 구분선
                    Divider()
                        .background(Color.dividerCol)
                        .padding(.vertical, 8)
                    
                    // 중요 일정
                    VStack(alignment: .leading, spacing: 20) {
                        Text("평일에 중요한 일정이 많은 시간대는 언제인가요?")
                            .font(.pretendard(.semiBold, size: 16))
                            .foregroundColor(.mainBrown)
                        
                        VStack(spacing: 12) {
                            ForEach(viewModel.importantTimeOptions, id: \.0) { option in
                                CheckboxOption(
                                    title: option.1,
                                    isSelected: viewModel.selectedImportantTimes.contains(option.0),
                                    action: {
                                        if viewModel.selectedImportantTimes.contains(option.0) {
                                            viewModel.selectedImportantTimes.remove(option.0)
                                        } else {
                                            viewModel.selectedImportantTimes.insert(option.0)
                                        }
                                    }
                                )
                            }
                        }
                    }
                    
                    // 완료 버튼
                    Button(action: {
                        if viewModel.validateAndSave() {
                            dismiss()
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
            .navigationTitle("정보 입력")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: { dismiss() }) {
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
    let viewModel: UserInfoViewModel
    
    @State private var showPicker = false
    @State private var selectedDate: Date
    
    init(title: String, selection: Binding<String>, options: [String], display: @escaping (String) -> String, viewModel: UserInfoViewModel) {
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


// MARK: - 성별 옵션 뷰
struct GenderOption: View {
    let title: String
    let value: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.pretendard(isSelected ? .bold : .medium, size: 13))
                .foregroundColor(isSelected ? .white : .mainBrown)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 14)
                .background(isSelected ? Color.mainBrown : Color.cardBackground)
                .cornerRadius(12)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(isSelected ? Color.mainBrown : Color.dividerCol, lineWidth: isSelected ? 2 : 1)
                )
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
    UserInfoView(viewModel: UserInfoViewModel())
}
