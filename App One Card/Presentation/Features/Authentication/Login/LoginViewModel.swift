//
//  LoginViewModel.swift
//  App One Card
//
//  Created by Paolo Arambulo on 5/06/23.
//

import Combine

protocol LoginViewModelProtocol {
    var username: String { get set }
    var password: String { get set }
    var delegate: LoginViewModelDelegate? { get set }
    
    func toRegister()
    func toHome()
    func toActivateUser()
    func login()
    func getStatusCard(token: String)
}

protocol LoginViewModelDelegate: LoaderDisplaying {
    func successLogin()
    func toActivateUser()
}

class LoginViewModel: LoginViewModelProtocol {
    var delegate: LoginViewModelDelegate?
    var router: AuthenticationRouterDelegate
    var username: String = ""
    var password: String = ""
    
    private let userUseCase: UserUseCaseProtocol
    private let userLocalUseCase: UserLocalUseCaseProtocol
    private let cardUseCase: CardUseCaseProtocol
    private let cardLocalUseCase: CardLocalUseCaseProtocol
    
    private var cancellables = Set<AnyCancellable>()
    
    init(router: AuthenticationRouterDelegate, userUseCase: UserUseCaseProtocol, userLocalUseCase: UserLocalUseCaseProtocol, cardUseCase: CardUseCaseProtocol, cardLocalUseCase: CardLocalUseCaseProtocol) {
        self.router = router
        self.userUseCase = userUseCase
        self.cardUseCase = cardUseCase
        self.userLocalUseCase = userLocalUseCase
        self.cardLocalUseCase = cardLocalUseCase
    }
    
    deinit {
        cancelRequests()
    }
    
    func toRegister() {
        router.navigateToRegister()
    }
    
    func toHome() {
        router.navigateToHome()
    }
    
    func toActivateUser() {
        router.navigateToActivateUser()
    }
    
    func login() {
        if self.username.isEmpty || self.password.isEmpty {
            delegate?.showError(title: Constants.error, description: Constants.login_error_incomplete_data, onAccept: nil)
        } else {
            delegate?.showLoader()
            let request = LoginRequest(user: username, password: password)
            let cancellable = userUseCase.login(request: request)
                .sink { publisher in
                    switch publisher {
                    case .finished: break
                    case .failure(let error):
                        self.delegate?.hideLoader {
                            let error = CustomError(title: "Error", description: error.localizedDescription)
                            self.delegate?.showError(title: error.title, description: error.description, onAccept: nil)
                        }
                    }
                } receiveValue: { response in
                    self.delegate?.hideLoader {
                        if response.success == "1" {
                            self.getStatusCard(token: response.token ?? "")
                        } else {
                            self.delegate?.showError(title: response.title ?? "", description: response.message ?? "", onAccept: nil)
                        }
                    }
                }
            cancellable.store(in: &cancellables)
        }
    }
    
    func getStatusCard(token: String) {
        delegate?.showLoader()
        let cardStatusRequest = CardStatusRequest(segCode: "")
        let cancellable = cardUseCase.status(request: cardStatusRequest)
            .sink { publisher in
                switch publisher {
                case .finished: break
                case .failure(let error):
                    self.delegate?.hideLoader {
                        let error = CustomError(title: "Error", description: error.localizedDescription)
                        self.delegate?.showError(title: error.title, description: error.description, onAccept: nil)
                    }
                }
            } receiveValue: { response in
                self.delegate?.hideLoader {
                    if response.rc == "0" {
                        let user = self.userLocalUseCase.decodedJWT(jwt: token)
                        self.userLocalUseCase.saveToken(token: token)
                        self.userLocalUseCase.saveUser(user: user)
                        self.cardLocalUseCase.saveStatus(status: response.status)
                        
                        if response.status == "P" {
                            self.delegate?.toActivateUser()
                        } else {
                            self.delegate?.successLogin()
                        }
                    } else {
                        let error = CustomError(title: "Error", description: "Ocurrió un error")
                        self.delegate?.showError(title: error.title, description: error.description, onAccept: nil)
                    }
                }
            }
        cancellable.store(in: &cancellables)
    }
    
    func cancelRequests() {
        cancellables.forEach { $0.cancel() }
        cancellables.removeAll()
    }
}

enum StatusCard {
    case P
    case A
    case X
    case C
}
