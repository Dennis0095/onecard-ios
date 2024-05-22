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
    func clearSession()
}


class UserSessionManager: UserSessionManagerProtocol {
    
    static let shared = UserSessionManager()
    
    private let defaults = UserDefaults.standard
    
    private init() {}
    
    func saveToken(token: String?) {
        defaults.set(token, forKey: Constants.keyToken)
        defaults.synchronize()
    }
    
    func getToken() -> String? {
        if let token = defaults.string(forKey: Constants.keyToken) {
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
                            authTrackingCode: payload["codigoSeguimientoAuth"] as? String, 
                            sex: payload["sexo"] as? String)
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
                defaults.set(jsonData, forKey: Constants.keyUser)
                defaults.synchronize()
            }
        }
        catch { }
    }
    
    func getUser() -> User? {
        if let jsonData = defaults.data(forKey: Constants.keyUser) {
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
    
    func clearSession() {
        // Remove all data from UserDefaults
        if let bundleIdentifier = Bundle.main.bundleIdentifier {
            defaults.removePersistentDomain(forName: bundleIdentifier)
            defaults.synchronize()
        }
        
        // Optionally, you can reset UserDefaults to an empty state
        // Uncomment the following lines if you want to do that
        /*
        let dictionary = defaults.dictionaryRepresentation()
        dictionary.keys.forEach { key in
            defaults.removeObject(forKey: key)
        }
        defaults.synchronize()
        */
    }
}
