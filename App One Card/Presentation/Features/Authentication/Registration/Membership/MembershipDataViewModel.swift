//
//  MembershipDataViewModel.swift
//  App One Card
//
//  Created by Paolo Arambulo on 6/06/23.
//

import Foundation
import Combine

protocol MembershipDataViewModelProtocol {
    var docType: SelectModel? { get set }
    //var docNumber: String { get set }
    //var docRuc: String { get set }
    
    func showDocumentList(selected: SelectModel?, list: [SelectModel], action: @escaping SelectCustomActionHandler, presented: @escaping VoidActionHandler)
    func validateUser()
    func cancelRequests()
}

class MembershipDataViewModel: MembershipDataViewModelProtocol {
    private let router: AuthenticationRouterDelegate
    private let exampleUseCase: ExampleUseCase
    private var cancellables = Set<AnyCancellable>()
    
    var docType: SelectModel?
    //var docNumber: String = ""
    //var docRuc: String = ""
    
    init(router: AuthenticationRouterDelegate, exampleUseCase: ExampleUseCase) {
        self.router = router
        self.exampleUseCase = exampleUseCase
    }
    
    func showDocumentList(selected: SelectModel?, list: [SelectModel], action: @escaping SelectCustomActionHandler, presented: @escaping VoidActionHandler) {
        router.showDocumentList(selected: selected, list: list, action: action, presented: presented)
    }
    
    func validateUser() {
        let cancellable = exampleUseCase.validateUser()
            .sink { completion in
                switch completion {
                case .finished: break
                case .failure(_):
                    self.router.showMessageError()
                }
            } receiveValue: { example in
                DispatchQueue.main.async {
                    self.router.navigateToPersonalData()
                }
            }
        
        cancellable.store(in: &cancellables)
    }
    
    func cancelRequests() {
        cancellables.forEach { $0.cancel() }
        cancellables.removeAll()
    }
}
