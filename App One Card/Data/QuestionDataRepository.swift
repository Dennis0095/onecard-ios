//
//  QuestionDataRepository.swift
//  App One Card
//
//  Created by Paolo Arambulo on 18/08/23.
//

import Combine

class QuestionDataRepository: QuestionRepository {
    func consult(request: ConsultFrequentQuestionsRequest) -> AnyPublisher<ConsultFrequentQuestionsResponse, APIError> {
        return APIClient.callAPI(route: .consultFrequentQuestions, method: .post, request: request)
    }
}
