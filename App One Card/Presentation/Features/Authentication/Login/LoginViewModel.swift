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
    func toForgotPassword()
    func toForgotUser()
    func login()
    func getStatusCard(token: String)
    func onAppear()
}

protocol LoginViewModelDelegate: LoaderDisplaying {}

class LoginViewModel: LoginViewModelProtocol {
    var delegate: LoginViewModelDelegate?
    var router: AuthenticationRouterDelegate
    var username: String = ""
    var password: String = ""
    
    private let userUseCase: UserUseCaseProtocol
    private let cardUseCase: CardUseCaseProtocol
    private let generalUseCase: GeneralUseCaseProtocol
    
    private var cancellables = Set<AnyCancellable>()
    
    init(router: AuthenticationRouterDelegate,
         userUseCase: UserUseCaseProtocol,
         cardUseCase: CardUseCaseProtocol,
         generalUseCase: GeneralUseCaseProtocol) {
        self.router = router
        self.userUseCase = userUseCase
        self.cardUseCase = cardUseCase
        self.generalUseCase = generalUseCase
    }
    
    deinit {
        cancelRequests()
    }
    
    func toRegister() {
        router.navigateToRegister()
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
                    case .failure(let apiError):
                        let error = apiError.error()
                        
                        self.delegate?.hideLoader()
                        self.delegate?.showError(title: error.title, description: error.description, onAccept: nil)
                    }
                } receiveValue: { response in
                    self.delegate?.hideLoader()
                    if response.success == "1" {
                        UserSessionManager.shared.saveToken(token: response.token ?? "")
                        let decodeUser = UserSessionManager.shared.decodedJWT(jwt: response.token ?? "")
                        UserSessionManager.shared.saveUser(user: decodeUser)
                        self.getStatusCard(token: response.token ?? "")
                    } else {
                        self.delegate?.showError(title: response.title ?? "", description: response.message ?? "", onAccept: nil)
                    }
                }
            cancellable.store(in: &cancellables)
        }
    }
    
    func getStatusCard(token: String) {
        delegate?.showLoader()
        
        let trackingCode = UserSessionManager.shared.getUser()?.cardTrackingCode ?? ""
        let cardStatusRequest = CardStatusRequest(trackingCode: trackingCode)
        let cancellable = cardUseCase.status(request: cardStatusRequest)
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
                    CardSessionManager.shared.saveStatus(status: StatusCard(rawValue: response.status ?? ""))
                    if response.status == StatusCard.NOT_ACTIVE.rawValue {
                        self.router.navigateToActivateUser()
                    } else if response.status == StatusCard.CANCEL.rawValue {
                        self.delegate?.showError(title: "Tarjeta inválida", description: "El estado de la tsrjeta es inválida para el inicio de sesión", onAccept: nil)
                    } else {
                        self.router.navigateToHome()
                    }
                } else {
                    UserSessionManager.shared.clearSession()
                    self.delegate?.showError(title: error.title, description: error.description, onAccept: nil)
                }
            }
        cancellable.store(in: &cancellables)
    }
    
    func toForgotPassword() {
        router.navigateToForgotPassword()
    }
    
    func toForgotUser() {
        router.navigateToForgotUser()
    }
    
    func onAppear() {
        defaultGeneralParameters()
        getGeneralParameters()
    }
    
    private func defaultGeneralParameters() {
        GeneralSessionManager.shared.saveLink(link: Constants.defaultLink, key: Constants.keyLinkRegister)
        GeneralSessionManager.shared.saveLink(link: Constants.defaultLink, key: Constants.keyLinkDataTreatment)
        GeneralSessionManager.shared.saveLink(link: Constants.defaultLink, key: Constants.keyLinkRecovery)
    }
    
    private func getGeneralParameters() {
        let cancellable = generalUseCase.getParameters()
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
                    GeneralSessionManager.shared.saveLink(link: response.termsRegister, key: Constants.keyLinkRegister)
                    GeneralSessionManager.shared.saveLink(link: response.termsDataTreatment, key: Constants.keyLinkDataTreatment)
                    GeneralSessionManager.shared.saveLink(link: response.termsRecovery, key: Constants.keyLinkRecovery)
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
