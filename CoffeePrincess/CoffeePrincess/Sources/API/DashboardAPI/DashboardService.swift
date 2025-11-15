//
//  DashboardService.swift
//  CoffeePrincess
//
//  Created by 김나영 on 11/16/25.
//

import Foundation
import Moya
import Combine

/// 대시보드 정보 (카페인, 각성) API 요청을 담당하는 서비스
final class DashboardService {
    
    // DashboardAPI를 사용하는 Moya Provider 인스턴스
    private let provider: MoyaProvider<DashboardAPI>
    
    // MARK: - Initializer
    
    init(provider: MoyaProvider<DashboardAPI> = MoyaProvider<DashboardAPI>()) {
        self.provider = provider
    }
    
    // MARK: - Helper
    
    /// "YYYY-MM-DDTHH:mm:ss" 형식의 현재 시간을 반환하는 헬퍼
    /// (서버는 KST 기준, ISO8601DateFormatter는 UTC 기준이므로 KST로 보정)
    private func getCurrentISOString() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        formatter.locale = Locale(identifier: "en_US_POSIX")
         // formatter.timeZone = TimeZone(identifier: "Asia/Seoul") // KST 기준
        return formatter.string(from: Date())
    }

    // MARK: - API Methods (with Completion Handler)
    
    /// (GET) 현재 카페인 정보를 조회합니다.
    /// - Parameter completion: `(Result<CaffeineInfoResponse, Error>) -> Void`
    func getCaffeineInfo(completion: @escaping (Result<CaffeineInfoResponse, Error>) -> Void) {
        
        // 1. 현재 시간 문자열 생성
        let timeString = getCurrentISOString()
        
        // 2. API 호출
        provider.request(.getCaffeineInfo(currentTime: timeString)) { result in
            switch result {
            case .success(let response):
                do {
                    // 3. 공통 응답(APIResponse)으로 디코딩
                    let apiResponse = try JSONDecoder().decode(APIResponse<CaffeineInfoResponse>.self, from: response.data)
                    
                    if apiResponse.isSuccess {
                        completion(.success(apiResponse.results)) // 4. 'results' (CaffeineInfoResponse) 반환
                    } else {
                        // 5. 서버 비즈니스 에러
                        let error = NSError(domain: "DashboardService", code: 0, userInfo: [NSLocalizedDescriptionKey: apiResponse.message])
                        completion(.failure(error))
                    }
                } catch {
                    completion(.failure(error)) // 6. JSON 디코딩 실패
                }
                
            case .failure(let error):
                completion(.failure(error)) // 7. 네트워크 실패
            }
        }
    }
    
    /// (GET) 현재 각성 정보를 조회합니다.
    /// - Parameter completion: `(Result<AlertnessInfoResponse, Error>) -> Void`
    func getAlertnessInfo(completion: @escaping (Result<AlertnessInfoResponse, Error>) -> Void) {
        
        // 1. 현재 시간 문자열 생성
        let timeString = getCurrentISOString()
        
        // 2. API 호출
        provider.request(.getAlertnessInfo(currentTime: timeString)) { result in
            switch result {
            case .success(let response):
                do {
                    // 3. 공통 응답(APIResponse)으로 디코딩
                    let apiResponse = try JSONDecoder().decode(APIResponse<AlertnessInfoResponse>.self, from: response.data)
                    
                    if apiResponse.isSuccess {
                        completion(.success(apiResponse.results)) // 4. 'results' (AlertnessInfoResponse) 반환
                    } else {
                        // 5. 서버 비즈니스 에러
                        let error = NSError(domain: "DashboardService", code: 0, userInfo: [NSLocalizedDescriptionKey: apiResponse.message])
                        completion(.failure(error))
                    }
                } catch {
                    completion(.failure(error)) // 6. JSON 디코딩 실패
                }
                
            case .failure(let error):
                completion(.failure(error)) // 7. 네트워크 실패
            }
        }
    }
    
    // MARK: - API Methods (with Combine)
    
    /// (GET) Combine을 사용하여 현재 카페인 정보를 조회합니다.
    @available(iOS 13.0, *)
    func getCaffeineInfoWithCombine() -> AnyPublisher<CaffeineInfoResponse, Error> {
        let timeString = getCurrentISOString()
        
        return provider.requestPublisher(.getCaffeineInfo(currentTime: timeString))
            .map(\.data)
            .decode(type: APIResponse<CaffeineInfoResponse>.self, decoder: JSONDecoder())
            .tryMap { apiResponse -> CaffeineInfoResponse in
                if apiResponse.isSuccess {
                    return apiResponse.results
                } else {
                    throw NSError(domain: "DashboardService", code: 0, userInfo: [NSLocalizedDescriptionKey: apiResponse.message])
                }
            }
            .eraseToAnyPublisher()
    }
    
    /// (GET) Combine을 사용하여 현재 각성 정보를 조회합니다.
    @available(iOS 13.0, *)
    func getAlertnessInfoWithCombine() -> AnyPublisher<AlertnessInfoResponse, Error> {
        let timeString = getCurrentISOString()
        
        return provider.requestPublisher(.getAlertnessInfo(currentTime: timeString))
            .map(\.data)
            .decode(type: APIResponse<AlertnessInfoResponse>.self, decoder: JSONDecoder())
            .tryMap { apiResponse -> AlertnessInfoResponse in
                if apiResponse.isSuccess {
                    return apiResponse.results
                } else {
                    throw NSError(domain: "DashboardService", code: 0, userInfo: [NSLocalizedDescriptionKey: apiResponse.message])
                }
            }
            .eraseToAnyPublisher()
    }
}
