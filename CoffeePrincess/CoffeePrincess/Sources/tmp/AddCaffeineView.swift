//
//  AddCaffeineView.swift
//  cafe_frame
//
//  Created by 김세은 on 11/15/25.
//

import SwiftUI

struct AddCaffeineView: View {
    @ObservedObject var tracker: CaffeineTracker
    @Environment(\.dismiss) var dismiss
    @State private var showSearch = false
    @State private var showTimeModal = false
    @State private var selectedAmount: Int = 0
    @State private var selectedDrinkName: String = ""
    @State private var customAmount: String = ""
    
    var body: some View {
        NavigationView {
            ZStack {
                // 배경 그라데이션
                LinearGradient(
                    gradient: Gradient(colors: [Color(hex: "#FCF2D9"), Color(hex: "#EEDCC6")]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 30) {
                        // 즐겨찾기 섹션
                        if !tracker.favorites.isEmpty {
                            VStack(alignment: .leading, spacing: 15) {
                                Text("⭐ 즐겨찾기")
                                    .font(.system(size: 18, weight: .bold))
                                    .foregroundColor(Color(hex: "#230C02"))
                                    .padding(.bottom, 10)
                                    .overlay(
                                        Rectangle()
                                            .frame(height: 2)
                                            .foregroundColor(Color(hex: "#EEDCC6")),
                                        alignment: .bottom
                                    )
                                
                                LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
                                    ForEach(tracker.favorites) { drink in
                                        DrinkButton(drink: drink) {
                                            selectedAmount = drink.amount
                                            selectedDrinkName = drink.name
                                            showTimeModal = true
                                        }
                                    }
                                }
                            }
                        }
                        
                        // 커피 섹션
                        DrinkCategoryView(
                            title: "☕ 커피",
                            drinks: Drink.drinkDatabase.filter { $0.category == "커피" }
                        ) { drink in
                            selectedAmount = drink.amount
                            selectedDrinkName = drink.name
                            showTimeModal = true
                        }
                        
                        // 기타 음료 섹션
                        DrinkCategoryView(
                            title: "🥤 기타 음료",
                            drinks: Drink.drinkDatabase.filter { $0.category == "기타" }
                        ) { drink in
                            selectedAmount = drink.amount
                            selectedDrinkName = drink.name
                            showTimeModal = true
                        }
                        
                        // 직접 입력 섹션
                        VStack(alignment: .leading, spacing: 15) {
                            Text("✏️ 직접 입력")
                                .font(.system(size: 18, weight: .bold))
                                .foregroundColor(Color(hex: "#230C02"))
                                .padding(.bottom, 10)
                                .overlay(
                                    Rectangle()
                                        .frame(height: 2)
                                        .foregroundColor(Color(hex: "#EEDCC6")),
                                    alignment: .bottom
                                )
                            
                            VStack(spacing: 12) {
                                TextField("카페인 양을 입력하세요 (mg)", text: $customAmount)
                                    .keyboardType(.numberPad)
                                    .padding(16)
                                    .background(Color(hex: "#FFF5E9"))
                                    .cornerRadius(16)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 16)
                                            .stroke(Color(hex: "#EEDCC6"), lineWidth: 2)
                                    )
                                
                                Button(action: {
                                    if let amount = Int(customAmount), amount > 0 && amount <= 500 {
                                        selectedAmount = amount
                                        selectedDrinkName = "\(amount)mg"
                                        showTimeModal = true
                                        customAmount = ""
                                    }
                                }) {
                                    Text("추가")
                                        .font(.system(size: 18, weight: .semibold))
                                        .foregroundColor(Color(hex: "#FFF5E9"))
                                        .frame(maxWidth: .infinity)
                                        .padding(.vertical, 16)
                                        .background(
                                            LinearGradient(
                                                gradient: Gradient(colors: [Color(hex: "#EEDCC6"), Color(hex: "#230C02")]),
                                                startPoint: .leading,
                                                endPoint: .trailing
                                            )
                                        )
                                        .cornerRadius(16)
                                        .shadow(color: Color.black.opacity(0.2), radius: 6, x: 0, y: 4)
                                }
                            }
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 20)
                    .padding(.bottom, 40)
                }
            }
            .navigationTitle("카페인 추가")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: { dismiss() }) {
                        Image(systemName: "chevron.left")
                            .foregroundColor(Color(hex: "#230C02"))
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { showSearch = true }) {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(Color(hex: "#230C02"))
                    }
                }
            }
        }
        .sheet(isPresented: $showSearch) {
            SearchView(tracker: tracker) { drink in
                selectedAmount = drink.amount
                selectedDrinkName = drink.name
                showSearch = false
                showTimeModal = true
            }
        }
        .sheet(isPresented: $showTimeModal) {
            TimeModalView(
                drinkName: selectedDrinkName,
                amount: selectedAmount,
                tracker: tracker,
                onConfirm: { timestamp in
                    tracker.addCaffeine(amount: selectedAmount, timestamp: timestamp)
                    dismiss()
                }
            )
        }
    }
}

struct DrinkCategoryView: View {
    let title: String
    let drinks: [Drink]
    let onSelect: (Drink) -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            Text(title)
                .font(.system(size: 18, weight: .bold))
                .foregroundColor(Color(hex: "#230C02"))
                .padding(.bottom, 10)
                .overlay(
                    Rectangle()
                        .frame(height: 2)
                        .foregroundColor(Color(hex: "#EEDCC6")),
                    alignment: .bottom
                )
            
            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
                ForEach(drinks) { drink in
                    DrinkButton(drink: drink) {
                        onSelect(drink)
                    }
                }
            }
        }
    }
}

struct DrinkButton: View {
    let drink: Drink
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 8) {
                Text(drink.icon)
                    .font(.system(size: 32))
                Text(drink.name)
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundColor(Color(hex: "#230C02"))
                Text("\(drink.amount)mg")
                    .font(.system(size: 13))
                    .foregroundColor(Color(hex: "#8B6F47"))
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 20)
            .padding(.horizontal, 16)
            .background(Color(hex: "#FFF5E9"))
            .cornerRadius(16)
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(Color(hex: "#EEDCC6"), lineWidth: 2)
            )
            .shadow(color: Color.black.opacity(0.05), radius: 2, x: 0, y: 2)
        }
    }
}

// 검색 뷰
struct SearchView: View {
    @ObservedObject var tracker: CaffeineTracker
    @Environment(\.dismiss) var dismiss
    let onSelect: (Drink) -> Void
    @State private var searchText = ""
    
    var filteredDrinks: [Drink] {
        if searchText.isEmpty {
            return Drink.drinkDatabase
        }
        return Drink.drinkDatabase.filter {
            $0.name.localizedCaseInsensitiveContains(searchText) ||
            $0.category.localizedCaseInsensitiveContains(searchText)
        }
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                LinearGradient(
                    gradient: Gradient(colors: [Color(hex: "#FCF2D9"), Color(hex: "#EEDCC6")]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()
                
                VStack {
                    TextField("음료 검색...", text: $searchText)
                        .padding(12)
                        .background(Color(hex: "#FCF2D9"))
                        .cornerRadius(12)
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(Color(hex: "#EEDCC6"), lineWidth: 2)
                        )
                        .padding(.horizontal, 20)
                        .padding(.top, 20)
                    
                    if filteredDrinks.isEmpty {
                        Text("검색 결과가 없습니다")
                            .font(.system(size: 16))
                            .foregroundColor(Color(hex: "#8B6F47"))
                            .padding(.top, 40)
                        Spacer()
                    } else {
                        ScrollView {
                            LazyVStack(spacing: 12) {
                                ForEach(filteredDrinks) { drink in
                                    SearchResultItem(drink: drink, tracker: tracker) {
                                        onSelect(drink)
                                        dismiss()
                                    }
                                }
                            }
                            .padding(.horizontal, 20)
                            .padding(.top, 20)
                        }
                    }
                }
            }
            .navigationTitle("검색")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: { dismiss() }) {
                        Image(systemName: "chevron.left")
                            .foregroundColor(Color(hex: "#230C02"))
                    }
                }
            }
        }
    }
}

struct SearchResultItem: View {
    let drink: Drink
    @ObservedObject var tracker: CaffeineTracker
    let onSelect: () -> Void
    
    var body: some View {
        HStack(spacing: 12) {
            Button(action: onSelect) {
                HStack(spacing: 12) {
                    Text(drink.icon)
                        .font(.system(size: 32))
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text(drink.name)
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(Color(hex: "#230C02"))
                        Text("\(drink.amount)mg · \(drink.category)")
                            .font(.system(size: 14))
                            .foregroundColor(Color(hex: "#8B6F47"))
                    }
                    
                    Spacer()
                }
            }
            
            Button(action: {
                tracker.toggleFavorite(drink)
            }) {
                Text(tracker.isFavorite(drink) ? "⭐" : "☆")
                    .font(.system(size: 20))
                    .frame(width: 40, height: 40)
                    .background(tracker.isFavorite(drink) ? Color(hex: "#FFF5E9") : Color(hex: "#FCF2D9"))
                    .cornerRadius(8)
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(tracker.isFavorite(drink) ? Color(hex: "#230C02") : Color(hex: "#EEDCC6"), lineWidth: 2)
                    )
            }
        }
        .padding(16)
        .background(Color(hex: "#FFF5E9"))
        .cornerRadius(16)
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(Color(hex: "#EEDCC6"), lineWidth: 2)
        )
    }
}

// 시간 선택 모달
struct TimeModalView: View {
    let drinkName: String
    let amount: Int
    @ObservedObject var tracker: CaffeineTracker
    @Environment(\.dismiss) var dismiss
    @State private var timeOption: TimeOption = .now
    @State private var customDate = Date()
    @State private var customTime = Date()
    
    enum TimeOption {
        case now, custom
    }
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                Text("\(drinkName) - 섭취 시간 선택")
                    .font(.system(size: 20, weight: .bold))
                    .foregroundColor(Color(hex: "#230C02"))
                    .padding(.top, 20)
                
                VStack(spacing: 12) {
                    RadioButton(
                        title: "⏰ 지금",
                        isSelected: timeOption == .now,
                        action: { timeOption = .now }
                    )
                    
                    RadioButton(
                        title: "📅 직접 선택",
                        isSelected: timeOption == .custom,
                        action: { timeOption = .custom }
                    )
                }
                
                if timeOption == .custom {
                    VStack(spacing: 12) {
                        DatePicker("날짜", selection: $customDate, displayedComponents: .date)
                            .datePickerStyle(.compact)
                        
                        DatePicker("시간", selection: $customTime, displayedComponents: .hourAndMinute)
                            .datePickerStyle(.compact)
                    }
                    .padding(16)
                    .background(Color(hex: "#FCF2D9"))
                    .cornerRadius(12)
                }
                
                Spacer()
                
                HStack(spacing: 12) {
                    Button(action: { dismiss() }) {
                        Text("취소")
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(Color(hex: "#230C02"))
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 14)
                            .background(Color(hex: "#FCF2D9"))
                            .cornerRadius(12)
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(Color(hex: "#EEDCC6"), lineWidth: 2)
                            )
                    }
                    
                    Button(action: {
                        let timestamp: TimeInterval
                        if timeOption == .now {
                            timestamp = Date().timeIntervalSince1970
                        } else {
                            let calendar = Calendar.current
                            let dateComponents = calendar.dateComponents([.year, .month, .day], from: customDate)
                            let timeComponents = calendar.dateComponents([.hour, .minute], from: customTime)
                            var combinedComponents = DateComponents()
                            combinedComponents.year = dateComponents.year
                            combinedComponents.month = dateComponents.month
                            combinedComponents.day = dateComponents.day
                            combinedComponents.hour = timeComponents.hour
                            combinedComponents.minute = timeComponents.minute
                            if let combinedDate = calendar.date(from: combinedComponents) {
                                timestamp = combinedDate.timeIntervalSince1970
                            } else {
                                timestamp = Date().timeIntervalSince1970
                            }
                        }
                        onConfirm(timestamp)
                        dismiss()
                    }) {
                        Text("확인")
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(Color(hex: "#FFF5E9"))
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 14)
                            .background(
                                LinearGradient(
                                    gradient: Gradient(colors: [Color(hex: "#EEDCC6"), Color(hex: "#230C02")]),
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                            .cornerRadius(12)
                            .shadow(color: Color.black.opacity(0.2), radius: 4, x: 0, y: 2)
                    }
                }
            }
            .padding(20)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("닫기") { dismiss() }
                }
            }
        }
    }
    
    let onConfirm: (TimeInterval) -> Void
}

struct RadioButton: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack {
                Text(title)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(Color(hex: "#230C02"))
                Spacer()
            }
            .padding(16)
            .background(isSelected ? Color(hex: "#FCF2D9") : Color(hex: "#FFF5E9"))
            .cornerRadius(12)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(isSelected ? Color(hex: "#230C02") : Color(hex: "#EEDCC6"), lineWidth: 2)
            )
        }
    }
}

