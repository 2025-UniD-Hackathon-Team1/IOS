//
//  CoffeeService.swift
//  CoffeePrincess
//
//  Created by 김나영 on 11/16/25.
//

import Foundation
import Moya
import Combine

/// 커피 기록 관련 API 요청을 담당하는 서비스
final class CoffeeService {
    // CoffeeAPI를 사용하는 Moya Provider 인스턴스
    private let provider: MoyaProvider<CoffeeAPI>
    
    // MARK: - Initializer
    
    init(provider: MoyaProvider<CoffeeAPI> = MoyaProvider<CoffeeAPI>()) {
        self.provider = provider
    }
    
    // MARK: - API Methods (with Completion Handler)
    
    /// (POST) 커피 기록을 서버에 추가합니다.
    /// - Parameters:
    ///   - record: C`offeeRecord` (보낼 데이터)
    ///   - completion: `(Result<Void, Error>) -> Void`
    func addCoffeeRecord(_ record: CoffeeRecord, completion: @escaping (Result<Void, Error>) -> Void) {
        
        provider.request(.addCoffee(record: record)) { result in
            switch result {
            case .success(let response):
                do {
                    // 1. (가정) POST 성공 시 "results": {} 를 반환
                    let apiResponse = try JSONDecoder().decode(APIResponse<EmptyResponse>.self, from: response.data)
                    
                    if apiResponse.isSuccess {
                        completion(.success(())) // 2. 성공 (Void)
                    } else {
                        // 3. 서버 비즈니스 에러
                        let error = NSError(domain: "CoffeeService", code: 0, userInfo: [NSLocalizedDescriptionKey: apiResponse.message])
                        completion(.failure(error))
                    }
                } catch {
                    completion(.failure(error)) // 4. JSON 디코딩 실패
                }
                
            case .failure(let error):
                completion(.failure(error)) // 5. 네트워크 실패
            }
        }
    }
    
    /// (GET) 특정 날짜의 커피 기록을 조회합니다.
    /// - Parameters:
    ///   - date: "YYYY-MM-DD" 형식의 날짜
    ///   - completion: `(Result<TodayCoffeeResponse, Error>) -> Void`
    func getTodayCoffee(date: String, completion: @escaping (Result<TodayCoffeeResponse, Error>) -> Void) {
        
        provider.request(.getTodayCoffee(date: date)) { result in
            switch result {
            case .success(let response):
                do {
                    // 1. GET 성공 시 "results": { ... } (TodayCoffeeResponse) 를 반환
                    let apiResponse = try JSONDecoder().decode(APIResponse<TodayCoffeeResponse>.self, from: response.data)
                    
                    if apiResponse.isSuccess {
                        completion(.success(apiResponse.results)) // 2. 'results' (TodayCoffeeResponse) 반환
                    } else {
                        // 3. 서버 비즈니스 에러
                        let error = NSError(domain: "CoffeeService", code: 0, userInfo: [NSLocalizedDescriptionKey: apiResponse.message])
                        completion(.failure(error))
                    }
                } catch {
                    completion(.failure(error)) // 4. JSON 디코딩 실패
                }
                
            case .failure(let error):
                completion(.failure(error)) // 5. 네트워크 실패
            }
        }
    }
    
    // MARK: - API Methods (with Combine)
    
    /// (POST) Combine을 사용하여 커피 기록을 추가합니다.
    @available(iOS 13.0, *)
    func addCoffeeRecordWithCombine(_ record: CoffeeRecord) -> AnyPublisher<Void, Error> {
        return provider.requestPublisher(.addCoffee(record: record))
            .map(\.data)
            .decode(type: APIResponse<EmptyResponse>.self, decoder: JSONDecoder())
            .tryMap { apiResponse -> Void in
                if apiResponse.isSuccess {
                    return ()
                } else {
                    throw NSError(domain: "CoffeeService", code: 0, userInfo: [NSLocalizedDescriptionKey: apiResponse.message])
                }
            }
            .eraseToAnyPublisher()
    }
    
    /// (GET) Combine을 사용하여 특정 날짜의 커피 기록을 조회합니다.
    @available(iOS 13.0, *)
    func getTodayCoffeeWithCombine(date: String) -> AnyPublisher<TodayCoffeeResponse, Error> {
        return provider.requestPublisher(.getTodayCoffee(date: date))
            .map(\.data)
            .decode(type: APIResponse<TodayCoffeeResponse>.self, decoder: JSONDecoder())
            .tryMap { apiResponse -> TodayCoffeeResponse in
                if apiResponse.isSuccess {
                    return apiResponse.results
                } else {
                    throw NSError(domain: "CoffeeService", code: 0, userInfo: [NSLocalizedDescriptionKey: apiResponse.message])
                }
            }
            .eraseToAnyPublisher()
    }
}

/*
// --- 참고: 필요한 모델들 ---
// 이 모델들이 프로젝트 어딘가에 정의되어 있어야 합니다.

import Foundation

/// 공통 API 응답 래퍼 모델
struct APIResponse<T: Codable>: Codable {
    let isSuccess: Bool
    let code: String
    let message: String
    let results: T
}

/// "results": {} 를 디코딩하기 위한 빈 모델
struct EmptyResponse: Codable {}

// (CoffeeRecord는 이 파일 상단에 정의)
// (TodayCoffeeResponse는 사용자 제공 파일에 정의)
*/
