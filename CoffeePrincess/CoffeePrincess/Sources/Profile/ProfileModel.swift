

import Foundation

struct UserInfo: Codable {
    var tolerance: Int = 50         // 카페인 민감도 (0-100)
    var heartRate: String = "often"      // 심장 박동 경험 (often, sometimes, rarely, never)
    var bedtime: String = "23:30"   // 평소 잠드는 시간
    var wakeTime: String = "07:30"  // 평소 일어나는 시간
    var importantTimes: [String] = [] // 중요 일정 시간대
    var targetSleep: Double = 7.5   // 목표 수면 시간 (시간)
    var maxCaffeine: Int = 140      // 1일 최대 카페인 제한치
    var step: Int = 0               // 온보딩 단계
    var completed: Bool = false     // 온보딩 완료 여부
    var timestamp: TimeInterval = Date().timeIntervalSince1970
}
