//
//  QuestionRepository.swift
//  App One Card
//
//  Created by Paolo Arambulo on 18/08/23.
//

import Combine

protocol QuestionRepository {
    func consult(request: ConsultFrequentQuestionsRequest) -> AnyPublisher<ConsultFrequentQuestionsResponse, APIError>
}
