////
////  ScheduleService.swift
////  CoffeePrincess
////
////  Created by 김나영 on 11/16/25.
////
//
//import Foundation
//import Moya
//import Combine
//
///// 일정 관련 API 요청을 담당하는 서비스
//final class ScheduleService {
//    
//    // ScheduleAPI를 사용하는 Moya Provider 인스턴스
//    private let provider: MoyaProvider<ScheduleAPI>
//    
//    // MARK: - Initializer
//    
//    init(provider: MoyaProvider<ScheduleAPI> = MoyaProvider<ScheduleAPI>()) {
//        self.provider = provider
//    }
//    
//    // MARK: - API Methods (with Completion Handler)
//    
//    /// (POST) 일정을 서버에 추가합니다.
//    /// - Parameters:
//    ///   - record: `ScheduleRecord` (보낼 데이터)
//    ///   - completion: `(Result<Void, Error>) -> Void`
//    func addSchedule(_ record: ScheduleRecord, completion: @escaping (Result<Void, Error>) -> Void) {
//        
//        provider.request(.addSchedule(record: record)) { result in
//            switch result {
//            case .success(let response):
//                do {
//                    // 1. (가정) POST 성공 시 "results": {} 를 반환
//                    let apiResponse = try JSONDecoder().decode(APIResponse<EmptyResponse>.self, from: response.data)
//                    
//                    if apiResponse.isSuccess {
//                        completion(.success(())) // 2. 성공 (Void)
//                    } else {
//                        // 3. 서버 비즈니스 에러
//                        let error = NSError(domain: "ScheduleService", code: 0, userInfo: [NSLocalizedDescriptionKey: apiResponse.message])
//                        completion(.failure(error))
//                    }
//                } catch {
//                    completion(.failure(error)) // 4. JSON 디코딩 실패
//                }
//                
//            case .failure(let error):
//                completion(.failure(error)) // 5. 네트워크 실패
//            }
//        }
//    }
//    
//    /// (GET) 특정 날짜의 일정을 조회합니다.
//    /// - Parameters:
//    ///   - date: "YYYY-MM-DD" 형식의 날짜
//    ///   - completion: `(Result<ScheduleListResponse, Error>) -> Void`
//    func getSchedule(date: String, completion: @escaping (Result<ScheduleListResponse, Error>) -> Void) {
//        
//        provider.request(.getSchedule(date: date)) { result in
//            switch result {
//            case .success(let response):
//                do {
//                    // 1. GET 성공 시 "results": { ... } (ScheduleListResponse) 를 반환
//                    let apiResponse = try JSONDecoder().decode(APIResponse<ScheduleListResponse>.self, from: response.data)
//                    
//                    if apiResponse.isSuccess {
//                        completion(.success(apiResponse.results)) // 2. 'results' (ScheduleListResponse) 반환
//                    } else {
//                        // 3. 서버 비즈니스 에러
//                        let error = NSError(domain: "ScheduleService", code: 0, userInfo: [NSLocalizedDescriptionKey: apiResponse.message])
//                        completion(.failure(error))
//                    }
//                } catch {
//                    completion(.failure(error)) // 4. JSON 디코딩 실패
//                }
//                
//            case .failure(let error):
//                completion(.failure(error)) // 5. 네트워크 실패
//            }
//        }
//    }
//    
//    // MARK: - API Methods (with Combine)
//    
//    /// (POST) Combine을 사용하여 일정을 추가합니다.
//    @available(iOS 13.0, *)
//    func addScheduleWithCombine(_ record: ScheduleRecord) -> AnyPublisher<Void, Error> {
//        return provider.requestPublisher(.addSchedule(record: record))
//            .map(\.data)
//            .decode(type: APIResponse<EmptyResponse>.self, decoder: JSONDecoder())
//            .tryMap { apiResponse -> Void in
//                if apiResponse.isSuccess {
//                    return ()
//                } else {
//                    throw NSError(domain: "ScheduleService", code: 0, userInfo: [NSLocalizedDescriptionKey: apiResponse.message])
//                }
//            }
//            .eraseToAnyPublisher()
//    }
//    
//    /// (GET) Combine을 사용하여 특정 날짜의 일정을 조회합니다.
//    @available(iOS 13.0, *)
//    func getScheduleWithCombine(date: String) -> AnyPublisher<ScheduleListResponse, Error> {
//        return provider.requestPublisher(.getSchedule(date: date))
//            .map(\.data)
//            .decode(type: APIResponse<ScheduleListResponse>.self, decoder: JSONDecoder())
//            .tryMap { apiResponse -> ScheduleListResponse in
//                if apiResponse.isSuccess {
//                    return apiResponse.results
//                } else {
//                    throw NSError(domain: "ScheduleService", code: 0, userInfo: [NSLocalizedDescriptionKey: apiResponse.message])
//                }
//            }
//            .eraseToAnyPublisher()
//    }
//}
