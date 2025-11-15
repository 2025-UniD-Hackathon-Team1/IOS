//
//  UserService.swift
//  CoffeePrincess
//
//  Created by 김나영 on 11/16/25.
//

import Foundation
import Moya
import Combine

/// 사용자 정보 관련 API 요청을 담당하는 서비스
final class UserService {
    
    // UserAPI를 사용하는 Moya Provider 인스턴스
    private let provider: MoyaProvider<UserAPI>
    
    // MARK: - Initializer
    
    /// provider를 주입받아 초기화합니다.
    /// - Parameter provider: 사용할 MoyaProvider. 기본값은 일반 provider입니다.
    init(provider: MoyaProvider<UserAPI> = MoyaProvider<UserAPI>()) {
        self.provider = provider
    }
    
    // MARK: - API Methods (with Completion Handler)
    
    /// (GET) 사용자 정보를 서버에서 가져옵니다.
    func getUserInfo(completion: @escaping (Result<UserInfo, Error>) -> Void) {
        
        provider.request(.getUserInfo) { result in
            switch result {
            case .success(let response):
                do {
                    // 1. 공통 응답(APIResponse)으로 디코딩 (T = UserInfo)
                    let apiResponse = try JSONDecoder().decode(APIResponse<UserInfo>.self, from: response.data)
                    
                    if apiResponse.isSuccess {
                        // 2. 성공 시 'results' (UserInfo) 반환
                        completion(.success(apiResponse.results))
                    } else {
                        // 3. 서버 비즈니스 에러
                        let error = NSError(domain: "UserService", code: 0, userInfo: [NSLocalizedDescriptionKey: apiResponse.message])
                        completion(.failure(error))
                    }
                } catch {
                    // 4. JSON 디코딩 실패
                    completion(.failure(error))
                }
                
            case .failure(let error):
                // 5. 네트워크 실패
                completion(.failure(error))
            }
        }
    }
    
    /// (POST) 사용자 정보를 서버에 업데이트합니다.
    /// 성공 시 응답 바디가 비어있으므로 Void를 반환합니다.
    func updateUserInfo(userInfo: UserInfo, completion: @escaping (Result<Void, Error>) -> Void) {
        
        provider.request(.updateUserInfo(userInfo: userInfo)) { result in
            switch result {
            case .success(let response):
                do {
                    // 1. 공통 응답(APIResponse)으로 디코딩 (T = EmptyResponse)
                    let apiResponse = try JSONDecoder().decode(APIResponse<EmptyResponse>.self, from: response.data)
                    
                    if apiResponse.isSuccess {
                        // 2. 성공 시 'results'가 비어있으므로, 성공 자체(Void)를 알림
                        completion(.success(()))
                    } else {
                        // 3. 서버 비즈니스 에러
                        let error = NSError(domain: "UserService", code: 0, userInfo: [NSLocalizedDescriptionKey: apiResponse.message])
                        completion(.failure(error))
                    }
                } catch {
                    // 4. JSON 디코딩 실패
                    completion(.failure(error))
                }
                
            case .failure(let error):
                // 5. 네트워크 실패
                completion(.failure(error))
            }
        }
    }
    
    // MARK: - API Methods (with Combine)
    
    /// (GET) Combine을 사용하여 사용자 정보를 가져옵니다.
    @available(iOS 13.0, *)
    func getUserInfoWithCombine() -> AnyPublisher<UserInfo, Error> {
        return provider.requestPublisher(.getUserInfo)
            .map(\.data) // 1. Data 추출
            .decode(type: APIResponse<UserInfo>.self, decoder: JSONDecoder()) // 2. 공통 응답 디코딩
            .tryMap { apiResponse -> UserInfo in
                if apiResponse.isSuccess {
                    return apiResponse.results // 3. 성공 시 UserInfo 반환
                } else {
                    // 4. 서버 에러
                    throw NSError(domain: "UserService", code: 0, userInfo: [NSLocalizedDescriptionKey: apiResponse.message])
                }
            }
            .eraseToAnyPublisher()
    }
    
    /// (POST) Combine을 사용하여 사용자 정보를 업데이트합니다.
    @available(iOS 13.0, *)
    func updateUserInfoWithCombine(userInfo: UserInfo) -> AnyPublisher<Void, Error> {
        return provider.requestPublisher(.updateUserInfo(userInfo: userInfo))
            .map(\.data) // 1. Data 추출
            .decode(type: APIResponse<EmptyResponse>.self, decoder: JSONDecoder()) // 2. 공통 응답 디코딩
            .tryMap { apiResponse -> Void in
                if apiResponse.isSuccess {
                    return () // 3. 성공 시 Void 반환
                } else {
                    // 4. 서버 에러
                    throw NSError(domain: "UserService", code: 0, userInfo: [NSLocalizedDescriptionKey: apiResponse.message])
                }
            }
            .eraseToAnyPublisher()
    }
}
