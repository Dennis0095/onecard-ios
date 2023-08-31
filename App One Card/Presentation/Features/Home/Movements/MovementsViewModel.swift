//
//  MovementsViewModel.swift
//  App One Card
//
//  Created by Paolo Arambulo on 2/07/23.
//

import UIKit
import Combine

protocol MovementsViewModelProtocol {
    var items: [MovementResponse] { get set }
    var currentPage: Int { get set }
    var isLoadingPage: Bool { get set }
    var isLastPage: Bool { get set }
    var wasShownViewMovements: Bool { get set }
    
    func numberOfItems() -> Int
    func item(at index: Int) -> MovementResponse
    func isLast(at index: Int) -> Bool
    func selectItem(movement: MovementResponse)
    
    func consultMovements()
    func consultLastMovements()
}

protocol MovementsViewModelDelegate: LoaderDisplaying {
    func successGetMovements()
    func failureGetMovements(error: APIError)
}

class MovementsViewModel: MovementsViewModelProtocol {
    
    var items: [MovementResponse] = []
    var router: HomeRouterDelegate
    var delegate: MovementsViewModelDelegate?
    var wasShownViewMovements: Bool = false
    var isLoadingPage: Bool = false
    var currentPage: Int = 1
    var pageSize: Int = 20
    var isLastPage: Bool = false
    
    private var cancellables = Set<AnyCancellable>()
    
    private let movementUseCase: MovementUseCaseProtocol
    
    init(router: HomeRouterDelegate, movementUseCase: MovementUseCaseProtocol) {
        self.router = router
        self.movementUseCase = movementUseCase
    }
    
    deinit {
        cancelRequests()
    }
    
    func numberOfItems() -> Int {
        return items.count
    }
    
    func item(at index: Int) -> MovementResponse {
        return items[index]
    }
    
    func isLast(at index: Int) -> Bool {
        return (items.count - 1) == index
    }
    
    func selectItem(movement: MovementResponse) {
        router.navigateToMovementDetail(movement: movement)
    }
    
    func consultMovements() {
        self.delegate?.showLoader()
        isLoadingPage = true
        
        let trackingCode = UserSessionManager.shared.getUser()?.cardTrackingCode ?? ""
        
        let request = ConsultMovementsRequest(trackingCode: trackingCode)
        let paginateRequest = MovementsHistoryRequest(trackingCode: trackingCode, pageSize: String(pageSize), page: String(currentPage))

        let cancellable = Publishers.Zip(
            movementUseCase.consult(request: request),
            movementUseCase.paginate(request: paginateRequest)
        )
            .sink { publisher in
                switch publisher {
                case .finished: break
                case .failure(let apiError):
                    let error = apiError.error()
                    
                    self.delegate?.hideLoader()
                    self.isLoadingPage = false
                    if !self.wasShownViewMovements {
                        self.delegate?.failureGetMovements(error: apiError)
                    } else {
                        self.delegate?.showError(title: error.title, description: error.description, onAccept: nil)
                    }
                }
            } receiveValue: { response in
                let apiError = APIError.defaultError
                let error = APIError.defaultError.error()
                
                self.delegate?.hideLoader()
                self.isLoadingPage = false
                
                let consultResponse = response.0
                let paginateResponse = response.1
                
                if consultResponse.rc == "0" && paginateResponse.rc == "0" {
                    let firstMovements = consultResponse.clientMovements ?? []
                    let lastMovements = paginateResponse.clientMovements ?? []
                    
                    self.wasShownViewMovements = true
                    
                    if (firstMovements + lastMovements).isEmpty {
                        self.isLastPage = true
                    } else {
                        self.currentPage += 1
                    }
                    
                    self.items += (firstMovements + lastMovements)
                    self.delegate?.successGetMovements()
                } else {
                    if !self.wasShownViewMovements {
                        self.delegate?.failureGetMovements(error: apiError)
                    } else {
                        self.delegate?.showError(title: error.title, description: error.description, onAccept: nil)
                    }
                }
            }
        
        cancellable.store(in: &cancellables)
    }
    
    func consultLastMovements() {
        guard !isLastPage else { return }
        
        delegate?.showLoader()
        isLoadingPage = true
        
        let trackingCode = UserSessionManager.shared.getUser()?.cardTrackingCode ?? ""
        
        let request = MovementsHistoryRequest(trackingCode: trackingCode, pageSize: String(pageSize), page: String(currentPage))
        
        let cancellable = movementUseCase.paginate(request: request)
            .sink { publisher in
                switch publisher {
                case .finished: break
                case .failure(let apiError):
                    let error = apiError.error()
                    
                    self.delegate?.hideLoader()
                    self.isLoadingPage = false
                    if !self.wasShownViewMovements {
                        self.delegate?.failureGetMovements(error: apiError)
                    } else {
                        self.delegate?.showError(title: error.title, description: error.description, onAccept: nil)
                    }
                }
            } receiveValue: { response in
                self.delegate?.hideLoader()
                self.isLoadingPage = false
                self.wasShownViewMovements = true
                
                if (response.clientMovements ?? []).isEmpty {
                    self.isLastPage = true
                } else {
                    self.currentPage += 1
                }
                
                let filterItems = (self.pageSize == 2 || self.pageSize == 3) ? (response.clientMovements ?? []).filter { a in
                    return self.items.contains { b in
                        return (a.sequence != b.sequence) && (a.hour != b.hour) && (a.date != b.date)//filteringObject.id == objectToFilter.id
                    }
                } : response.clientMovements ?? []
                
                self.items += filterItems
                self.delegate?.successGetMovements()
            }
        
        cancellable.store(in: &cancellables)
    }
    
    func cancelRequests() {
        cancellables.forEach { $0.cancel() }
        cancellables.removeAll()
    }
}
