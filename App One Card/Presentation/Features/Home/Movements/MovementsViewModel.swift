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
                
                if self.pageSize < (response.clientMovements?.count ?? 0) {
                    self.isLastPage = true
                } else {
                    self.currentPage += 1
                }
                
                self.items += response.clientMovements ?? []
                self.delegate?.successGetMovements()
            }
        
        cancellable.store(in: &cancellables)
    }
    
    func cancelRequests() {
        cancellables.forEach { $0.cancel() }
        cancellables.removeAll()
    }
}
