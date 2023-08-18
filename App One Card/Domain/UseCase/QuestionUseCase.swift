//
//  QuestionUseCase.swift
//  App One Card
//
//  Created by Paolo Arambulo on 18/08/23.
//

import Combine

protocol QuestionUseCaseProtocol {
    func consult(request: ConsultFrequentQuestionsRequest) -> AnyPublisher<ConsultFrequentQuestionsResponse, APIError>
}

class QuestionUseCase: QuestionUseCaseProtocol {
    
    private let questionRepository: QuestionRepository
    
    init(questionRepository: QuestionRepository) {
        self.questionRepository = questionRepository
    }
    
    func consult(request: ConsultFrequentQuestionsRequest) -> AnyPublisher<ConsultFrequentQuestionsResponse, APIError> {
        return questionRepository.consult(request: request)
    }
}

