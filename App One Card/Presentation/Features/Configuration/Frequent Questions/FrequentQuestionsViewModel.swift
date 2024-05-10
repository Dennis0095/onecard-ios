//
//  FrequentQuestionsViewModel.swift
//  App One Card
//
//  Created by Paolo Arambulo on 18/08/23.
//

import Combine

protocol FrequentQuestionsViewModelProtocol {
    var items: [QuestionResponse] { get set }
    var delegate: FrequentQuestionsViewModelDelegate? { get set }
    
    func numberOfItems() -> Int
    func item(at index: Int) -> QuestionResponse
    func isLast(at index: Int) -> Bool
    func fetchFrequentQuestions()
}

protocol FrequentQuestionsViewModelDelegate: LoaderDisplaying {
    func showQuestions()
}

class FrequentQuestionsViewModel: FrequentQuestionsViewModelProtocol {
    private let questionUseCase: QuestionUseCaseProtocol
    private var cancellables = Set<AnyCancellable>()
    
    var items: [QuestionResponse] = []
    var profileRouter: ProfileRouterDelegate
    var delegate: FrequentQuestionsViewModelDelegate?
    
    init(profileRouter: ProfileRouterDelegate, questionUseCase: QuestionUseCaseProtocol) {
        self.questionUseCase = questionUseCase
        self.profileRouter = profileRouter
    }
    
    deinit {
        cancelRequests()
    }
    
    func numberOfItems() -> Int {
        return items.count
    }
    
    func item(at index: Int) -> QuestionResponse {
        return items[index]
    }
    
    func isLast(at index: Int) -> Bool {
        return (items.count - 1) == index
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
                self.items = response.questions ?? []
                self.delegate?.showQuestions()
            }
        cancellable.store(in: &cancellables)
    }
    
    func cancelRequests() {
        cancellables.forEach { $0.cancel() }
        cancellables.removeAll()
    }
}
