//
//  PinViewModel.swift
//  App One Card
//
//  Created by Paolo Arambulo on 7/07/23.
//

import Foundation
import Combine

protocol PinViewModelProtocol {
    var pin: String { get set }
    var newPin: String { get set }
    var pinStep: PinStep { get set }
    var delegate: PinViewModelDelegate? { get set }
    
    func nextStep()
    func validate()
    func reassign(isCardActivation: Bool)
    func cardActivation()
}

protocol PinViewModelDelegate: LoaderDisplaying {}

class PinViewModel: PinViewModelProtocol {
    var delegate: PinViewModelDelegate?
    var success: PinActionHandler?
    var router: AuthenticationRouterDelegate
    
    private let cardUseCase: CardUseCase
    private let keyUseCase: KeyUseCase
    
    private var cancellables = Set<AnyCancellable>()
    
    var pin: String = ""
    var newPin: String = ""
    var pinStep: PinStep
    
    init(router: AuthenticationRouterDelegate, cardUseCase: CardUseCase, keyUseCase: KeyUseCase, pinStep: PinStep) {
        self.router = router
        self.cardUseCase = cardUseCase
        self.keyUseCase = keyUseCase
        self.pinStep = pinStep
    }
    
    deinit {
        cancelRequests()
    }
    
    func nextStep() {
        switch pinStep {
        case .validate:
            validate()
        case .reassign:
            reassign(isCardActivation: false)
        case .cardActivation:
            reassign(isCardActivation: true)
        case .nothing:
            if let success = self.success {
                success(self.pin)
            }
        }
    }
    
    func validate() {
        self.delegate?.showLoader()
        
        let trackingCode = UserSessionManager.shared.getUser()?.cardTrackingCode ?? ""
        
        let request = ValidateKeyRequest(cardTrackingCode: trackingCode, pin: "1234", tLocal: "20230511")
        let cancellable = keyUseCase.validate(request: request)
            .sink { publisher in
                switch publisher {
                case .finished: break
                case .failure(let apiError):
                    let error = apiError.error()
                    
                    self.delegate?.hideLoader()
                    self.delegate?.showError(title: error.title, description: error.description, onAccept: nil)
                }
            } receiveValue: { response in
                self.delegate?.hideLoader()
                if response.rc == "447" {
                    self.delegate?.showError(title: "El PIN ingresado es incorrecto", description: "Por favor verifique el PIN", onAccept: nil)
                } else if response.rc == "0" {
                    if let success = self.success {
                        success(self.pin)
                    }
                }
            }
        
        cancellable.store(in: &cancellables)
    }
    
    func reassign(isCardActivation: Bool) {
        self.delegate?.showLoader()
        
        let request = ReassignKeyRequest(operationId: "", trackingCode: "", pin: "", tLocal: "")
        
        let cancellable = keyUseCase.reassign(request: request)
            .sink { publisher in
                switch publisher {
                case .finished: break
                case .failure(let apiError):
                    let error = apiError.error()
                    
                    self.delegate?.hideLoader()
                    self.delegate?.showError(title: error.title, description: error.description, onAccept: nil)
                }
            } receiveValue: { response in
                let error = APIError.defaultError.error()
                
                self.delegate?.hideLoader()
                if response.rc == "0" {
                    if isCardActivation {
                        self.cardActivation()
                    } else {
                        if let success = self.success {
                            success(self.pin)
                        }
                    }
                } else {
                    self.delegate?.showError(title: error.title, description: error.description, onAccept: nil)
                }
            }
        
        cancellable.store(in: &cancellables)
    }
    
    func cardActivation() {
        self.delegate?.showLoader()
        
        let request = CardActivationRequest(trackingCode: "")
        let cancellable = cardUseCase.activation(request: request)
            .sink { publisher in
                switch publisher {
                case .finished: break
                case .failure(let apiError):
                    let error = apiError.error()
                    
                    self.delegate?.hideLoader()
                    self.delegate?.showError(title: error.title, description: error.description, onAccept: nil)
                }
            } receiveValue: { response in
                let error = APIError.defaultError.error()
                self.delegate?.hideLoader()
                if response.rc == "0" {
                    CardSessionManager.shared.saveStatus(status: .ACTIVE)
                    if let success = self.success {
                        success(self.pin)
                    }
                } else {
                    self.delegate?.showError(title: error.title, description: error.description, onAccept: nil)
                }
            }
        
        cancellable.store(in: &cancellables)
    }

    func cancelRequests() {
        cancellables.forEach { $0.cancel() }
        cancellables.removeAll()
    }
}

enum PinStep {
    case validate
    case reassign
    case cardActivation
    case nothing
}
