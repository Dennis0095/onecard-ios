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
    var wasShownViewMovements: Bool { get set }
    
    func numberOfItems() -> Int
    func item(at index: Int) -> MovementResponse
    func isLast(at index: Int) -> Bool
    func selectItem(movement: MovementResponse)
    
    func consultMovements()
}

protocol MovementsViewModelDelegate: LoaderDisplaying {
    func successGetMovements()
    func failureGetMovements()
}

class MovementsViewModel: MovementsViewModelProtocol {
    
    var items: [MovementResponse] = []
    var router: HomeRouterDelegate
    var delegate: MovementsViewModelDelegate?
    var wasShownViewMovements: Bool = false
    
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
        delegate?.showLoader()
        
        let trackingCode = UserSessionManager.shared.getUser()?.cardTrackingCode ?? ""
        
        let request = ConsultMovementsRequest(trackingCode: trackingCode)
        
        let cancellable = movementUseCase.consult(request: request)
            .sink { publisher in
                switch publisher {
                case .finished: break
                case .failure(let error):
                    self.delegate?.hideLoader {
                        if !self.wasShownViewMovements {
                            self.delegate?.failureGetMovements()
                        } else {
                            self.delegate?.showError(title: error.title, description: error.description, onAccept: nil)
                        }
                    }
                }
            } receiveValue: { response in
                self.delegate?.hideLoader {
                    self.wasShownViewMovements = true
                    self.items = response.clientMovements ?? []
                    self.delegate?.successGetMovements()
                }
            }
        
        cancellable.store(in: &cancellables)
    }
    
    func cancelRequests() {
        cancellables.forEach { $0.cancel() }
        cancellables.removeAll()
    }
}
