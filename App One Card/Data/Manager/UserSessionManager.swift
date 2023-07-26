//
//  UserSessionManager.swift
//  App One Card
//
//  Created by Paolo Arambulo on 25/07/23.
//

import Foundation
import JWTDecode

protocol UserSessionManagerProtocol {
    func saveToken(token: String?)
    func getToken() -> String?
    func saveUser(user: User?)
    func getUser() -> User?
    func decodedJWT(jwt: String) -> User?
}


class UserSessionManager: UserSessionManagerProtocol {
    
    static let shared = UserSessionManager()
    
    private init() {}
    
    func saveToken(token: String?) {
        UserDefaults.standard.set(token, forKey: Constants.keyToken)
        UserDefaults.standard.synchronize()
    }
    
    func getToken() -> String? {
        if let token = UserDefaults.standard.string(forKey: Constants.keyToken) {
            return token
        } else {
            return nil
        }
    }
    
    func decodedJWT(jwt: String) -> User? {
        do {
            let jwt = try decode(jwt: jwt)
            let payload = jwt.body
            let user = User(user: payload["usuario"] as? String,
                            name: payload["nombreAfiliado"] as? String,
                            cardTrackingCode: payload["codigoSeguimientoTarjeta"] as? String,
                            authTrackingCode: payload["codigoSeguimientoAuth"] as? String)
            return user
        } catch {
            return nil
        }
    }
    
    func saveUser(user: User?) {
        UserObserver.shared.update(user: user)
        do {
            if let user = user {
                let encoder = JSONEncoder()
                let jsonData = try encoder.encode(user)
                UserDefaults.standard.set(jsonData, forKey: Constants.keyUser)
                UserDefaults.standard.synchronize()
            }
        }
        catch { }
    }
    
    func getUser() -> User? {
        if let jsonData = UserDefaults.standard.data(forKey: Constants.keyUser) {
            let decoder = JSONDecoder()
            if let userResponse = try? decoder.decode(User.self, from: jsonData) {
                return userResponse
            } else {
                return nil
            }
        } else {
            return nil
        }
    }
}
