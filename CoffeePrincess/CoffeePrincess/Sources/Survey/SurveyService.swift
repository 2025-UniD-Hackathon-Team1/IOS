//
//  SurveyService.swift
//  CoffeePrincess
//

import Foundation
import Moya

/// 서버에서 내려오는 결과가 `{}` 인 경우용
struct EmptyResults: Codable {}

final class SurveyService {
    
    private let provider: MoyaProvider<SurveyAPI>
    
    init(provider: MoyaProvider<SurveyAPI> = MoyaProvider<SurveyAPI>()) {
        self.provider = provider
    }
    
    /// 설문(피드백) 전송
    func sendSurvey(_ survey: SurveyModel, completion: @escaping (Result<Void, Error>) -> Void) {
        provider.request(.feedback(
            sleepDate: survey.sleepDate,
            sleepTime: survey.sleepTime,
            heartRate: survey.heartRate
        )) { result in
            switch result {
            case .success(let response):
                do {
                    // APIResponse만 사용
                    let apiResponse = try JSONDecoder().decode(APIResponse<EmptyResults>.self, from: response.data)
                    
                    if apiResponse.isSuccess {
                        completion(.success(()))
                    } else {
                        let error = NSError(
                            domain: "SurveyService",
                            code: 0,
                            userInfo: [NSLocalizedDescriptionKey: apiResponse.message]
                        )
                        completion(.failure(error))
                    }
                } catch {
                    completion(.failure(error))
                }
                
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
