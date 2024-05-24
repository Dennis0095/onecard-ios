//
//  PromotionsViewModel.swift
//  App One Card
//
//  Created by Paolo Arambulo on 19/07/23.
//

import Combine

protocol PromotionsViewModelProtocol {
    var wasShownViewPromotions: Bool { get set }
    var currentPage: Int { get set }
    var isLoadingPage: Bool { get set }
    var isLastPage: Bool { get set }
    var filter: String { get set }
    
    var items: [PromotionResponse] { get set }
    var router: PromotionsRouterDelegate { get set }
    var delegate: PromotionsViewModelDelegate? { get set }
    
    func numberOfItems() -> Int
    func item(at index: Int) -> PromotionResponse
    func isLast(at index: Int) -> Bool
    func paginate()
    func filterPromotions()
    func getDetail(promotionCode: String)
    func showFilters()
}

protocol PromotionsViewModelDelegate: LoaderDisplaying {
    func showPromotions()
    func failureShowPromotions(error: APIError)
}

class PromotionsViewModel: PromotionsViewModelProtocol {
    private let promotionUseCase: PromotionUseCaseProtocol
    private let promotionCategoriesUseCase: PromotionCategoriesUseCaseProtocol
    
    private var cancellables = Set<AnyCancellable>()
    
    var wasShownViewPromotions: Bool = false
    var isLoadingPage: Bool = false
    var currentPage: Int = 0
    var pageSize: Int = 10
    var isLastPage: Bool = false
    var filter: String = ""
    
    var items: [PromotionResponse] = []
    var router: PromotionsRouterDelegate
    var delegate: PromotionsViewModelDelegate?
    
    init(router: PromotionsRouterDelegate,
         promotionUseCase: PromotionUseCaseProtocol,
         promotionCategoriesUseCase: PromotionCategoriesUseCaseProtocol) {
        self.router = router
        self.promotionUseCase = promotionUseCase
        self.promotionCategoriesUseCase = promotionCategoriesUseCase
    }
    
    deinit {
        cancelRequests()
    }
    
    func numberOfItems() -> Int {
        return items.count
    }
    
    func item(at index: Int) -> PromotionResponse {
        return items[index]
    }
    
    func isLast(at index: Int) -> Bool {
        return (items.count - 1) == index
    }
    
    func showFilters() {
        if let categories = promotionCategoriesUseCase.getCategories() {
            router.toFilters(categories: categories)
        } else {
            let trackingCode = UserSessionManager.shared.getUser()?.authTrackingCode ?? ""
            let request = PromotionCategoriesRequest(authTrackingCode: trackingCode)
            promotionCategoriesUseCase.retryGetCategories(request: request) { [weak self] categories in
                self?.router.toFilters(categories: categories)
            }
        }
    }
    
    func paginate() {
        guard !isLastPage else { return }
        
        delegate?.showLoader()
        isLoadingPage = true
        
        let trackingCode = UserSessionManager.shared.getUser()?.authTrackingCode ?? ""
        let categoryFilterRequest = promotionCategoriesUseCase.getChoosedCategories()
        let request = ConsultPromotionsRequest(authTrackingCode: trackingCode,
                                               pageSize: String(pageSize),
                                               page: String(currentPage),
                                               filter: filter,
                                               categoryFilter: categoryFilterRequest)
        
        let cancellable = promotionUseCase.consult(request: request)
            .sink { publisher in
                switch publisher {
                case .finished: break
                case .failure(let apiError):
                    let error = apiError.error()
                    
                    self.delegate?.hideLoader()
                    self.isLoadingPage = false
                    switch apiError {
                    case .expiredSession:
                        self.delegate?.showError(title: error.title, description: error.description) {
                            self.router.logout(isManual: false)
                        }
                    default:
                        if !self.wasShownViewPromotions {
                            self.delegate?.failureShowPromotions(error: apiError)
                        } else {
                            self.delegate?.showError(title: error.title, description: error.description, onAccept: nil)
                        }
                    }
                }
            } receiveValue: { response in
                self.delegate?.hideLoader()
                self.isLoadingPage = false
                self.wasShownViewPromotions = true
                
                if (response.promotions ?? []).isEmpty || (response.promotions ?? []).count < self.pageSize {
                    self.isLastPage = true
                } else {
                    self.currentPage += 1
                }
                
                self.items += response.promotions ?? []
                self.delegate?.showPromotions()
            }
        cancellable.store(in: &cancellables)
    }
    
    func filterPromotions() { 
        currentPage = 0
        isLastPage = false
        
        delegate?.showLoader()
        isLoadingPage = true
        
        let trackingCode = UserSessionManager.shared.getUser()?.authTrackingCode ?? ""
        let categoryFilterRequest = promotionCategoriesUseCase.getChoosedCategories()
        let request = ConsultPromotionsRequest(authTrackingCode: trackingCode,
                                               pageSize: String(pageSize),
                                               page: String(currentPage),
                                               filter: filter,
                                               categoryFilter: categoryFilterRequest)
        let cancellable = promotionUseCase.consult(request: request)
            .sink { publisher in
                switch publisher {
                case .finished: break
                case .failure(let apiError):
                    let error = apiError.error()
                    
                    self.delegate?.hideLoader()
                    self.isLoadingPage = false
                    switch apiError {
                    case .expiredSession:
                        self.delegate?.showError(title: error.title, description: error.description) {
                            self.router.logout(isManual: false)
                        }
                    default:
                        if !self.wasShownViewPromotions {
                            self.delegate?.failureShowPromotions(error: apiError)
                        } else {
                            self.delegate?.showError(title: error.title, description: error.description, onAccept: nil)
                        }
                    }
                }
            } receiveValue: { response in
                self.delegate?.hideLoader()
                self.isLoadingPage = false
                self.wasShownViewPromotions = true
                
                if (response.promotions ?? []).isEmpty || (response.promotions ?? []).count < self.pageSize {
                    self.isLastPage = true
                } else {
                    self.currentPage += 1
                }
                
                self.items = response.promotions ?? []
                self.delegate?.showPromotions()
            }
        cancellable.store(in: &cancellables)
    }
    
    func getDetail(promotionCode: String) {
        delegate?.showLoader()
        let trackingCode = UserSessionManager.shared.getUser()?.authTrackingCode ?? ""
        let request = PromotionDetailRequest(authTrackingCode: trackingCode, promotionId: promotionCode)
        let cancellable = promotionUseCase.getDetail(request: request)
            .sink { [weak self] publisher in
                switch publisher {
                case .finished: break
                case .failure(let apiError):
                    let error = apiError.error()
                    
                    self?.delegate?.hideLoader()
                    switch apiError {
                    case .expiredSession:
                        self?.delegate?.showError(title: error.title, description: error.description) {
                            self?.router.logout(isManual: false)
                        }
                    default:
                        self?.delegate?.showError(title: error.title, description: error.description, onAccept: nil)
                    }
                }
            } receiveValue: { [weak self] response in
                self?.delegate?.hideLoader()
                
                if response.found == 1 {
                    self?.router.toPromotionDetail(detail: response)
                } else {
                    self?.delegate?.showError(title: response.title ?? "", description: response.message ?? "", onAccept: nil)
                }
            }
        cancellable.store(in: &cancellables)
    }
    
    func cancelRequests() {
        cancellables.forEach { $0.cancel() }
        cancellables.removeAll()
    }
}
