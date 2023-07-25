//
//  UserLocalRepository.swift
//  App One Card
//
//  Created by Paolo Arambulo on 23/07/23.
//

import Combine

protocol UserLocalRepository {
    func saveToken(token: String?)
    func getToken() -> String?
    func saveUser(user: User?)
    func getUser() -> User?
    func decodedJWT(jwt: String) -> User?
}
