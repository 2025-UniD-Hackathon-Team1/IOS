//
//  CaffeineTracker.swift
//  cafe_frame
//
//  Created by 김세은 on 11/15/25.
//

import Foundation
import Combine

class CaffeineTracker: ObservableObject {
    @Published var caffeineHistory: [CaffeineEntry] = []
    @Published var favorites: [Drink] = []
    
    private let caffeineHalfLife: Double = 5.0 // 카페인 반감기 (시간)
    private let maxCaffeine: Int = 400 // 권장 최대 카페인 (mg)
    
    private let historyKey = "caffeineData"
    private let favoritesKey = "caffeineFavorites"
    
    init() {
        loadData()
        loadFavorites()
    }
    
    // MARK: - Data Persistence
    func loadData() {
        if let data = UserDefaults.standard.data(forKey: historyKey),
           let decoded = try? JSONDecoder().decode([CaffeineEntry].self, from: data) {
            self.caffeineHistory = decoded
        }
    }
    
    func saveData() {
        if let encoded = try? JSONEncoder().encode(caffeineHistory) {
            UserDefaults.standard.set(encoded, forKey: historyKey)
        }
    }
    
    func loadFavorites() {
        if let data = UserDefaults.standard.data(forKey: favoritesKey),
           let decoded = try? JSONDecoder().decode([Drink].self, from: data) {
            self.favorites = decoded
        }
    }
    
    func saveFavorites() {
        if let encoded = try? JSONEncoder().encode(favorites) {
            UserDefaults.standard.set(encoded, forKey: favoritesKey)
        }
    }
    
    // MARK: - Caffeine Calculations
    func calculateCurrentCaffeine() -> Double {
        let now = Date().timeIntervalSince1970
        var totalCaffeine: Double = 0
        
        for entry in caffeineHistory {
            let hoursElapsed = (now - entry.timestamp) / 3600.0
            if hoursElapsed >= 0 {
                // 지수 감쇠 공식: 초기량 * (1/2)^(경과시간/반감기)
                let remaining = Double(entry.amount) * pow(0.5, hoursElapsed / caffeineHalfLife)
                totalCaffeine += remaining
            }
        }
        
        return max(0, round(totalCaffeine * 10) / 10)
    }
    
    func getTimeSinceLastIntake() -> (hours: Double, timestamp: TimeInterval)? {
        guard !caffeineHistory.isEmpty else { return nil }
        
        let sorted = caffeineHistory.sorted { $0.timestamp > $1.timestamp }
        let lastIntake = sorted[0]
        let now = Date().timeIntervalSince1970
        let hoursElapsed = (now - lastIntake.timestamp) / 3600.0
        
        return (hours: hoursElapsed, timestamp: lastIntake.timestamp)
    }
    
    func getStatus(currentCaffeine: Double) -> (icon: String, text: String, color: String) {
        if currentCaffeine == 0 {
            return ("😴", "정상", "#4ecdc4")
        } else if currentCaffeine < 100 {
            return ("😊", "낮음", "#4ecdc4")
        } else if currentCaffeine < 200 {
            return ("😌", "보통", "#44a08d")
        } else if currentCaffeine < 300 {
            return ("😐", "높음", "#ffa500")
        } else {
            return ("😰", "매우 높음", "#ff6b6b")
        }
    }
    
    func getTodayIntake() -> Int {
        let today = Calendar.current.startOfDay(for: Date())
        let todayStart = today.timeIntervalSince1970
        
        return caffeineHistory
            .filter { $0.timestamp >= todayStart }
            .reduce(0) { $0 + $1.amount }
    }
    
    func getWeeklyData() -> [(date: Date, intake: Int)] {
        var weekData: [(date: Date, intake: Int)] = []
        let now = Date()
        
        for i in 0...6 {
            if let date = Calendar.current.date(byAdding: .day, value: -i, to: now) {
                let dayStart = Calendar.current.startOfDay(for: date).timeIntervalSince1970
                let dayEnd = dayStart + 24 * 60 * 60
                
                let dayIntake = caffeineHistory
                    .filter { $0.timestamp >= dayStart && $0.timestamp < dayEnd }
                    .reduce(0) { $0 + $1.amount }
                
                weekData.append((date: date, intake: dayIntake))
            }
        }
        
        return weekData.reversed()
    }
    
    func getMonthlyData() -> [(date: Date, intake: Int)] {
        var monthData: [(date: Date, intake: Int)] = []
        let now = Date()
        
        for i in 0...29 {
            if let date = Calendar.current.date(byAdding: .day, value: -i, to: now) {
                let dayStart = Calendar.current.startOfDay(for: date).timeIntervalSince1970
                let dayEnd = dayStart + 24 * 60 * 60
                
                let dayIntake = caffeineHistory
                    .filter { $0.timestamp >= dayStart && $0.timestamp < dayEnd }
                    .reduce(0) { $0 + $1.amount }
                
                monthData.append((date: date, intake: dayIntake))
            }
        }
        
        return monthData.reversed()
    }
    
    // MARK: - Actions
    func addCaffeine(amount: Int, timestamp: TimeInterval? = nil) {
        let entry = CaffeineEntry(
            amount: amount,
            timestamp: timestamp ?? Date().timeIntervalSince1970
        )
        caffeineHistory.append(entry)
        saveData()
        cleanOldData()
    }
    
    func cleanOldData() {
        let thirtyDaysAgo = Date().timeIntervalSince1970 - (30 * 24 * 60 * 60)
        caffeineHistory = caffeineHistory.filter { $0.timestamp >= thirtyDaysAgo }
        saveData()
    }
    
    // MARK: - Favorites
    func isFavorite(_ drink: Drink) -> Bool {
        favorites.contains { $0.name == drink.name }
    }
    
    func toggleFavorite(_ drink: Drink) {
        if let index = favorites.firstIndex(where: { $0.name == drink.name }) {
            favorites.remove(at: index)
        } else {
            favorites.append(drink)
        }
        saveFavorites()
    }
    
    func getTodayDrinks() -> [CaffeineEntry] {
        let today = Calendar.current.startOfDay(for: Date())
        let todayStart = today.timeIntervalSince1970
        let todayEnd = todayStart + 24 * 60 * 60
        
        return caffeineHistory
            .filter { $0.timestamp >= todayStart && $0.timestamp < todayEnd }
            .sorted { $0.timestamp > $1.timestamp }
    }
    
    func getCaffeinePercentage() -> Double {
        let current = calculateCurrentCaffeine()
        return min(100, (current / Double(maxCaffeine)) * 100)
    }
    
    func getEnergyLevel() -> Double {
        let caffeinePercentage = getCaffeinePercentage()
        return min(100, max(0, caffeinePercentage * 0.8 + 20))
    }
    
    func getAwakeEndTime() -> Date? {
        guard getTimeSinceLastIntake() != nil,
              calculateCurrentCaffeine() > 0 else {
            return nil
        }
        
        let currentCaffeine = calculateCurrentCaffeine()
        let hoursUntilEnd = caffeineHalfLife * log2(currentCaffeine / 10)
        return Date().addingTimeInterval(hoursUntilEnd * 60 * 60)
    }
    
    func getSleepDisruptionProbability(userBedtime: String) -> Int {
        guard let timeSince = getTimeSinceLastIntake() else {
            return 0
        }
        
        let components = userBedtime.split(separator: ":")
        guard components.count == 2,
              let bedHour = Int(components[0]),
              let bedMin = Int(components[1]) else {
            return 0
        }
        
        var bedtime = Calendar.current.date(bySettingHour: bedHour, minute: bedMin, second: 0, of: Date()) ?? Date()
        if bedtime < Date() {
            bedtime = Calendar.current.date(byAdding: .day, value: 1, to: bedtime) ?? bedtime
        }
        
        let hoursUntilBedtime = (bedtime.timeIntervalSince1970 - timeSince.timestamp) / 3600.0
        if hoursUntilBedtime < 8 {
            return min(100, max(0, Int(100 - (hoursUntilBedtime / 8) * 100)))
        }
        
        return 0
    }
}

