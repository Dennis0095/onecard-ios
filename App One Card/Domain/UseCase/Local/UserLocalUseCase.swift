//
//  UserLocalUseCase.swift
//  App One Card
//
//  Created by Paolo Arambulo on 23/07/23.
//

//import Foundation
//
//protocol UserLocalUseCaseProtocol {
//    func saveToken(token: String?)
//    func getToken() -> String?
//    func saveUser(user: User?)
//    func getUser() -> User?
//    func decodedJWT(jwt: String) -> User?
//}
//
//class UserLocalUseCase: UserLocalUseCaseProtocol {
//    private let userLocalRepository: UserLocalRepository
//    
//    init(userLocalRepository: UserLocalRepository) {
//        self.userLocalRepository = userLocalRepository
//    }
//    
//    func saveToken(token: String?) {
//        userLocalRepository.saveToken(token: token)
//    }
//    
//    func getToken() -> String? {
//        return userLocalRepository.getToken()
//    }
//    
//    func saveUser(user: User?) {
//        userLocalRepository.saveUser(user: user)
//    }
//    
//    func getUser() -> User? {
//        return userLocalRepository.getUser()
//    }
//    
//    func decodedJWT(jwt: String) -> User? {
//        return userLocalRepository.decodedJWT(jwt: jwt)
//    }
//}
