//
//  AuthService.swift
//  CoffeePrincess
//
//  Created by 김나영 on 11/16/25.
//

import Foundation
import Moya
import Combine

/// 인증 관련 API 요청을 담당하는 서비스 클래스
final class AuthService {
    
    // AuthAPI를 사용하는 Moya Provider 인스턴스
    private let provider: MoyaProvider<AuthAPI>
    
    // MARK: - Initializer
    
    /// provider를 주입받아 초기화합니다.
    /// - Parameter provider: 사용할 MoyaProvider. 기본값은 일반 provider입니다.
    init(provider: MoyaProvider<AuthAPI> = MoyaProvider<AuthAPI>()) {
        self.provider = provider
    }
    
    // MARK: - API Methods (with Completion Handler)
    
    /// 로그인을 요청하고 결과를 클로저(콜백)로 반환합니다.
    /// - Parameters:
    ///   - username: 사용자 ID
    ///   - password: 비밀번호
    ///   - completion: (Result<LoginResponse, Error>) -> Void
    func login(
        username: String,
        password: String,
        completion: @escaping (Result<LoginResponse, Error>) -> Void
    ) {
        provider.request(.login(username: username, password: password)) { result in
            switch result {
            case .success(let response):
                // HTTP 성공 (200대 응답 등)
                do {
                    // 1. 공통 응답 모델(APIResponse)로 먼저 디코딩
                    let apiResponse = try JSONDecoder().decode(APIResponse<LoginResponse>.self, from: response.data)
                    
                    // 2. 서버가 정의한 비즈니스 로직 성공(isSuccess)인지 확인
                    if apiResponse.isSuccess {
                        AuthManager.shared.saveToken(apiResponse.results.accessToken)
                        // 성공 시 'results'에 담겨있는 LoginResponse를 전달
                        completion(.success(apiResponse.results))
                    } else {
                        // 서버가 에러를 반환한 경우 (예: "REQUEST_FAILED")
                        let error = NSError(domain: "AuthService", code: 0, userInfo: [NSLocalizedDescriptionKey: apiResponse.message])
                        completion(.failure(error))
                    }
                } catch {
                    // 3. JSON 디코딩 자체에 실패한 경우
                    completion(.failure(error))
                }
                
            case .failure(let error):
                // 4. 네트워크 실패 (Moya Error)
                completion(.failure(error))
            }
        }
    }
    
    // MARK: - API Methods (with Combine)
    
    /// Combine을 사용하여 로그인을 요청합니다.
    /// - Returns: AnyPublisher<LoginResponse, Error>
    @available(iOS 13.0, *)
    func loginWithCombine(
        username: String,
        password: String
    ) -> AnyPublisher<LoginResponse, Error> {
        return provider.requestPublisher(.login(username: username, password: password))
            .tryMap { response -> Data in
                // 1. 응답 데이터를 받음
                return response.data
            }
            .decode(type: APIResponse<LoginResponse>.self, decoder: JSONDecoder()) // 2. 공통 응답으로 디코딩
            .tryMap { apiResponse -> LoginResponse in
                // 3. 비즈니스 로직 성공 여부 확인
                if apiResponse.isSuccess {
                    return apiResponse.results // 4. 성공 시 LoginResponse 반환
                } else {
                    // 5. 서버 에러 시 Error throw
                    throw NSError(domain: "AuthService", code: 0, userInfo: [NSLocalizedDescriptionKey: apiResponse.message])
                }
            }
            .eraseToAnyPublisher() // 6. 최종 타입으로 변환하여 반환
    }
}
