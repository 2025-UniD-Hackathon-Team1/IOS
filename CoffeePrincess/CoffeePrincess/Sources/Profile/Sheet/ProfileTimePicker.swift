//
//  ProfileTimePicker.swift
//  CoffeePrincess
//
//  Created by 김나영 on 11/16/25.
//

import SwiftUI

// MARK: - 프로필 시간 선택 휠 피커
struct ProfileTimePicker: View {
    let title: String
    @Binding var selection: String
    @ObservedObject var profileViewModel: ProfileViewModel
    
    @State private var showPicker = false
    @State private var selectedDate: Date
    
    init(title: String, selection: Binding<String>, profileViewModel: ProfileViewModel) {
        self.title = title
        self._selection = selection
        self.profileViewModel = profileViewModel
        self._selectedDate = State(initialValue: profileViewModel.timeStringToDate(selection.wrappedValue))
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(title)
                .font(.pretendard(.medium, size: 15))
                .foregroundColor(.mainBrown)
            
            Button(action: {
                withAnimation(.easeInOut(duration: 0.3)) {
                    showPicker.toggle()
                }
            }) {
                HStack {
                    Text(profileViewModel.formatTimeDisplay(selection))
                        .font(.pretendard(.medium, size: 16))
                        .foregroundColor(.mainBrown)
                    
                    Spacer()
                    
                    Image(systemName: showPicker ? "chevron.up" : "chevron.down")
                        .font(.pretendard(.semiBold, size: 14))
                        .foregroundColor(.mainBrown)
                }
                .padding(12)
                .frame(maxWidth: .infinity)
                .background(Color.sectionBackground)
                .cornerRadius(10)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
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
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color.cardBackground.opacity(0.5))
                )
                .onChange(of: selectedDate) { oldValue, newValue in
                    selection = profileViewModel.dateToTimeString(newValue)
                }
                .transition(.opacity.combined(with: .move(edge: .top)))
            }
        }
        .onChange(of: selection) { oldValue, newValue in
            selectedDate = profileViewModel.timeStringToDate(newValue)
        }
    }
}
