//
//  PinViewModel.swift
//  App One Card
//
//  Created by Paolo Arambulo on 7/07/23.
//

import Foundation

protocol PinViewModelProtocol {
    var pin: String { get set }
    var newPin: String { get set }
    var pinStep: PinStep { get set }
    
    func nextStep()
    func validate()
    func reassign()
    func cardActivation()
}

class PinViewModel: PinViewModelProtocol {
    var success: PinActionHandler?
    var router: AuthenticationRouterDelegate
    
    private let cardUseCase: CardUseCase
    private let keyUseCase: KeyUseCase
    
    var pin: String = ""
    var newPin: String = ""
    var pinStep: PinStep
    
    init(router: AuthenticationRouterDelegate, cardUseCase: CardUseCase, keyUseCase: KeyUseCase, pinStep: PinStep) {
        self.router = router
        self.cardUseCase = cardUseCase
        self.keyUseCase = keyUseCase
        self.pinStep = pinStep
    }
    
    func nextStep() {
        switch pinStep {
        case .validate:
            validate()
        case .reassign:
            reassign()
        case .cardActivation:
            cardActivation()
        }
    }
    
    func validate() {
        let request = ValidateKeyRequest(segCode: "", pin: "", tLocal: "")
        
        keyUseCase.validate(request: request) { result in
            switch result {
            case .success(let response):
                DispatchQueue.main.async {
                    if response.rc == "447" {
                        self.router.showMessageError(title: "El PIN ingresado es incorrecto", description: "Por favor verifique el PIN", completion: nil)
                    } else if response.rc == "0" {
                        if let success = self.success {
                            success(self.pin)
                        }
                    }
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    self.router.showMessageError(title: error.title, description: error.description, completion: nil)
                }
            }
        }
    }
    
    func reassign() {
        let request = ValidateKeyRequest(segCode: "", pin: "", tLocal: "")
        
        keyUseCase.reassign(request: request) { result in
            switch result {
            case .success(let response):
                DispatchQueue.main.async {
                    if response.rc == "0" {
                        if let success = self.success {
                            success(self.pin)
                        }
                    }
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    self.router.showMessageError(title: error.title, description: error.description, completion: nil)
                }
            }
        }
    }
    
    func cardActivation() {
        let request = CardActivationRequest(segCode: "")
        
        cardUseCase.activation(request: request) { result in
            switch result {
            case .success(let response):
                DispatchQueue.main.async {
                    if response.rc == "0" {
                        if let success = self.success {
                            success(self.pin)
                        }
                    }
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    self.router.showMessageError(title: error.title, description: error.description, completion: nil)
                }
            }
        }
    }
}

enum PinStep {
    case validate
    case reassign
    case cardActivation
}
