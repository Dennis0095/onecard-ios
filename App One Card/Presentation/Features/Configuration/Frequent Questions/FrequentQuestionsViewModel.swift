//
//  FrequentQuestionsViewModel.swift
//  App One Card
//
//  Created by Paolo Arambulo on 18/08/23.
//

import Combine
import UIKit

protocol FrequentQuestionsViewModelProtocol {
    var categories: [QuestionCategoryResponse] { get set }
    var delegate: FrequentQuestionsViewModelDelegate? { get set }
    
    func numberOfSections() -> Int
    func numberOfItemsBySection(section: Int) -> Int
    func category(at index: Int) -> QuestionCategoryResponse
    func question(indexPath: IndexPath) -> QuestionResponse
    func isLast(at index: Int) -> Bool
    func fetchFrequentQuestions()
}

protocol FrequentQuestionsViewModelDelegate: LoaderDisplaying {
    func showQuestions()
}

class FrequentQuestionsViewModel: FrequentQuestionsViewModelProtocol {
    private let questionUseCase: QuestionUseCaseProtocol
    private var cancellables = Set<AnyCancellable>()
    
    var categories: [QuestionCategoryResponse] = []
    var profileRouter: ProfileRouterDelegate
    var delegate: FrequentQuestionsViewModelDelegate?
    
    init(profileRouter: ProfileRouterDelegate, questionUseCase: QuestionUseCaseProtocol) {
        self.questionUseCase = questionUseCase
        self.profileRouter = profileRouter
    }
    
    deinit {
        cancelRequests()
    }
    
    func numberOfSections() -> Int {
        return categories.count
    }
    
    func numberOfItemsBySection(section: Int) -> Int {
        return categories[section].questions?.count ?? 0
    }
    
    func category(at index: Int) -> QuestionCategoryResponse {
        return categories[index]
    }
    
    func question(indexPath: IndexPath) -> QuestionResponse {
        return (categories[indexPath.section].questions ?? [])[indexPath.row]
    }
    
    func isLast(at index: Int) -> Bool {
        return (categories.count - 1) == index
    }
    
    func fetchFrequentQuestions() {
        delegate?.showLoader()
        
        let trackingCode = UserSessionManager.shared.getUser()?.authTrackingCode ?? ""
        let request = ConsultFrequentQuestionsRequest(authTrackingCode: trackingCode)
        let cancellable = questionUseCase.consult(request: request)
            .sink { publisher in
                switch publisher {
                case .finished: break
                case .failure(let apiError):
                    let error = apiError.error()
                    
                    self.delegate?.hideLoader()
                    self.delegate?.showError(title: error.title, description: error.description) {
                        switch apiError {
                        case .expiredSession:
                            self.profileRouter.logout(isManual: false)
                        default: break
                        }
                    }
                }
            } receiveValue: { response in
                self.delegate?.hideLoader()
                self.categories = response.categories ?? []
                self.delegate?.showQuestions()
            }
        cancellable.store(in: &cancellables)
    }
    
    func cancelRequests() {
        cancellables.forEach { $0.cancel() }
        cancellables.removeAll()
    }
}
